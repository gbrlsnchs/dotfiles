local winpick = require("winpick")
local Path = require("plenary.path")

local fuzzy = require("lib.fuzzy")
local db = require("lib.db")
local session = require("lib.session")
local logger = require("lib.logger")

local api = vim.api
local action_types = fuzzy.action_types
local project_id = session.get_project_id()

local function open_file(filename)
	if not filename then
		return
	end

	local cmd
	local pick_win = true
	local action = fuzzy.get_action()

	if action == action_types.C_X then
		cmd = "split | edit"
	elseif action == action_types.C_V then
		cmd = "vsplit | edit"
	elseif action == action_types.C_T then
		cmd = "tabnew"
		pick_win = false
	else
		cmd = "edit"
	end

	if pick_win and not winpick.pick_window() then
		return
	end

	cmd = ("%s %s"):format(cmd, filename)

	logger.debugf("Opening file with command %q", cmd)

	vim.cmd(cmd)
end

local function is_local_file(cwd, fname)
	return vim.fn.matchstrpos(fname, cwd)[2] ~= -1 and vim.fn.filereadable(fname) ~= 0
end

local function get_project_oldfiles()
	local cwd = vim.loop.cwd()
	local oldfiles = vim.v.oldfiles

	oldfiles = vim.tbl_filter(function(fname)
		return is_local_file(cwd, fname)
	end, oldfiles)

	oldfiles = vim.tbl_map(function(fname)
		return Path:new(fname):make_relative(cwd)
	end, oldfiles)

	local denylist = { ".git/" }
	oldfiles = vim.tbl_filter(function(fname)
		for _, prefix in ipairs(denylist) do
			if fname:find("^" .. prefix) ~= nil then
				return false
			end
		end
		return true
	end, oldfiles)

	return oldfiles
end

local function wrap_opts(prompt)
	return {
		prompt = prompt,
		actions = { action_types.C_X, action_types.C_V, action_types.C_T },
		index_items = false,
	}
end

local M = {}

function M.find(dir)
	dir = dir or "."

	local cmd = ("fd --full-path --hidden --no-ignore-vcs --color=always %s"):format(dir)
	local opts = wrap_opts("Files:")

	vim.ui.select(cmd, opts, open_file)
end

function M.find_dirty(dir)
	dir = dir or "."

	local cmd = ("git ls-files --modified --others --exclude-standard %s"):format(dir)
	local opts = wrap_opts("Dirty files: ")

	vim.ui.select(cmd, opts, open_file)
end

function M.find_oldfiles()
	local result, err = db.exec_stmt(
		"SELECT path FROM oldfiles WHERE project_id = ? ORDER BY hits DESC, last_hit DESC",
		project_id
	)
	if err then
		logger.errorf("Could not query recent files: %q", err)
		return
	end

	local oldfiles = vim.tbl_map(function(row)
		return row.path
	end, result.rows)
	local opts = wrap_opts("Recent files: ")

	vim.ui.select(oldfiles, opts, open_file)
end

function M.increment_view_count()
	local is_text_buf = api.nvim_buf_get_option(0, "buftype") == ""
	if not is_text_buf then
		return
	end

	local path = Path:new(api.nvim_buf_get_name(0))
	local fname = path:make_relative()

	if fname == "" or fname:find("^/") ~= nil or path:is_dir() then
		return
	end

	local result, err

	result, err = db.exec_stmt(
		"INSERT OR IGNORE INTO oldfiles (project_id, path) VALUES (?, ?)",
		project_id,
		fname
	)
	if err then
		logger.errorf("Error when inserting new oldfile %q: %q", fname, err)
		return
	end

	if result.count > 0 then
		return
	end

	_, err = db.exec_stmt(
		"UPDATE oldfiles SET hits = hits + 1, last_hit = CURRENT_TIMESTAMP WHERE project_id = ? AND path = ?",
		project_id,
		fname
	)
	if err then
		logger.errorf("Error while updating oldfile %q: %q", fname, err)
	end
end

function M.check_view_entry()
	local fullpath = api.nvim_buf_get_name(0)

	if vim.fn.empty(fullpath) or vim.fn.filereadable(fullpath) then
		return
	end

	local path = Path:new(api.nvim_buf_get_name(0)):make_relative()
	local _, err = db.exec_stmt(
		"DELETE FROM oldfiles WHERE project_id = ? AND path = ?",
		project_id,
		path
	)
	if err then
		logger.warnf("Could not remove entry for %q: %q", path, err)
	end
end

function M.init_session()
	local result, err

	result, err = db.exec_stmt(
		"SELECT COUNT(*) AS count FROM oldfiles WHERE project_id = ?",
		project_id
	)
	if err then
		logger.errorf("Could not count oldfiles: %q", err)
		return
	end

	if result.rows[1].count == 0 then
		logger.info("Filling oldfiles with existing data")

		local oldfiles = get_project_oldfiles()
		if #oldfiles == 0 then
			return
		end

		local values = {}
		local args = {}
		for _, path in ipairs(oldfiles) do
			table.insert(values, "(?, ?)")
			table.insert(args, project_id)
			table.insert(args, path)
		end

		local query = ([[
INSERT INTO oldfiles (project_id, path)
VALUES
	%s
]]):format(table.concat(values, ",\n\t"))

		_, err = db.exec_stmt(query, args)
		if err then
			logger.errorf("Could not fill oldfiles with existing data: %q", err)
		end
	end
end

return M

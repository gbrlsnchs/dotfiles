local Path = require("plenary.path")

local db = require("me.api.db")

local api = vim.api
local cwd = vim.loop.cwd()

local oldfiles_excludes = {
	".git/",
}

local function is_file_allowed(relative_path)
	for _, prefix in ipairs(oldfiles_excludes) do
		if relative_path:find("^" .. prefix) ~= nil then
			return false
		end
	end
	return true
end

local function get_builtin()
	local oldfiles = vim.v.oldfiles

	oldfiles = vim.tbl_filter(function(fname)
		-- Checks whether the file belongs to current project.
		return vim.fn.matchstrpos(fname, cwd)[2] ~= -1 and vim.fn.filereadable(fname) ~= 0
	end, oldfiles)

	oldfiles = vim.tbl_map(function(fname)
		return Path:new(fname):make_relative(cwd)
	end, oldfiles)

	oldfiles = vim.tbl_filter(function(fname)
		for _, prefix in ipairs(oldfiles_excludes) do
			if fname:find("^" .. prefix) ~= nil then
				return false
			end
		end
		return true
	end, oldfiles)

	return oldfiles
end

local M = {}

function M.init(project_name)
	local result, err

	result, err =
		db.exec_stmt("SELECT COUNT(*) AS count FROM oldfiles WHERE project_name = ?", project_name)
	if err then
		vim.notify("Could not retrieve count of oldfiles: " .. err, vim.log.levels.ERROR)
		return false
	end

	if result.rows[1].count > 0 then
		return true
	end

	vim.notify("Filling oldfiles with Neovim's own data")

	local oldfiles = get_builtin()
	if #oldfiles == 0 then
		vim.notify("No oldfiles data found")
		return true
	end

	local values = {}
	local args = {}
	for _, path in ipairs(oldfiles) do
		table.insert(values, "(?, ?)")
		table.insert(args, project_name)
		table.insert(args, path)
	end

	local query = string.format(
		[[
INSERT INTO oldfiles (project_name, path)
VALUES
	%s
]],
		table.concat(values, ",\n\t")
	)

	_, err = db.exec_stmt(query, unpack(args))
	if err then
		vim.notify("Could not fill oldfiles: " .. err, vim.log.levels.ERROR)
		return false
	end

	return true
end

function M.upsert_hits(project_name)
	local is_text_buf = api.nvim_buf_get_option(0, "buftype"):len() == 0
	if not is_text_buf then
		return true, nil
	end

	local path = Path:new(api.nvim_buf_get_name(0))
	local fname = path:make_relative()

	if
		fname:len() == 0
		or fname:find("^/") ~= nil
		or not is_file_allowed(fname)
		or path:is_dir()
	then
		return true, nil
	end

	local result, err

	result, err = db.exec_stmt(
		"INSERT OR IGNORE INTO oldfiles (project_name, path) VALUES (?, ?)",
		project_name,
		fname
	)
	if err then
		return false, err
	end

	if result.count > 0 then
		return true, nil
	end

	_, err = db.exec_stmt(
		"UPDATE oldfiles SET hits = hits + 1, last_hit = CURRENT_TIMESTAMP WHERE project_name = ? AND path = ?",
		project_name,
		fname
	)

	return err == nil, err
end

return M

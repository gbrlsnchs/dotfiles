local winpick = require("winpick")

local win = require("me.api.win")
local session = require("me.api.session")
local db = require("me.api.db")

local actions = { "ctrl-x", "ctrl-v", "ctrl-t" }

local function open_file(filename)
	return function(action)
		if not filename then
			return
		end

		local cmd
		local pick_win = true

		if action == "ctrl-x" then
			cmd = "split | edit"
		elseif action == "ctrl-v" then
			cmd = "vsplit | edit"
		elseif action == "ctrl-t" then
			cmd = "tabnew"
			pick_win = false
		else
			cmd = "edit"
		end

		if pick_win and not win.focus(winpick.select()) then
			return
		end

		vim.cmd(string.format("%s %s", cmd, filename))
	end
end

local M = {}

--- Finds a file relative to 'base_dir'.
--- @param base_dir string: Base directory for the search.
function M.find(base_dir)
	if not base_dir or (base_dir and base_dir:len() == 0) then
		base_dir = "./"
	end

	local cmd = string.format("fd --hidden --no-ignore-vcs --color=always . '%s'", base_dir)
	local opts = {
		prompt = "Files:",
		index_items = false,
		actions = actions,
	}

	vim.ui.select(cmd, opts, open_file)
end

--- Finds files that have been changed.
--- @param base_dir string: Base directory for the search.
function M.find_changed(base_dir)
	if not base_dir or (base_dir and base_dir:len() == 0) then
		base_dir = "."
	end

	local cmd = string.format("git ls-files --modified --others --exclude-standard %s", base_dir)
	local opts = {
		prompt = "Changed files:",
		index_items = false,
		actions = actions,
	}

	vim.ui.select(cmd, opts, open_file)
end

--- Finds oldfiles sorted by relevance.
function M.find_oldfiles()
	local project_name = session.get_option("project_name")
	if not project_name then
		vim.notify("Could not retrieve oldfiles because there's not project name set")
		return
	end

	local result, err = db.exec_stmt(
		"SELECT path FROM oldfiles WHERE project_name = ? ORDER BY last_hit DESC, hits DESC LIMIT 50",
		project_name
	)
	if err then
		vim.notify("Could not fetch oldfiles: " .. err, vim.log.levels.ERROR)
		return
	end

	local oldfiles = vim.tbl_map(function(row)
		return row.path
	end, result.rows)

	local opts = {
		prompt = "Recent files:",
		index_items = false,
		actions = actions,
		sort = false,
	}

	vim.ui.select(oldfiles, opts, open_file)
end

return M

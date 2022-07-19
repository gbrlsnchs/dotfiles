local winpick = require("winpick")

local win = require("me.api.win")
local session = require("me.api.session")
local db = require("me.api.db")

local actions = { "ctrl-x", "ctrl-v", "ctrl-t", "ctrl-d" }
local project_name = session.get_option("project_name")

--- Deletes an oldfile from the database.
--- @param filename string: Name of the file to be deleted.
local function delete_oldfile(filename)
	if not project_name then
		return
	end

	local _, err = db.exec_stmt(
		"DELETE FROM oldfiles WHERE project_name = ? AND path = ?",
		project_name,
		filename
	)

	if err then
		vim.notify("Could not delete oldfile entry: " .. err, vim.log.levels.ERROR)
	end
end

--- Wrapper for the action handler for opening files.
--- @param filename string | nil: Name of the chosen file.
--- @param is_oldfile boolean: Whether the file is an oldfile.
--- @return function: The action handler.
local function open_file(filename, is_oldfile)
	return function(action)
		if not filename then
			return
		end

		filename = filename:gsub("^%./", "")

		local cmd
		local pick_win = true

		if action == "ctrl-x" then
			cmd = "split | edit"
		elseif action == "ctrl-v" then
			cmd = "vsplit | edit"
		elseif action == "ctrl-t" then
			cmd = "tabnew"
			pick_win = false
		elseif action == "ctrl-d" then
			cmd = "bdelete"
			pick_win = false

			if is_oldfile then
				delete_oldfile(filename)
			end
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

	vim.ui.select(oldfiles, opts, function(filename)
		return open_file(filename, true)
	end)
end

return M

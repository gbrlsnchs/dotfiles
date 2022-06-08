local winpick = require("winpick")

local win = require("me.api.win")

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

-- TODO: New oldfiles.

return M

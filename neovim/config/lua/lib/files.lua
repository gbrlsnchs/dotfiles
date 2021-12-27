local winpick = require("winpick")

local fuzzy = require("lib.fuzzy")
local logger = require("lib.logger")

local action_types = fuzzy.action_types

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

function M.find_recent()
	-- TODO: Use SQLite + frecency algorithm.
end

return M

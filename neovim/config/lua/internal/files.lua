local winpick = require("winpick")

local tables = require("internal.tables")
local logger = require("lib.logger")

local M = {}

M.directions = tables.readonly({
	HORIZONTAL = 0,
	VERTICAL = 1,
	TAB = 2,
})

function M.open(filename, direction)
	local cmd
	local pick_win = true
	if direction == M.directions.HORIZONTAL then
		cmd = "split | edit"
	elseif direction == M.directions.VERTICAL then
		cmd = "vsplit | edit"
	elseif direction == M.directions.TAB then
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

return M

local winpick = require("winpick")

local tables = require("internal.tables")

local M = {}

M.directions = tables.readonly({
	HORIZONTAL = 0,
	VERTICAL = 1,
	TAB = 2,
})

function M.open(filename, direction)
	local cmd
	if direction == M.directions.HORIZONTAL then
		cmd = "split +edit"
	elseif direction == M.directions.VERTICAL then
		cmd = "vsplit +edit"
	elseif direction == M.directions.TAB then
		cmd = "tabnew"
	else
		cmd = "edit"
	end

	if not winpick.pick_window() then
		return
	end

	vim.cmd(("%s %s"):format(cmd, filename))
end

return M

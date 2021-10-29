local tables = require("internal.tables")
local windows = require("internal.windows")

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

	vim.cmd(("%s %s"):format(cmd, filename))
end

function M.open_in_win(filename)
	if windows.pick_window() then
		M.open(filename)
	end
end

return M

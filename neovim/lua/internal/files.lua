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
	local winid = windows.pick_window()
	vim.api.nvim_set_current_win(winid)
	M.open(filename)
end

return M

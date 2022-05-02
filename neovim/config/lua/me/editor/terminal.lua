local winpick = require("winpick")

local M = {}

function M.open(orientation)
	local precmd
	local pick_win = true

	if orientation == "horizontal" then
		precmd = "split"
	elseif orientation == "vertical" then
		precmd = "vsplit"
	elseif orientation == "tab" then
		precmd = "tabnew"
		pick_win = false
	end

	local cmd = "terminal"
	if precmd then
		cmd = string.format("%s +%s", precmd, cmd)
	end

	if pick_win and not winpick.focus() then
		return
	end

	vim.cmd(cmd)
	vim.cmd("startinsert")
end

return M

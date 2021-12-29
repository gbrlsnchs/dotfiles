local winpick = require("winpick")

local enums = require("lib.enums")

local orientations = enums.orientations

local M = {}

function M.open(orientation)
	local precmd
	local pick_win = true

	if orientation == orientations.horizontal then
		precmd = "split"
	elseif orientation == orientations.vertical then
		precmd = "vsplit"
	elseif orientation == orientations.tabnew then
		precmd = "tabnew"
		pick_win = false
	end

	if pick_win and not winpick.pick_window() then
		return
	end

	local cmd = "terminal"
	if precmd then
		cmd = ("%s +%s"):format(precmd, cmd)
	end

	vim.cmd(cmd)
end

return M

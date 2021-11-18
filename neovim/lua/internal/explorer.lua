local winpick = require("winpick")

local M = {}

local function open(cmd)
	local cd = vim.fn.expand("%:h")
	if winpick.pick_window() then
		vim.cmd(("%s %s"):format(cmd, cd))
	end
end

function M.open()
	open("Explore")
end

function M.open_horizontal()
	open("Sexplore")
end

function M.open_vertical()
	open("Vexplore")
end

function M.open_tab()
	open("Texplore")
end

return M

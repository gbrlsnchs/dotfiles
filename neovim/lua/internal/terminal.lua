local winpick = require("winpick")

local Prompt = require("internal.prompt")

local M = {}

local function create(cmd)
	if winpick.pick_window() then
		vim.cmd(cmd)
	end
end

function M.create()
	create("terminal")
end

function M.create_horizontal()
	create("split +terminal")
end

function M.create_vertical()
	create("vsplit +terminal")
end

function M.create_tab()
	create("tabedit +terminal")
end

return M

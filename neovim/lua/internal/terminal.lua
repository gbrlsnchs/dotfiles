local buffers = require("internal.buffers")
local Prompt = require("internal.prompt")

local M = {}

local function create_named(open_fn)
	local name = Prompt:new():input("Terminal name: ")

	open_fn(function()
		vim.cmd("terminal")
		vim.api.nvim_buf_set_var(0, "term_name", name)
	end)
end

function M.create()
	create_named(buffers.open)
end

function M.create_horizontal()
	create_named(buffers.open_horizontal)
end

function M.create_vertical()
	create_named(buffers.open_vertical)
end

function M.create_tab()
	create_named(buffers.open_tab)
end

return M

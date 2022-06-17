local Builder = require("byob.builder")

local api = vim.api

local focused_win
local bars_tbl = {}

local augroup = api.nvim_create_augroup("bars", {})

local M = {}

function M.new(hl_prefix)
	return Builder:new(hl_prefix)
end

function M.stringify(opt_name)
	return bars_tbl[opt_name]:build(
		api.nvim_get_current_win() == focused_win
	)
end

function M.setup(bars)
	bars_tbl = bars

	for bar in pairs(bars) do
		vim.opt[bar] = [[%{%v:lua.require('byob').stringify(']] .. bar .. [[')%}]]
	end

	api.nvim_create_autocmd({ "VimEnter", "WinEnter", "WinLeave" }, {
		group = augroup,
		callback = function()
			focused_win = api.nvim_get_current_win()
		end,
	})
end

return M

local win = require("me.api.win")

local api = vim.api

local bars = {}

local M = {}

function M.set(name, builder)
	bars[name] = builder
end

function M.get(name)
	return bars[name]:build(api.nvim_get_current_win() == win.get_focused())
end

return M

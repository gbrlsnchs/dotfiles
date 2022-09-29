local config = require("me.api.config")

if not config.get("lsp", "enabled") then
	vim.notify("LSP functionality is disabled", vim.log.levels.WARN)
	return true
end

local util = require("me.api.util")

util.packadd("nvim-lspconfig")
util.packadd("null-ls.nvim")

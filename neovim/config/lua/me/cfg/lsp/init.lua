local config = require("me.api.config")

config.set("lsp", {
	enabled = true,
	denylist = {},
	overrides = {},
	folders = {},
	inlay_hints = true,
})

if not config.get("lsp", "enabled") then
	error("LSP module is disabled")
end

local util = require("me.api.util")

util.packadd("nvim-lspconfig")

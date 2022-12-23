local config = require("me.api.config")

config.set("lsp", {
	enabled = true,
	servers = {},
	inlay_hints = true,
})

if not config.get("lsp", "enabled") then
	error("LSP module is disabled")
end

local util = require("me.api.util")

local function override_handler(handler, fn, opts)
	vim.lsp.handlers[handler] = vim.lsp.with(fn, opts)
end

local M = {}

--- Sets up LSP.
--- @param opts table: Table of options for LSP.
function M.setup(opts)
	opts = util.tbl_merge(opts, {
		disabled = false,
		denylist = {},
		overrides = {},
		folders = {},
	})

	if opts.disabled then
		vim.notify("LSP functionality is disabled", vim.log.levels.WARN)
		return
	end

	util.packadd("nvim-lspconfig")
	util.packadd("null-ls.nvim")

	local lsp_configs = require("me.cfg.lsp.configs")

	override_handler("textDocument/hover", vim.lsp.handlers.hover, { border = "single" })
	override_handler("textDocument/signatureHelp", vim.lsp.handlers.signature_help, { border = "single" })

	lsp_configs.setup(opts)
end

return M

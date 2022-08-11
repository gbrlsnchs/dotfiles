local util = require("me.api.util")

local function wrap_handler(method, opts)
	local fn = vim.lsp.handlers[method]

	vim.lsp.handlers[method] = vim.lsp.with(fn, opts)
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

	wrap_handler("textDocument/hover", { border = "single" })
	wrap_handler("textDocument/signatureHelp", { border = "single" })

	lsp_configs.setup(opts)
end

return M

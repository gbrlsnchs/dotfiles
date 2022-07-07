local nvim_lspconfig = require("lspconfig")
local null_ls = require("null-ls")

local util = require("me.api.util")

local lsp_commands = require("me.cfg.lsp.commands")

-- Language settings.
local defaults = {
	gopls = require("me.cfg.lsp.configs.gopls"),
	jdtls = require("me.cfg.lsp.configs.jdtls"),
	rust_analyzer = require("me.cfg.lsp.configs.rust_analyzer"),
	sumneko_lua = require("me.cfg.lsp.configs.sumneko_lua"),
}

--- Returns a list of sources based on whether their respective binaries are installed.
--- @param exes table: Map of binaries and their respective 'null-ls' sources.
--- @return table: Table of configured sources.
local function make_sources(exes)
	local sources = {}

	for exe, source in pairs(exes) do
		if vim.fn.executable(exe) == 1 then
			table.insert(sources, source)
		end
	end

	return sources
end

local M = {}

--- Sets up LSP servers for languages.
--- @param opts table: Table of options for each language server.
function M.setup(opts)
	local configs = util.tbl_merge(opts.overrides, defaults)

	for name, config in pairs(configs) do
		-- This allows turning a language server off per project.
		if opts.denylist[name] then
			goto continue
		end

		local function on_attach(_, bufnr)
			lsp_commands.setup(bufnr)

			vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"

			if opts.folders[name] then
				for _, folder in ipairs(opts.folders[name]) do
					vim.lsp.buf.add_workspace_folder(folder)
				end
			end
		end

		nvim_lspconfig[name].setup(util.tbl_merge({ on_attach = on_attach }, config))

		::continue::
	end

	null_ls.setup({
		sources = make_sources({
			stylua = null_ls.builtins.formatting.stylua,
		}),
	})
end

return M

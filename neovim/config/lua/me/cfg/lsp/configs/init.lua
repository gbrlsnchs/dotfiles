local nvim_lspconfig = require("lspconfig")
local null_ls = require("null-ls")

local util = require("me.api.util")

local lsp_commands = require("me.cfg.lsp.commands")
local cwd = vim.loop.cwd()

--- Wraps an LSP server in a Podman container.
--- @param mod string: Path for the configuration module for the server.
--- @return table: The patched server configuration.
local function containerize(mod, image)
	local server = require(mod)

	server.cmd = {
		"podman",
		"container",
		"run",
		"--rm",
		"--interactive",
		"--network",
		"none",
		"--workdir",
		cwd,
		"--volume",
		string.format("%s:%s:z", cwd, cwd),
		"--pid",
		"host",
		image,
	}

	return server
end

-- Language settings.
local defaults = {
	gopls = require("me.cfg.lsp.configs.gopls"),
	jdtls = require("me.cfg.lsp.configs.jdtls"),
	rust_analyzer = require("me.cfg.lsp.configs.rust_analyzer"),
	sumneko_lua = require("me.cfg.lsp.configs.sumneko_lua"),
	tsserver = containerize("me.cfg.lsp.configs.tsserver", "typescript-language-server"),
	vuels = containerize("me.cfg.lsp.configs.vuels", "vls"),
}

local filters = {
	sumneko_lua = {
		format = { "null-ls" },
	},
}

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
			lsp_commands.setup(bufnr, filters)

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
		sources = {
			null_ls.builtins.code_actions.shellcheck,
			null_ls.builtins.diagnostics.shellcheck,
			null_ls.builtins.formatting.stylua,
		},
	})
end

return M

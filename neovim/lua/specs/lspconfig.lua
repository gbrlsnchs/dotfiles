local M = {'neovim/nvim-lspconfig'}

M.cond = function()
	return require('utils.lsp').is_enabled()
end

M.setup = function()
	vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
		vim.lsp.diagnostic.on_publish_diagnostics,
		{
			virtual_text = false,
			signs = true,
		}
	)

	vim.fn.sign_define('LspDiagnosticsSignError', {
		text = '🅴',
		texthl = 'LspDiagnosticsSignError',
		linehl = '',
		numhl = '',
	})
	vim.fn.sign_define('LspDiagnosticsSignWarning', {
		text = '🅴',
		texthl = 'LspDiagnosticsSignWarning',
		linehl = '',
		numhl = '',
	})
	vim.fn.sign_define('LspDiagnosticsSignInformation', {
		text = '🅴',
		texthl = 'LspDiagnosticsSignInformation',
		linehl = '',
		numhl = '',
	})
	vim.fn.sign_define('LspDiagnosticsSignHint', {
		text = '🅴',
		texthl = 'LspDiagnosticsSignHint',
		linehl = '',
		numhl = '',
	})
end

M.config = function()
	local nvim_lsp = require('lspconfig')
	local lsp_utils = require('utils.lsp')

	local efm_formatters = {
		prettier = {
			formatCommand = './node_modules/.bin/prettier',
			rootMarkers = {'package.json'},
		},
	}
	local configs = {
		clangd = {},
		cssls = {},
		efm = {
			cmd = {'efm-langserver', '-logfile', '/tmp/efm.log', '-loglevel', '5'},
			init_options = {
				documentFormatting = true,
			},
			filetypes = {'typescript', 'typescriptreact'},
			settings = {
				rootMarkers = {'.git/'},
				languages = {
					typescript = {efm_formatters.prettier},
					typescriptreact = {efm_formatters.prettier},
				},
			},
		},
		gopls = {},
		pyright = {},
		rust_analyzer = {
			settings = {
				['rust-analyzer'] = {
					checkOnSave = {
						command = 'clipply',
						overrideCommand = {
							'cargo',
							'clippy',
							'--workspace',
							'--message-format=json',
							'--all-targets',
						},
					},
				},
			},
		},
		sumneko_lua = {
			cmd = {'lua-language-server'},
			settings = {
				Lua = {
					runtime = {
						version = 'LuaJIT',
					},
					diagnostics = {
						globals = {'use', 'vim'},
					},
					workspace = {
						library = {
							[vim.fn.expand('$VIMRUNTIME/lua')] = true,
							[vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
						},
					},
				},
			},
		},
		texlab = {},
		tsserver = {
			on_attach = function(client)
				client.resolved_capabilities.document_formatting = false
			end,
		},
	}

	local denylist = {}
	for server_name, server_opts in pairs(configs) do
		if denylist[server_name] then
			goto continue
		end

		local local_attach = server_opts.on_attach
		if local_attach ~= nil then
			server_opts.on_attach = function(client)
				local_attach(client)
				lsp_utils.on_buf_enter(client)
			end
		else
			server_opts.on_attach = lsp_utils.on_buf_enter
		end

		nvim_lsp[server_name].setup(server_opts)

		::continue::
	end
end

return M

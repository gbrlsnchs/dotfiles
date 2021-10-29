return function()
	local lspconfig = require("lspconfig")
	local lsp_status = require("lsp-status")
	local illuminate = require("illuminate")
	local which_key = require("which-key")
	local lspconfig_util = require("deps.nvim_lspconfig.util")

	lsp_status.register_progress()
	lsp_status.config({
		indicator_ok = "[OK]",
	})

	lspconfig_util.register_attachment(function(client, _)
		lsp_status.on_attach(client)
		illuminate.on_attach(client)
	end)

	-- Set up local keybindings for buffers.
	lspconfig_util.register_extension(function(bufnr)
		which_key.register({
			["<C-]>"] = { "<Cmd>lua vim.lsp.buf.definition()<CR>", "Go to definition" },
			["]e"] = {
				'<Cmd>lua vim.lsp.diagnostic.goto_next({ popup_opts = { border = "single" } })<CR>',
				"Go to definition",
			},
			["[e"] = {
				'<Cmd>lua vim.lsp.diagnostic.goto_prev({ popup_opts = { border = "single" } })<CR>',
				"Go to definition",
			},
			K = { "<Cmd>lua vim.lsp.buf.hover()<CR>", "Hover symbol" },
			gD = { "<Cmd>lua vim.lsp.buf.implementation()<CR>", "Go to implementation" },
			gd = { "<Cmd>lua vim.lsp.buf.declaration()<CR>", "Go to type declaration" },
		}, {
			buffer = bufnr,
		})

		which_key.register({
			["<C-k>"] = { "<Cmd>lua vim.lsp.buf.signature_help()<CR>", "Show signature help" },
		}, {
			mode = "i",
			buffer = bufnr,
		})

		which_key.register({
			name = "lsp",
			D = {
				"<Cmd>lua vim.diagnostic.setloclist()<CR>",
				"Show diagnostics for current buffer",
			},
			R = { "<Cmd>lua vim.lsp.buf.references()<CR>", "Show references" },
			c = { "<Cmd>lua vim.lsp.buf.code_action()<CR>", "Run code action" },
			d = {
				'<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics({ border = "single" })<CR>',
				"Show line diagnostics",
			},
			f = { "<Cmd>lua vim.lsp.buf.formatting()<CR>", "Format code" },
			i = { "<Cmd>lua vim.lsp.buf.incoming_calls()<CR>", "Show incoming calls" },
			o = { "<Cmd>lua vim.lsp.buf.outgoing_calls()<CR>", "Show outgoing calls" },
			r = { "<Cmd>lua vim.lsp.buf.rename()<CR>", "Rename symbol under cursor" },
			s = { "<Cmd>lua vim.lsp.buf.document_symbol()<CR>", "Search for symbol in document" },
			t = { "<Cmd>lua vim.lsp.buf.type_definition()<CR>", "Go to type definition" },
			u = {
				r = { "<Cmd>LspRestart<CR>", "Restart LSP server" },
			},
			w = {
				name = "workspace",
				D = {
					"<Cmd>lua vim.diagnostic.setqflist()<CR>",
					"Show diagnostics for current workspace",
				},
				a = { "<Cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", "Add workspace folder" },
				l = {
					"<Cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
					"List workspace folders",
				},
				r = {
					"<Cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>",
					"Remove workspace folder",
				},
				s = {
					"<Cmd>vim.lsp.buf.workspace_symbol()<CR>",
					"Search for symbol in workspace",
				},
			},
		}, {
			prefix = "<Leader>l",
			buffer = bufnr,
		})

		which_key.register({
			l = {
				name = "lsp",
				c = {
					"<Cmd>lua vim.lsp.buf.range_code_action()<CR>",
					"Run code action for the selection",
				},
				f = {
					"<Cmd>lua vim.lsp.buf.range_formatting()<CR>",
					"Format selection",
				},
			},
		}, {
			prefix = "<Leader>",
			mode = "v",
			buffer = bufnr,
		})
	end)

	-- This is a buffer-independent keybinding.
	which_key.register({
		name = "lsp",
		u = {
			name = "util",
			i = { "<Cmd>LspInfo<CR>", "Show LSP information" },
		},
	}, {
		prefix = "<Leader>l",
	})

	vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
		vim.lsp.diagnostic.on_publish_diagnostics,
		{
			virtual_text = false,
			signs = true,
		}
	)

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = nil })

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
		vim.lsp.handlers.signature_help,
		{ border = nil }
	)

	local efm_formatters = {
		prettier = {
			formatCommand = "./node_modules/.bin/prettier --stdin-filepath ${INPUT}",
			formatStdin = true,
			rootMarkers = { "package.json" },
		},
		stylua = {
			formatCommand = "stylua -",
			formatStdin = true,
			rootMarkers = { ".git", "stylua.toml", ".stylua.toml" },
		},
		xmllint = {
			formatCommand = "XMLLINT_INDENT=$'\t' xmllint --format --recover -",
			formatStdin = true,
			rootMarkers = { ".git" },
		},
	}

	local custom_capabilities = vim.tbl_deep_extend("force", lsp_status.capabilities, {
		textDocument = {
			completion = {
				completionItem = {
					snippetSupport = true,
					resolveSupport = {
						"documentation",
						"detail",
						"additionalTextEdits",
					},
				},
			},
		},
	})
	local capabilities = vim.tbl_deep_extend(
		"force",
		vim.lsp.protocol.make_client_capabilities(),
		custom_capabilities
	)

	local cmp_lsp = require("cmp_nvim_lsp")
	cmp_lsp.update_capabilities(capabilities)

	local servers = {
		efm = {
			init_options = {
				documentFormatting = true,
			},
			filetypes = {
				"lua",
				"markdown",
				"typescript",
				"typescriptreact",
				"xml",
			},
			settings = {
				rootMarkers = { ".git/" },
				languages = {
					lua = { efm_formatters.stylua },
					markdown = { efm_formatters.prettier },
					typescript = { efm_formatters.prettier },
					typescriptreact = { efm_formatters.prettier },
					xml = { efm_formatters.xmllint },
				},
			},
		},
		gopls = {
			settings = {
				gopls = {
					experimentalWorkspaceModule = true,
					experimentalPostfixCompletions = true,
					codelenses = {
						generate = true,
						gc_details = true,
						test = true,
						tidy = true,
					},
				},
			},
		},
		pyright = {},
		sumneko_lua = require("lua-dev").setup({
			lspconfig = {
				cmd = { "lua-language-server" },
				settings = {
					Lua = {
						diagnostics = {
							globals = {
								-- Neovim
								"vim",
								-- Awesome
								"awesome",
								"client",
								"root",
								"screen",
							},
						},
						workspace = {
							library = {
								-- [("%s/awesome"):format(os.getenv("XDG_CONFIG_HOME"))] = true,
								-- ["/usr/share/awesome/lib"] = true,
							},
						},
					},
				},
			},
		}),
		rust_analyzer = {
			settings = {
				["rust-analyzer"] = {
					checkOnSave = {
						command = "clippy",
					},
				},
			},
		},
		texlab = {
			settings = {
				texlab = {
					build = {
						onSave = true,
					},
					forwardSearch = {
						executable = "zathura",
						args = { "--synctex-forward", "%l:1:%f", "%p" },
					},
				},
			},
		},
	}

	local denylist = {}
	for name, config in pairs(servers) do
		if denylist[name] then
			goto continue
		end
		lspconfig[name].setup(vim.tbl_deep_extend("force", config, {
			on_attach = lspconfig_util.on_attach,
			capabilities = capabilities,
		}))
		::continue::
	end
end

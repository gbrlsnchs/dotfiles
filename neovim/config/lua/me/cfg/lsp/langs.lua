local nvim_lspconfig = require("lspconfig")

local config = require("me.api.config")
local excmd = require("me.api.excmd")
local util = require("me.api.util")

local api = vim.api
local nvim_state = vim.fn.stdpath("state")
local nvim_data = vim.fn.stdpath("data")
local cwd = vim.loop.cwd()

--- Wraps an LSP server in a Podman container.
--- @param image string: Container image to be used.
--- @param server table: Configuration table for the LSP server.
--- @return table: The patched server configuration.
local function containerize(image, server)
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
		server.cmd,
	}

	return server
end

--- Registers keymaps related to LSP.
--- @param bufnr number: Local buffer identifier.
--- @param filters table | nil: List of client filters for LSP actions.
local function setup_cmd(bufnr, filters)
	filters = filters or {}

	excmd.register("LSP", {
		LspHover = {
			desc = "Show information about symbol under cursor",
			callback = function()
				vim.lsp.buf.hover()
			end,
			opts = {
				keymap = { keys = "K" },
				buffer = bufnr,
			},
		},
		LspDefinition = {
			desc = "Go to symbol definition",
			callback = function()
				vim.lsp.buf.definition()
			end,
			opts = {
				keymap = { keys = "<C-]>" },
				buffer = bufnr,
			},
		},
		LspImplementation = {
			desc = "Go to symbol implementation",
			callback = function()
				vim.lsp.buf.implementation()
			end,
			opts = {
				keymap = { keys = "gd" },
				buffer = bufnr,
			},
		},
		LspDeclaration = {
			desc = "Go to symbol declaration",
			callback = function()
				vim.lsp.buf.declaration()
			end,
			opts = {
				keymap = { keys = "gD" },
				buffer = bufnr,
			},
		},
		LspTypeDefinition = {
			desc = "Go to symbol type definition",
			callback = function()
				vim.lsp.buf.type_definition()
			end,
			opts = {
				keymap = { keys = "<Leader>lt" },
				buffer = bufnr,
			},
		},
		LspIncomingCalls = {
			desc = "Show incoming calls",
			callback = function()
				vim.lsp.buf.incoming_calls()
			end,
			opts = {
				buffer = bufnr,
			},
		},
		LspOutgoingCalls = {
			desc = "Show outgoing calls",
			callback = function()
				vim.lsp.buf.outgoing_calls()
			end,
			opts = {
				buffer = bufnr,
			},
		},
		LspReferences = {
			desc = "Find symbol references",
			callback = function()
				vim.lsp.buf.references({ includeDeclaration = false })
			end,
			opts = {
				keymap = { keys = "<Leader>lR" },
				buffer = bufnr,
			},
		},
		LspDocumentSymbol = {
			desc = "Search for symbol in current buffer",
			callback = function()
				vim.lsp.buf.document_symbol()
			end,
			opts = {
				keymap = { keys = "<Leader>ls" },
				buffer = bufnr,
			},
		},
		LspFormat = {
			desc = "Format current buffer",
			callback = util.with_range(function(range)
				if range then
					range = vim.tbl_map(function(idx)
						return { idx, 0 }
					end, range)

					vim.lsp.buf.range_formatting(nil, unpack(range))
					return
				end

				local fmt_opts = { async = true }
				local fmt_filters = filters.format or {}

				if #fmt_filters == 1 then
					fmt_opts.name = fmt_filters[1]
				elseif #fmt_filters > 1 then
					fmt_opts.filter = function(client)
						return vim.tbl_contains(fmt_filters, client.name)
					end
				end

				vim.lsp.buf.format(fmt_opts)
			end),
			opts = {
				modes = { "n", "v" },
				keymap = { keys = "<Leader>lf" },
				buffer = bufnr,
			},
		},
		LspCodeAction = {
			desc = "Run a code action",
			callback = util.with_range(function(range)
				if range then
					range = vim.tbl_map(function(idx)
						return { idx, 0 }
					end, range)

					vim.lsp.buf.range_code_action(nil, unpack(range))
					return
				end

				vim.lsp.buf.code_action()
			end),
			opts = {
				modes = { "n", "v" },
				keymap = { keys = "<Leader>lc" },
				buffer = bufnr,
			},
		},
		LspRename = {
			desc = "Rename symbol under cursor",
			callback = function()
				vim.lsp.buf.rename()
			end,
			opts = {
				keymap = { keys = "<Leader>lr" },
			},
		},
		LspWorkspaceAddFolder = {
			desc = "Add folder to workspace",
			callback = function()
				vim.lsp.buf.add_workspace_folder()
			end,
			opts = {
				buffer = bufnr,
			},
		},
		LspWorkspaceListFolders = {
			desc = "List workspace folders",
			callback = function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end,
			opts = {
				buffer = bufnr,
			},
		},
		LspWorkspaceRemoveFolder = {
			desc = "Remove folder from workspace",
			callback = function()
				vim.lsp.buf.remove_workspace_folder()
			end,
			opts = {
				buffer = bufnr,
			},
		},
		LspWorkspaceSymbol = {
			desc = "Find workspace symbol",
			callback = util.with_fargs(function(query)
				vim.lsp.buf.workspace_symbol(query)
			end),
			opts = {
				nargs = "?",
				buffer = bufnr,
			},
		},
	})

	-- Information.
	api.nvim_buf_set_keymap(bufnr, "i", "<C-k>", "", {
		noremap = true,
		callback = function()
			vim.lsp.buf.signature_help()
		end,
	})
end

-- Language settings.
local defaults = {
	gopls = {
		settings = {
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
	jdtls = {
		cmd = { "jdtls", "-data", nvim_state .. "/jdtls" },
	},
	rust_analyzer = {},
	sumneko_lua = {
		settings = {
			Lua = {
				runtime = {
					version = "LuaJIT",
					path = vim.split(package.path, ";"),
				},
				workspace = {
					library = {
						[vim.env.VIMRUNTIME] = true,
						[nvim_data .. "/pack/*/start/*"] = true,
						[nvim_data .. "/pack/*/opt/*"] = true,
						[nvim_data .. "/rocks/*"] = true,
					},
					maxPreload = 2000,
					preloadFileSize = 50000,
				},
				diagnostics = {
					globals = { "vim" },
				},
			},
		},
	},
	texlab = {
		settings = {
			texlab = {
				forwardSearch = {
					executable = "zathura",
					args = {
						"--synctex-forward",
						"%l:1:%f",
						"%p",
					},
				},
			},
		},
	},
	tsserver = containerize("typescript-language-server", {}),
	vuels = containerize("vls", {}),
	zls = {},
}

local filters = {
	sumneko_lua = {
		format = {},
	},
}

local configs = vim.tbl_deep_extend("force", defaults, config.get("lsp", "overrides") or {})
local inlay_hints

if config.get("editor", "autocomplete") then
	local lsp_cmp = require("cmp_nvim_lsp")
	local capabilities = vim.lsp.protocol.make_client_capabilities()

	configs = vim.tbl_map(function(cfg)
		cfg.capabilities = lsp_cmp.update_capabilities(cfg.capabilities or capabilities)

		return cfg
	end, configs)
end

local hints_enabled = config.get("lsp", "inlay_hints")
if hints_enabled then
	util.packadd("lsp-inlayhints.nvim")

	inlay_hints = require("lsp-inlayhints")
	inlay_hints.setup()
end

for name, srv_config in pairs(configs) do
	-- This allows turning a language server off per project.
	if config.get("lsp", "denylist", name) then
		goto continue
	end

	local function on_attach(client, bufnr)
		setup_cmd(bufnr, filters)

		local folders = config.get("lsp", "folders", name)
		if folders then
			for _, folder in ipairs(folders) do
				vim.lsp.buf.add_workspace_folder(folder)
			end
		end

		if hints_enabled then
			inlay_hints.on_attach(client, bufnr)
		end
	end

	nvim_lspconfig[name].setup(vim.tbl_deep_extend("force", srv_config, { on_attach = on_attach }))

	::continue::
end

null_ls.setup({
	sources = {
		null_ls.builtins.code_actions.shellcheck,
		null_ls.builtins.diagnostics.shellcheck,
		null_ls.builtins.formatting.stylua,
	},
})

local features = require("features")
local util = require("lib.util")
local command = require("lib.command")
local command_util = require("lib.command.util")

if not util.feature_is_on(features.lsp.core) then
	return
end

util.packadd("nvim-lspconfig")

local api = vim.api

local lspconfig = require("lspconfig")
local lsputil = require("lspconfig.util")

local function register_keymaps(bufnr)
	local cmd_group = "LSP"

	-- Diagnostics.
	command.add("LspShowDiagnostics", "Show diagnostics information", function()
		vim.diagnostic.open_float({ bufnr = bufnr, scope = "line", float = { border = "single" } })
	end, {
		group = cmd_group,
		keymap = { keys = "<Leader>ld" },
		bufnr = bufnr,
	})
	command.add("LspNextDiagnostic", "Go to next diagnostic", vim.diagnostic.goto_next, {
		group = cmd_group,
		keymap = { keys = "]e" },
		bufnr = bufnr,
	})
	command.add("LspPrevDiagnostic", "Go to previous diagnostic", vim.diagnostic.goto_prev, {
		group = cmd_group,
		keymap = { keys = "[e" },
		bufnr = bufnr,
	})
	command.add("LspDiagnostics", "Show diagnostics for current buffer", vim.diagnostic.setloclist, {
		group = cmd_group,
		keymap = { keys = "<Leader>lD" },
		bufnr = bufnr,
	})
	command.add("LspWorkspaceDiagnostics", "Show workspace diagnostics", vim.diagnostic.setqflist, {
		group = cmd_group,
		bufnr = bufnr,
	})

	-- Information.
	command.add("LspHover", "Show information about symbol", vim.lsp.buf.hover, {
		group = cmd_group,
		keymap = { keys = "K" },
		bufnr = bufnr,
	})
	api.nvim_buf_set_keymap(
		bufnr,
		"i",
		"<C-k>",
		"<Cmd>lua vim.lsp.buf.signature_help()<CR>",
		{ noremap = true }
	)

	-- Jumps.
	command.add("LspDefinition", "Go to definition", vim.lsp.buf.definition, {
		group = cmd_group,
		keymap = { keys = "<C-]>" },
		bufnr = bufnr,
	})
	command.add("LspImplementation", "Go to implementation", vim.lsp.buf.implementation, {
		group = cmd_group,
		keymap = { keys = "gD" },
		bufnr = bufnr,
	})
	command.add("LspDeclaration", "Go to declaration", vim.lsp.buf.declaration, {
		group = cmd_group,
		keymap = { keys = "gd" },
		bufnr = bufnr,
	})
	command.add("LspTypeDefinition", "Go to type definition", vim.lsp.buf.type_definition, {
		group = cmd_group,
		bufnr = bufnr,
	})
	command.add("LspIncomingCalls", "Show incoming calls", vim.lsp.buf.incoming_calls, {
		group = cmd_group,
		bufnr = bufnr,
	})
	command.add("LspOutgoingCalls", "Show outgoing calls", vim.lsp.buf.outgoing_calls, {
		group = cmd_group,
		bufnr = bufnr,
	})

	-- Searches.
	command.add("LspReferences", "Find references for symbol", function()
		vim.lsp.buf.references({ includeDeclaration = false })
	end, {
		group = cmd_group,
		keymap = { keys = "<Leader>lR" },
		bufnr = bufnr,
	})
	command.add(
		"LspDocumentSymbol",
		"Search for symbols in current buffer",
		vim.lsp.buf.document_symbol,
		{
			group = cmd_group,
			keymap = { keys = "<Leader>ls" },
			bufnr = bufnr,
		}
	)

	-- Utils.
	command.add("LspFormat", "Format code", vim.lsp.buf.formatting, {
		group = cmd_group,
		keymap = { keys = "<Leader>lf" },
		bufnr = bufnr,
	})
	api.nvim_buf_set_keymap(
		bufnr,
		"v",
		"<Leader>lf",
		"<Cmd>lua vim.lsp.buf.range_formatting()<CR>",
		{ noremap = true }
	)
	command.add("LspCodeAction", "Run a code action", vim.lsp.buf.code_action, {
		group = cmd_group,
		keymap = { keys = "<Leader>lc" },
		bufnr = bufnr,
	})
	api.nvim_buf_set_keymap(
		bufnr,
		"v",
		"<Leader>lc",
		"<Cmd>lua vim.lsp.buf.range_code_action()<CR>",
		{ noremap = true }
	)
	command.add("LspRename", "Rename symbol under cursor", vim.lsp.buf.rename, {
		group = cmd_group,
		keymap = { keys = "<Leader>lr" },
		bufnr = bufnr,
	})

	-- Workspace commands.
	command.add("LspWorkspaceAddFolder", "Add folder to workspace", vim.lsp.buf.add_workspace_folder, {
		group = cmd_group,
		bufnr = bufnr,
	})
	command.add("LspWorkspaceListFolders", "List workspace folders", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, {
		group = cmd_group,
		bufnr = bufnr,
	})
	command.add(
		"LspWorkspaceRemoveFolder",
		"Remove folder from workspace",
		vim.lsp.buf.remove_workspace_folder,
		{
			group = cmd_group,
			bufnr = bufnr,
		}
	)
	command.add(
		"LspWorkspaceSymbol",
		"Find workspace symbol",
		command_util.bind_fargs(vim.lsp.buf.workspace_symbol),
		{
			group = cmd_group,
			nargs = "?",
			bufnr = bufnr,
		}
	)
end

local function config_ui()
	vim.diagnostic.config({
		virtual_text = false,
		signs = true,
		float = { border = "single" },
	})

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
		vim.lsp.handlers.hover,
		{ border = "single" }
	)

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
		vim.lsp.handlers.signature_help,
		{ border = "single" }
	)
end

-- Set up local keykeysings for buffers.

-- This is a buffer-independent keykeysing.

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

local capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), {
	textDocument = {
		completion = {
			completionItem = {
				snippetSupport = false,
				resolveSupport = {
					"documentation",
					"detail",
					"additionalTextEdits",
				},
			},
		},
	},
})

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
	gopls = require("deps.lsp.go"),
	jdtls = {
		cmd = { "jdtls" },
		root_dir = lsputil.find_git_ancestor,
	},
	pyright = {},
	sumneko_lua = require("deps.lsp.lua"),
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

local local_settings = {}

if features.lsp.local_settings:is_on() then
	local local_settings_file = "neovim.json"

	if not local_settings and vim.fn.filereadable(local_settings_file) == 1 then
		-- local uv = async.uv
		-- local _, fd = uv.fs_open(local_settings_file, "r", 438)
		-- local _, stat = uv.fs_stat(fd)
		-- local _, data = uv.fs_read(fd, stat.size, 0)
		-- uv.fs_close(fd)

		local data = vim.fn.join(vim.fn.readfile(local_settings_file))
		local_settings = vim.fn.json_decode(data)
	end
end

config_ui()

local denylist = {}
for name, config in pairs(servers) do
	if denylist[name] then
		goto continue
	end

	config = vim.tbl_deep_extend("force", config, local_settings[name] or {}, {
		on_attach = function(_, bufnr)
			register_keymaps(bufnr)
			vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
		end,
		capabilities = capabilities,
	})

	lspconfig[name].setup(config)

	::continue::
end

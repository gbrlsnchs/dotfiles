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
	local wrap_cmd_opts = command_util.create_opts_factory({
		bufnr = bufnr,
		group = "LSP",
	})

	-- Diagnostics.
	command.add(
		"Show diagnostics information",
		wrap_cmd_opts({
			name = "LspShowDiagnostics",
			exec = 'lua vim.diagnostic.open_float(0, { scope = "line", float = { border = "single" } })',
			mappings = { bind = "<Leader>ld" },
		})
	)
	command.add(
		"Go to next diagnostic",
		wrap_cmd_opts({
			name = "LspNextDiagnostic",
			exec = "lua vim.diagnostic.goto_next()",
			mappings = { bind = "]e" },
		})
	)
	command.add(
		"Go to previous diagnostic",
		wrap_cmd_opts({
			name = "LspPrevDiagnostic",
			exec = "lua vim.diagnostic.goto_prev()",
			mappings = { bind = "[e" },
		})
	)
	command.add(
		"Show diagnostics for current buffer",
		wrap_cmd_opts({
			name = "LspDiagnostics",
			exec = "lua vim.diagnostic.setloclist()",
			mappings = { bind = "<Leader>lD" },
		})
	)
	command.add(
		"Show workspace diagnostics",
		wrap_cmd_opts({
			name = "LspWorkspaceDiagnostics",
			exec = "lua vim.diagnostic.setqflist()",
		})
	)

	-- Information.
	command.add(
		"Show information about symbol",
		wrap_cmd_opts({
			name = "LspHover",
			exec = "lua vim.lsp.buf.hover()",
			mappings = { bind = "K" },
		})
	)
	api.nvim_buf_set_keymap(
		bufnr,
		"i",
		"<C-k>",
		"<Cmd>lua vim.lsp.buf.signature_help()<CR>",
		{ noremap = true }
	)

	-- Jumps.
	command.add(
		"Go to definition",
		wrap_cmd_opts({
			name = "LspDefinition",
			exec = "lua vim.lsp.buf.definition()",
			mappings = { bind = "<C-]>" },
		})
	)
	command.add(
		"Go to implementation",
		wrap_cmd_opts({
			name = "LspImplementation",
			exec = "lua vim.lsp.buf.implementation()",
			mappings = { bind = "gD" },
		})
	)
	command.add(
		"Go to declaration",
		wrap_cmd_opts({
			name = "LspDeclaration",
			exec = "<Cmd>lua vim.lsp.buf.declaration()<CR>",
			mappings = { bind = "gd" },
		})
	)
	command.add(
		"Go to type definition",
		wrap_cmd_opts({
			name = "LspTypeDefinition",
			exec = "lua vim.lsp.buf.type_definition()",
		})
	)
	command.add(
		"Show incoming calls",
		wrap_cmd_opts({
			name = "LspIncomingCalls",
			exec = "lua vim.lsp.buf.incoming_calls()",
		})
	)
	command.add(
		"Show outgoing calls",
		wrap_cmd_opts({
			name = "LspOutgoingCalls",
			exec = "lua vim.lsp.buf.outgoing_calls()",
		})
	)

	-- Searches.
	command.add(
		"Find references for symbol",
		wrap_cmd_opts({
			name = "LspReferences",
			exec = "lua vim.lsp.buf.references({ includeDeclaration = false })",
			mappings = { bind = "<Leader>lR" },
		})
	)
	command.add(
		"Search for symbols in current buffer",
		wrap_cmd_opts({
			name = "LspDocumentSymbol",
			exec = "lua vim.lsp.buf.document_symbol()",
			mappings = { bind = "<Leader>ls" },
		})
	)

	-- Utils.
	command.add(
		"Format code",
		wrap_cmd_opts({
			name = "LspFormat",
			exec = "lua vim.lsp.buf.formatting()",
			mappings = { bind = "<Leader>lf" },
		})
	)
	api.nvim_buf_set_keymap(
		bufnr,
		"v",
		"<Leader>lf",
		"<Cmd>lua vim.lsp.buf.range_formatting()<CR>",
		{ noremap = true }
	)
	command.add(
		"Run a code action",
		wrap_cmd_opts({
			name = "LspCodeAction",
			exec = "lua vim.lsp.buf.code_action()",
			mappings = { bind = "<Leader>lc" },
		})
	)
	api.nvim_buf_set_keymap(
		bufnr,
		"v",
		"<Leader>lc",
		"<Cmd>lua vim.lsp.buf.range_code_action()<CR>",
		{ noremap = true }
	)
	command.add(
		"Rename symbol under cursor",
		wrap_cmd_opts({
			name = "LspRename",
			exec = "lua vim.lsp.buf.rename()",
			mappings = { bind = "<Leader>lr" },
		})
	)

	-- Workspace commands.
	command.add(
		"Add folder to workspace",
		wrap_cmd_opts({
			name = "LspWorkspaceAddFolder",
			exec = "lua vim.lsp.buf.add_workspace_folder()",
		})
	)
	command.add(
		"List workspace folders",
		wrap_cmd_opts({
			name = "LspWorkspaceListFolders",
			exec = "lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))",
		})
	)
	command.add(
		"Remove folder from workspace",
		wrap_cmd_opts({
			name = "LspWorkspaceRemoveFolder",
			exec = "lua vim.lsp.buf.remove_workspace_folder()",
		})
	)
	command.add(
		"Find workspace symbol",
		wrap_cmd_opts({
			name = "LspWorkspaceSymbol",
			nargs = "?",
			exec = "lua vim.lsp.buf.workspace_symbol(<f-args>)",
		})
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

-- Set up local keybindings for buffers.

-- This is a buffer-independent keybinding.

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

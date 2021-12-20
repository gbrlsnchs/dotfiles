local features = require("features")
local util = require("lib.util")

if not util.feature_is_on(features.lsp.core) then
	return
end

util.packadd("nvim-lspconfig")

local lspconfig = require("lspconfig")
local lsputil = require("lspconfig.util")

local function register_keymaps(bufnr)
	local function set_keymap(mode, key, cmd)
		vim.api.nvim_buf_set_keymap(bufnr, mode, key, cmd, { noremap = true })
	end

	set_keymap("n", "<C-]>", "<Cmd>lua vim.lsp.buf.definition()<CR>")
	set_keymap("n", "]e", "<Cmd>lua vim.diagnostic.goto_next()<CR>")
	set_keymap("n", "[e", "<Cmd>lua vim.diagnostic.goto_prev()<CR>")
	set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>")
	set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.implementation()<CR>")
	set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.declaration()<CR>")
	set_keymap("n", "<Leader>lt", "<Cmd>lua vim.lsp.buf.type_definition()<CR>")

	set_keymap("i", "<C-k>", "<Cmd>lua vim.lsp.buf.signature_help()<CR>")

	set_keymap("n", "<Leader>lD", "<Cmd>lua vim.diagnostic.setloclist()<CR>")
	set_keymap(
		"n",
		"<Leader>lR",
		"<Cmd>lua vim.diagnostic.references({ includeDeclaration = false })<CR>"
	)
	set_keymap("n", "<Leader>lc", "<Cmd>lua vim.lsp.buf.code_action()<CR>")
	set_keymap("v", "<Leader>lc", "<Cmd>lua vim.lsp.buf.range_code_action()<CR>")
	set_keymap(
		"n",
		"<Leader>ld",
		'<Cmd>lua vim.diagnostic.open_float(0, { scope = "line", float = { border = "single" } })<CR>'
	)

	-- Formatting.
	set_keymap("n", "<Leader>lf", "<Cmd>lua vim.lsp.buf.formatting()<CR>")
	set_keymap("v", "<Leader>lf", "<Cmd>lua vim.lsp.buf.range_formatting()<CR>")

	-- Calls and references.
	set_keymap("n", "<Leader>li", "<Cmd>lua vim.lsp.buf.incoming_calls()<CR>")
	set_keymap("n", "<Leader>lo", "<Cmd>lua vim.lsp.buf.outgoing_calls()<CR>")

	-- References.
	set_keymap("n", "<Leader>lr", "<Cmd>lua vim.lsp.buf.rename()<CR>")
	set_keymap("n", "<Leader>ls", "<Cmd>lua vim.lsp.buf.document_symbol()<CR>")

	-- Workspace commands.
	set_keymap("n", "<Leader>lwD", "<Cmd>lua vim.diagnostic.setqflist()<CR>")
	set_keymap("n", "<Leader>lwa", "<Cmd>lua vim.lsp.buf.add_workspace_folder()<CR>")
	set_keymap(
		"n",
		"<Leader>lwl",
		"<Cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>"
	)
	set_keymap("n", "<Leader>lwr", "<Cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>")
	set_keymap("n", "<Leader>lws", "<Cmd>vim.lsp.buf.workspace_symbol()<CR>")
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

local excmd = require("me.api.excmd")
local util = require("me.api.util")

local api = vim.api

local M = {}

--- Registers keymaps related to LSP.
--- @param bufnr number: Local buffer identifier.
function M.setup(bufnr)
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
			callback = util.with_fargs(function(arg)
				if arg == "sync" then
					vim.lsp.buf.formatting_sync()
				elseif arg == "sequential" then
					vim.lsp.buf.formatting_seq_sync()
				else
					vim.lsp.buf.formatting()
				end
			end),
			opts = {
				nargs = "?",
				complete = function()
					return { "sync", "sequential" }
				end,
				keymap = { keys = "<Leader>lf" },
				buffer = bufnr,
			},
		},
		LspCodeAction = {
			desc = "Run a code action",
			callback = function()
				vim.lsp.buf.code_action()
			end,
			opts = {
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
	api.nvim_buf_set_keymap(
		bufnr,
		"i",
		"<C-k>",
		"<Cmd>lua vim.lsp.buf.signature_help()<CR>",
		{ noremap = true }
	)

	-- Utils.
	-- TODO: Add this to visual command palette.
	api.nvim_buf_set_keymap(
		bufnr,
		"v",
		"<Leader>lf",
		"<Cmd>lua vim.lsp.buf.range_formatting()<CR>",
		{ noremap = true }
	)

	api.nvim_buf_set_keymap(
		bufnr,
		"v",
		"<Leader>lc",
		"<Cmd>lua vim.lsp.buf.range_code_action()<CR>",
		{ noremap = true }
	)
end

return M

local excmd = require("me.api.excmd")
local util = require("me.api.util")

local api = vim.api

local M = {}

--- Registers keymaps related to LSP.
--- @param bufnr number: Local buffer identifier.
--- @param filters table | nil: List of client filters for LSP actions.
function M.setup(bufnr, filters)
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

return M

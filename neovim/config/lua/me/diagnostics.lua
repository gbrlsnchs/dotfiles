local excmd = require("me.api.excmd")
local util = require("me.api.util")

local M = {}

--- Sets up diagnostics.
function M.setup(_)
	vim.diagnostic.config({
		virtual_text = {
			format = function(_)
				return ""
			end,
			prefix = "火",
			spacing = 1,
		},
		signs = false,
		severity_sort = true,
		float = { border = "single", source = true },
	})

	-- Despite not using signs, we need this in order to retrieve unified signs in other places.
	vim.fn.sign_define("DiagnosticSignError", { text = "E" })
	vim.fn.sign_define("DiagnosticSignWarn", { text = "W" })
	vim.fn.sign_define("DiagnosticSignInfo", { text = "I" })
	vim.fn.sign_define("DiagnosticSignHint", { text = "H" })

	excmd.register("Diagnostics", {
		DiagnosticsLine = {
			desc = "Show diagnostics for current line",
			callback = function()
				vim.diagnostic.open_float()
			end,
			opts = {
				keymap = { keys = "<Leader>dl" },
			},
		},
		DiagnosticsNext = {
			desc = "Go to next line with diagnostics",
			callback = function()
				vim.diagnostic.goto_next()
			end,
			opts = {
				keymap = { keys = "]e" },
			},
		},
		DiagnosticsPrev = {
			desc = "Go to previous line with diagnostics",
			callback = function()
				vim.diagnostic.goto_prev()
			end,
			opts = {
				keymap = { keys = "[e" },
			},
		},
		DiagnosticsShow = {
			desc = "Show diagnostics (for buffer or workspace)",
			callback = util.with_fargs(function(cmd)
				if cmd == "workspace" then
					vim.diagnostic.setqflist()
				else
					vim.diagnostic.setloclist()
				end
			end),
			opts = {
				nargs = "?",
				complete = function()
					return { "workspace" }
				end,
				keymap = { keys = "<Leader>ds" },
				actions = {
					["ctrl-s"] = {
						arg = "workspace",
						keymap = {
							keys = "<Leader>dS",
						},
					},
				},
			},
		},
	})
end

return M

local excmd = require("me.api.excmd")

vim.cmd.packadd("vim-signify")
vim.opt.updatetime = 100

vim.g.signify_sign_add = "█"
vim.g.signify_sign_delete = "█"
vim.g.signify_sign_delete_first_line = "▒"
vim.g.signify_sign_change = "█"
vim.g.signify_sign_change_delete = "▒"
vim.g.signify_sign_show_count = false

excmd.register("Git", {
	GitPreviewHunk = {
		desc = "Preview changes for current hunk",
		callback = function()
			vim.cmd.SignifyHunkDiff()
		end,
		opts = {
			keymap = { keys = "<Leader>gp" },
		},
	},
	GitResetHunk = {
		desc = "Undo changes in current hunk",
		callback = function()
			-- TODO: Confirm this action.
			vim.cmd.SignifyHunkUndo()
		end,
		opts = {
			keymap = { keys = "<Leader>gu" },
		},
	},
	GitDiff = {
		desc = "Show diff of current buffer",
		callback = function()
			vim.cmd.SignifyDiff()
		end,
	},
})

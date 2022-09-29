local util = require("me.api.util")
local excmd = require("me.api.excmd")

util.packadd("gitsigns.nvim")

local gitsigns = require("gitsigns")

gitsigns.setup({
	signs = {
		add = { text = "█" },
		change = { text = "█" },
		delete = { text = "█" },
		changedelete = { text = "▒" },
	},
	current_line_blame = false,
	keymaps = { noremap = false },
})

excmd.register("Git", {
	GitNextHunk = {
		desc = "Go to next Git hunk",
		callback = function()
			gitsigns.next_hunk()
		end,
		opts = {
			keymap = { keys = "]g" },
		},
	},
	GitPrevHunk = {
		desc = "Go to previous Git hunk",
		callback = function()
			gitsigns.prev_hunk()
		end,
		opts = {
			keymap = { keys = "[g" },
		},
	},
	GitBlame = {
		desc = "Show blame for current line",
		callback = function()
			gitsigns.blame_line({ full = true })
		end,
		opts = {
			keymap = { keys = "<Leader>g?" },
		},
	},
	GitPreviewHunk = {
		desc = "Preview changes for current hunk",
		callback = function()
			gitsigns.preview_hunk()
		end,
		opts = {
			keymap = { keys = "<Leader>gp" },
		},
	},
	GitResetHunk = {
		desc = "Reset changes in current hunk",
		callback = util.with_range(function(range)
			-- TODO: Confirm this action.
			gitsigns.reset_hunk(range)
		end),
		opts = {
			modes = { "n", "v" },
		},
	},
	GitResetBuffer = {
		desc = "Reset changes in current buffer",
		callback = function()
			-- TODO: Confirm this action.
			gitsigns.reset_buffer()
		end,
	},
	GitStageHunk = {
		desc = "Stage changes in current hunk",
		callback = util.with_range(function(range)
			print(vim.inspect(range))
			gitsigns.stage_hunk(range)
		end),
		opts = {
			modes = { "n", "v" },
			keymap = {
				keys = "<Leader>gs",
			},
		},
	},
	GitStageBuffer = {
		desc = "Stage changes in current buffer",
		callback = function()
			gitsigns.stage_buffer()
		end,
		opts = {
			keymap = { keys = "<Leader>gS" },
		},
	},
	GitUndoStageHunk = {
		desc = "Undo staging of changes in current hunk",
		callback = util.with_range(function(range)
			gitsigns.undo_stage_hunk(range)
		end),
		opts = {
			modes = { "n", "v" },
			keymap = { keys = "<Leader>gu" },
		},
	},
	GitResetBufferIndex = {
		desc = "Reset current buffer index",
		callback = function()
			gitsigns.reset_buffer_index()
		end,
	},
	GitDiff = {
		desc = "Show diff of current buffer",
		callback = function()
			gitsigns.diffthis()
		end,
	},
})

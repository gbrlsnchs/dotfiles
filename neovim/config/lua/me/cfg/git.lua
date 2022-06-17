local util = require("me.api.util")

local M = {}

function M.setup(opts)
	opts = util.tbl_merge(opts, {
		enabled = true,
	})

	if not opts.enabled then
		vim.notify("Git module is disabled, skipping it")

		return
	end

	util.packadd("gitsigns.nvim")

	local gitsigns = require("gitsigns")

	gitsigns.setup({
		signs = {
			add = { text = "█" },
			change = { text = "█" },
			delete = { text = "█" },
			changedelete = { text = "▒" },
		},
		current_line_blame = true,
		keymaps = { noremap = false },
	})

	local function mapkeys(mode, keys, cmd)
		vim.api.nvim_set_keymap(mode, keys, cmd, { noremap = true })
	end

	mapkeys("n", "]g", '<Cmd>lua require("gitsigns").next_hunk()<CR>')
	mapkeys("n", "[g", '<Cmd>lua require("gitsigns").prev_hunk()<CR>')
	mapkeys("n", "<Leader>gb", 'lua require("gitsigns").blame_line({ full = true })<CR>')
	mapkeys("n", "<Leader>gp", 'lua require("gitsigns").preview_hunk()<CR>')
	mapkeys("n", "<Leader>gr", 'lua require("gitsigns").reset_hunk()<CR>')
	mapkeys("v", "<Leader>gr", 'lua require("gitsigns").reset_hunk()<CR>')
	mapkeys("n", "<Leader>gR", 'lua require("gitsigns").reset_buffer()<CR>')
	mapkeys("n", "<Leader>gs", 'lua require("gitsigns").stage_hunk()<CR>')
	mapkeys("n", "<Leader>gS", 'lua require("gitsigns").stage_buffer()<CR>')
	mapkeys("n", "<Leader>gu", 'lua require("gitsigns").undo_stage_hunk()<CR>')
	mapkeys("n", "<Leader>gU", 'lua require("gitsigns").reset_buffer_index()<CR>')
end

return M

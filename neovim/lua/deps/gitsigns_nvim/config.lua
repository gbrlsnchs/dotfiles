return function()
	local gitsigns = require("gitsigns")

	gitsigns.setup({
		signs = {
			add = { text = "█" },
			change = { text = "▓" },
			delete = { text = "░"},
			changedelete = { text = "▒" },
		},
		keymaps = {
			noremap = false,
			buffer = false,
		},
	})

	local which_key = require("which-key")

	which_key.register({
		["]g"] = { '<Cmd>lua require("gitsigns").next_hunk()<CR>', "Go to next Git hunk" },
		["[g"] = { '<Cmd>lua require("gitsigns").prev_hunk()<CR>', "Go to previous Git hunk" },
	})

	which_key.register({
		name = "git",
		b = { '<Cmd>lua require("gitsigns").blame_line()<CR>', "Show blame for current line" },
		p = { '<Cmd>lua require("gitsigns").preview_hunk()<CR>', "Preview hunk" },
		r = { '<Cmd>lua require("gitsigns").reset_hunk()<CR>', "Reset hunk" },
		s = { '<Cmd>lua require("gitsigns").stage_hunk()<CR>', "Stage hunk" },
		u = { '<Cmd>lua require("gitsigns").undo_hunk()<CR>', "Undo hunk" },
	}, {
		prefix = "<Leader>g",
	})
end

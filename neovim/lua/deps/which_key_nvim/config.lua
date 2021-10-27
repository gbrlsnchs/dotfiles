return function()
	local which_key = require("which-key")
	which_key.setup({
		icons = {
			breadcrumb = ">",
			separator = "->",
			group = "+",
		},
		key_labels = {
			["<leader>"] = "SPC",
		},
		window = {
			border = "double",
		},
	})

	-- Navigation keymaps
	which_key.register({
		["]b"] = { "<Cmd>bnext<CR>", "Go to next buffer" },
		["[b"] = { "<Cmd>bNext<CR>", "Go to previous buffer" },
		["]l"] = { "<Cmd>lnext<CR>", "Go to next item in loclist" },
		["[l"] = { "<Cmd>lprevious<CR>", "Go to previous item in loclist" },
		["]q"] = { "<Cmd>cnext<CR>", "Go to next item in quickfix" },
		["[q"] = { "<Cmd>cprevious<CR>", "Go to previous item in quickfix" },
	})

	-- Register main group names and plugin-free mappings.
	which_key.register({
		b = {
			name = "buffer",
			D = { "<Cmd>bdelete<CR>", "Delete buffer and quit window" },
			d = { "<Cmd>Bdelete<CR>", "Delete buffer, preserve window" },
		},
		e = {
			name = "explorer",
			e = { "<Cmd>Explore<CR>", "Open file explorer in current buffer" },
			s = { "<Cmd>Sexplore<CR>", "Open file explorer horizontally" },
			v = { "<Cmd>Vexplore<CR>", "Open file explorer vertically" },
		},
		f = {
			name = "find",
			b = {
				'<Cmd>lua require("internal.fuzzy").buffers()<CR>',
				"Find listed buffers",
			},
			f = { "<Cmd>FZF<CR>", "Find files" },
			g = { '<Cmd>lua require("internal.fuzzy").git_diff()<CR>', "Find dirty files" },
			h = { '<Cmd>lua require("internal.fuzzy").oldfiles()<CR>', "Find recente files" },
			l = {
				'<Cmd>lua require("internal.fuzzy").cword_file_line()<CR>',
				"Find file:line under cursor",
			},
			t = {
				'<Cmd>lua require("internal.fuzzy").terminals()<CR>',
				"Find running terminals",
			},
		},
		p = {
			name = "plugins",
			C = { "<Cmd>PackerClean<CR>", "Clean plugins" },
			c = { "<Cmd>PackerCompile<CR>", "Compile plugins" },
			i = { "<Cmd>PackerInstall<CR>", "Install plugins" },
			l = { "<Cmd>PackerStatus<CR>", "List plugins" },
			u = { "<Cmd>PackerUpdate<CR>", "Update plugins" },
		},
		s = {
			name = "search",
			f = {
				'<Cmd>lua require("internal.search").rg_smart_case()<CR>',
				"Search for a word using ripgrep",
			},
			g = {
				'<Cmd>lua require("internal.search").git_grep()<CR>',
				"Search for a word using Git Grep",
			},
			w = {
				'<Cmd>lua require("internal.search").rg_word()<CR>',
				"Search for <cword>",
			},
			W = {
				'<Cmd>lua require("internal.search").rg_word({ WORD = true })<CR>',
				"Search for <cWORD>",
			},
		},
		t = {
			name = "terminal",
			N = { "<Cmd>terminal<CR>", "Open a new anonymous terminal" },
			S = { "<Cmd>split +terminal<CR>", "Open a new terminal horizontally" },
			T = { "<Cmd>tabnew +terminal<CR>", "Open a new terminal in a new tab" },
			V = { "<Cmd>vsplit +terminal<CR>", "Open a new terminal vertically" },
			n = {
				'<Cmd>lua require("internal.terminal").create()<CR>',
				"Open a new named terminal",
			},
			s = {
				'<Cmd>lua require("internal.terminal").create_horizontal()<CR>',
				"Open a new named terminal horizontally",
			},
			t = {
				'<Cmd>lua require("internal.terminal").create_tab()<CR>',
				"Open a new named terminal in a new tab",
			},
			v = {
				'<Cmd>lua require("internal.terminal").create_vertical()<CR>',
				"Open a new named terminal vertically",
			},
		},
	}, {
		prefix = "<Leader>",
	})
end

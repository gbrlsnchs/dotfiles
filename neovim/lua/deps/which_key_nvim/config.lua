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
			W = { "<Cmd>bwipeout<CR>", "Wipe out buffer and quit window" },
			w = { "<Cmd>Bwipeout<CR>", "Wipe out buffer, preserve window" },
		},
		e = {
			name = "explorer",
			e = {
				'<Cmd>lua require("internal.explorer").open()<CR>',
				"Open file explorer in current buffer",
			},
			s = {
				'<Cmd>lua require("internal.explorer").open_horizontal()<CR>',
				"Open file explorer horizontally",
			},
			v = {
				'<Cmd>lua require("internal.explorer").open_vertical()<CR>',
				"Open file explorer vertically",
			},
			t = {
				'<Cmd>lua require("internal.explorer").open_tab()<CR>',
				"Open file explorer in a new tab",
			},
		},
		f = {
			name = "find",
			["."] = {
				'<Cmd>lua require("internal.fuzzy").find({ use_file_cwd = true })<CR>',
				"Find files in this file's current directory",
			},
			b = {
				'<Cmd>lua require("internal.fuzzy").buffers()<CR>',
				"Find listed buffers",
			},
			d = {
				'<Cmd>lua require("internal.fuzzy").find({ search_type = "directory" })<CR>',
				"Find a directory",
			},
			f = { '<Cmd>lua require("internal.fuzzy").find()<CR>', "Find files" },
			g = { '<Cmd>lua require("internal.fuzzy").git_diff()<CR>', "Find dirty files" },
			h = { '<Cmd>lua require("internal.fuzzy").oldfiles()<CR>', "Find recente files" },
			t = {
				'<Cmd>lua require("internal.fuzzy").terminals()<CR>',
				"Find running terminals",
			},
			w = {
				'<Cmd>lua require("internal.fuzzy").cword_file_line()<CR>',
				"Find file(:line)? under the cursor",
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
			n = {
				'<Cmd>lua require("internal.terminal").create()<CR>',
				"Open a new terminal",
			},
			s = {
				'<Cmd>lua require("internal.terminal").create_horizontal()<CR>',
				"Open a new terminal horizontally",
			},
			t = {
				'<Cmd>lua require("internal.terminal").create_tab()<CR>',
				"Open a new terminal in a new tab",
			},
			v = {
				'<Cmd>lua require("internal.terminal").create_vertical()<CR>',
				"Open a new terminal vertically",
			},
		},
	}, {
		prefix = "<Leader>",
	})

	which_key.register({
		["p"] = { '<Cmd> lua require("winpick").pick_window()<CR>', "Pick a window to focus" },
	}, {
		prefix = "<C-w>",
	})
end

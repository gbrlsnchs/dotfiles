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
		["]Q"] = { "<Cmd>lnext<CR>", "Go to next item in loclist" },
		["[Q"] = { "<Cmd>lprevious<CR>", "Go to previous item in loclist" },
		["]q"] = { "<Cmd>cnext<CR>", "Go to next item in quickfix" },
		["[q"] = { "<Cmd>cprevious<CR>", "Go to previous item in quickfix" },
	})

	-- Register main group names and plugin-free mappings.
	which_key.register({
		b = {
			name = "buffer",
			D = { "<Cmd>bdelete<CR>", "Delete buffer and quit window" },
			N = { "<Cmd>BufferLineCyclePrev<CR>", "Go to previous buffer" },
			d = { "<Cmd>Bdelete<CR>", "Delete buffer, preserve window" },
			n = { "<Cmd>BufferLineCycleNext<CR>", "Go to next buffer" },
		},
		e = {
			name = "explorer",
			e = { "<Cmd>Explore<CR>", "Open file explorer in current buffer" },
			s = { "<Cmd>Sexplore<CR>", "Open file explorer horizontally" },
			v = { "<Cmd>Vexplore<CR>", "Open file explorer vertically" },
		},
		f = {
			name = "find",
			f = { "<Cmd>FZF<CR>", "Search files" },
			-- ["/"] = { "<Cmd>Telescope current_buffer_fuzzy_find<CR>", "Find in buffer" },
			-- ["?"] = { "<Cmd>Telescope buffers<CR>", "Search for a buffer" },
			-- f = {
			-- 	"<Cmd>Telescope find_files find_command=fd,--type,f,--hidden,--exclude,.git<CR>",
			-- 	"Search files",
			-- },
			-- g = { "<Cmd>Telescope git_files<CR>", "Search through Git files" },
			-- r = { "<Cmd>Telescope live_grep<CR>", "Look up words using live grep" },
		},
		p = {
			name = "plugins",
			c = { "<Cmd>PaqClean<CR>", "Clean plugins" },
			i = { "<Cmd>PaqInstall<CR>", "Install plugins" },
			l = { "<Cmd>PaqList<CR>", "List plugins" },
			u = { "<Cmd>PaqUpdate<CR>", "Update plugins" },
		},
		t = {
			name = "terminal",
			N = { "<Cmd>FloatermPrev<CR>", "Go to previous contained terminal" },
			c = { "<Cmd>FloatermNew<CR>", "Open new contained terminal" },
			n = { "<Cmd>FloatermNext<CR>", "Go to next contained terminal" },
			t = { "<Cmd>FloatermToggle<CR>", "Toggle contained terminal" },
		},
	}, {
		prefix = "<Leader>",
	})

	which_key.register({
		g = { ":GrepperGit ", "Prompt file grepper using Git" },
		r = { ":GrepperRg ", "Prompt file grepper using ripgrep" },
	}, {
		prefix = "<Leader>f",
		silent = false,
	})
end

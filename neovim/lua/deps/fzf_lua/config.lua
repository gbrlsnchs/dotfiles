return function()
	-- Keybinding setup.
	local which_key = require("which-key")

	which_key.register({
		["/"] = { "<Cmd>FzfLua current_buffer_fuzzy_find<CR>", "Find in buffer" },
		["?"] = { "<Cmd>FzfLua buffers<CR>", "Search for a buffer" },
		f = {
			"<Cmd>FzfLua files<CR>",
			"Search for files",
		},
		g = { "<Cmd>FzfLua git_files<CR>", "Search through Git files" },
		h = { "<Cmd>FzfLua oldfiles cwd_only=true<CR>", "Search through recent files" },
		r = { "<Cmd>FzfLua live_grep<CR>", "Look up words using live grep" },
	}, {
		prefix = "<Leader>f",
	})

	local fzf_lua = require("fzf-lua")

	fzf_lua.setup({
		files = {
			fd_opts = "--type f --hidden --exclude '.git'",
			git_icons = false,
			file_icons = false,
			color_icons = false,
		},
	})
end

return function()
	local bufline = require("bufferline")

	bufline.setup({
		options = {
			diagnostics = "nvim_lsp",
			show_buffer_close_icons = false,
			show_close_icon = false,
		},
	})

	local which_key = require("which-key")

	which_key.register({
		b = { "<Cmd>BufferLinePick<CR>", "Prompt buffer selection" },
	}, { prefix = "<Leader>b" })
end

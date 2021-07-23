return function()
	local map_opts = { expr = true }
	local set_keymap = vim.api.nvim_set_keymap

	set_keymap("i", "<C-j>", "vsnip#expandable() ? '<Plug>(vsnip-expand)' : '<C-j>'", map_opts)
	set_keymap("s", "<C-j>", "vsnip#expandable() ? '<Plug>(vsnip-expand)' : '<C-j>'", map_opts)
	set_keymap("i", "<C-l>", "vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'", map_opts)
	set_keymap("s", "<C-l>", "vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'", map_opts)
	set_keymap("i", "<Tab>", "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'", map_opts)
	set_keymap("s", "<Tab>", "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'", map_opts)
	set_keymap("i", "<S-Tab>", "vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'", map_opts)
	set_keymap("s", "<S-Tab>", "vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'", map_opts)

	vim.g.vsnip_filetypes = {
		javascriptreact = {'javascript'},
		typescriptreact = {'typescript'},
	}
end

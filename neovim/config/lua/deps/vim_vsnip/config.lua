return function()
	local map_opts = { expr = true }
	local set_keymap = vim.api.nvim_set_keymap

	for _, mode in ipairs({ "i", "s" }) do
		set_keymap(mode, "<C-j>", "vsnip#expandable() ? '<Plug>(vsnip-expand)' : '<C-j>'", map_opts)
		set_keymap(
			mode,
			"<C-l>",
			"vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'",
			map_opts
		)
		set_keymap(
			mode,
			"<Tab>",
			"vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'",
			map_opts
		)
		set_keymap(
			mode,
			"<S-Tab>",
			"vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'",
			map_opts
		)
	end

	vim.g.vsnip_filetypes = {
		javascriptreact = { "javascript" },
		typescriptreact = { "typescript" },
	}
end

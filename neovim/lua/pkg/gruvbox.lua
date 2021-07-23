return function()
	vim.g.gruvbox_invert_selection = false
	vim.api.nvim_exec(
		[[
augroup gruvbox
	autocmd!
	autocmd ColorScheme * highlight! link NormalFloat Normal | highlight! link CompeDocumentation Pmenu
augroup END
	]],
		false
	)
end

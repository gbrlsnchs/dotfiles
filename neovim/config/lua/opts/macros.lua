vim.cmd([[
augroup custom_macros
	autocmd!
	autocmd BufEnter,WinClosed * lua require("lib.macros").set_macros()
augroup END
]])

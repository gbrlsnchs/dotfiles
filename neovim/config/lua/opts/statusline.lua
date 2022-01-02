-- This sets current focused window, allowing the statusline function to know whether to render an
-- active or inactive line.
vim.cmd([[
augroup status_line
	autocmd!
	autocmd WinEnter,BufWinEnter,BufEnter,WinClosed * lua require("lib.win").set_focused_win()
augroup END
]])

-- We only need to set the statusline once, globally, and it will update accordingly, since it knows
-- which window is currently focused.
vim.opt.statusline = [[%{%v:lua.require('lib.statusline').build_statusline()%}]]
vim.opt.tabline = [[%{%v:lua.require('lib.statusline').build_tabline()%}]]
vim.opt.laststatus = 2

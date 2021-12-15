vim.env.EDITOR = "nvr --remote-wait"
vim.env.GIT_EDITOR = "nvr -cc tabnew --remote-wait +'setlocal bufhidden=wipe'"
vim.env.GIT_PAGER =
	"nvr -cc tabnew --remote-wait +'Man! | setlocal bufhidden=wipe number relativenumber | setfiletype git' -"

vim.notify = require("internal.notify")

vim.opt.background = "dark"
vim.cmd("colorscheme custom")

vim.cmd([[
augroup status_line
	autocmd!
	autocmd WinEnter,BufEnter * setlocal statusline=%!v:lua.require('local.statusline').get_statusline('active')
	autocmd WinLeave,BufLeave * setlocal statusline=%!v:lua.require('local.statusline').get_statusline('inactive')
augroup END
]])

require("opt")
require("deps")

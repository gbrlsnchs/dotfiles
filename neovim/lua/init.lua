vim.o.compatible = false
vim.o.showmode = false
vim.o.laststatus = 2
vim.o.showtabline = 2
vim.o.pumheight = 10
vim.o.title = true
vim.o.incsearch = true
vim.o.inccommand = 'split'
vim.o.completeopt = 'menuone,noinsert,noselect'
vim.o.shortmess = table.concat({vim.o.shortmess, 'c'}, '')
vim.o.diffopt = table.concat({
  vim.o.diffopt,
  'algorithm:patience',
  'indent-heuristic',
  'iwhiteall',
  'hiddenoff',
}, ',')
vim.o.backspace = '2'
vim.o.virtualedit = 'block'
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.tabstop = 4
vim.o.shiftwidth = 2
vim.o.wrap = true
vim.o.linebreak = true
vim.o.list = true
vim.o.listchars = table.concat({'tab:⇥ ', 'space:‧', 'eol:↴', 'trail:␣'}, ',')
vim.o.timeoutlen = 500
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.hidden = true

vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.signcolumn = 'yes:2'
vim.wo.colorcolumn = '100'

-- Load external plugins.
require('plugins')

-- Load configs.
require('config.theme')
require('config.navigation')
require('config.lsp')
require('config.syntax')
require('config.utils')

vim.cmd [[augroup TreeSitterFolds]]
vim.cmd   [[autocmd BufEnter * setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr() foldlevel=99]]
vim.cmd [[augroup END]]

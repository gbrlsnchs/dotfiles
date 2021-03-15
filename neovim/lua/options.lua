vim.o.termguicolors = true
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
vim.o.listchars = table.concat({'tab:⇥ ', 'eol:↴', 'trail:␣'}, ',')
vim.o.timeoutlen = 500
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.hidden = true
vim.o.formatoptions = table.concat({'t', 'c', 'q', 'n', ']', 'j'}, '')
vim.o.textwidth = 100
vim.o.guicursor = ''

vim.wo.list = true
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.signcolumn = 'yes:2'
vim.wo.colorcolumn = '100'

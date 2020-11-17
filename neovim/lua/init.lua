-- Load external plugins.
require('plugins')

-- Load configs.
require('config.theme')
require('config.navigation')
require('config.lsp')
require('config.syntax')
require('config.utils')

vim.o.compatible = false
vim.o.showmode = false
vim.o.number = true
vim.o.laststatus = 2
vim.o.showtabline = 2
vim.o.signcolumn = 'yes:1'
vim.o.relativenumber = true
vim.o.pumheight = 10
vim.o.title = true
vim.o.incsearch = true
vim.o.inccommand = 'split'
vim.o.completeopt = 'menuone,noinsert,noselect'
vim.o.shortmess = 'c'
vim.o.diffopt = 'algorithm:patience,indent-heuristic,iwhiteall,hiddenoff'
vim.o.backspace = '2'
vim.o.virtualedit = 'block'
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.tabstop = 4
vim.o.shiftwidth = 2
vim.o.colorcolumn = '100'
vim.o.wrap = true
vim.o.linebreak = true
vim.o.list = true
vim.o.listchars = 'tab:‣ ,eol:↴,trail:␣'
vim.o.timeoutlen = 500
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.hidden = true
vim.o.foldlevel = 99


-- TODO: config.git
require('gitsigns').setup({
  signs = {
    add          = { hl = 'GitGutterAdd', text = '▒' },
    change       = { hl = 'GitGutterChange', text = '░' },
    delete       = { hl = 'GitGutterDelete' },
    topdelete    = { hl = 'GitGutterDelete' },
    changedelete = { hl = 'GitGutterChangeDelete' },
  },
  keymaps = {
    noremap = false,
  },
})

vim.cmd [[augroup TreeSitterFolds]]
vim.cmd   [[autocmd BufEnter * setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()]]
vim.cmd [[augroup END]]

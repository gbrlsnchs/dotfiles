require('options')
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

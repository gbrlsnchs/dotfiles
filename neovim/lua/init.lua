-- Load external plugins.
require('plugins')

-- Load configs.
require('config.theme')
require('config.navigation')
require('config.lsp')
require('config.syntax')
require('config.utils')

-- TODO: config.git
require('gitsigns').setup({
  signs = {
    add =          { hl = 'GitGutterAdd', text = '░' },
    change =       { hl = 'GitGutterChange', text = '░' },
    delete =       { hl = 'GitGutterDelete' },
    changedelete = { hl = 'GitGutterChangeDelete' },
  },
  keymaps = {
    noremap = false,
  },
})

vim.cmd [[augroup TreeSitterFolds]]
vim.cmd   [[autocmd BufEnter * setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()]]
vim.cmd [[augroup END]]

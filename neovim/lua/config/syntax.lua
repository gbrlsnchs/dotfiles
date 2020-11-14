vim.cmd [[packadd nvim-treesitter]]

require('nvim-treesitter.configs').setup({
  ensure_installed = 'all',
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
})

vim.cmd [[autocmd BufEnter *.toml setlocal filetype=toml]]

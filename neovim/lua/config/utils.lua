-- Markdown Preview
vim.cmd [[
  function! g:Open_browser(url)
    silent exec 'silent !chromium --new-window ' . a:url
  endfunction
]]

vim.g.mkdp_browserfunc = 'g:Open_browser'

-- suda.vim
vim.g.suda_smart_edit = true

-- lightline.vim
vim.g.lightline = {
  colorscheme = 'nord',
  active = {
    left = {
      {'mode', 'paste'},
      {'gitbranch', 'readonly', 'filename', 'modified'},
    },
  },
  component_function = {
    gitbranch = 'gitbranch#name',
  },
}

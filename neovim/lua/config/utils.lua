-- Markdown Preview
vim.cmd [[
  function! g:Open_browser(url)
    silent exec 'silent !chromium --new-window ' . a:url
  endfunction
]]

vim.g.mkdp_browserfunc = 'g:Open_browser'

-- lightline.vim
vim.cmd [[
  function! g:LightlineReadonly()
    return luaeval("require('functions.utils').lightline_readonly()")
  endfunction

  function! g:LightlineGitBranch()
    return luaeval("require('functions.utils').lightline_gitbranch()")
  endfunction
]]

vim.g.lightline = {
  enable = {
    statusline = true,
    tabline = true,
  },
  colorscheme = 'nord',
  active = {
    left = {
      {'mode', 'paste'},
      {'gitbranch', 'readonly', 'filename', 'modified'},
    },
    right = {
      {'lineinfo'},
      {'percent'},
      {'fileformat', 'fileencoding', 'filetype', 'charvaluehex'},
    },
  },
  component = {
    charvaluehex = '0x%B',
    lineinfo = '%-3l %-2v',
  },
  component_function = {
    gitbranch = 'LightlineGitBranch',
    readonly = 'LightlineReadonly',
  },
  component_type = {
    buffers = 'tabsel',
  },
  separator = {
    left = "",
    right = "",
  },
  subseparator = {
    left = "",
    right = "",
  },
}

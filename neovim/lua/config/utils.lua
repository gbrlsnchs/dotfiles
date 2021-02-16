-- lightline.vim
vim.cmd [[
  function! g:LightlineReadonly()
    return luaeval("require('functions.utils').lightline_readonly()")
  endfunction

  function! g:LightlineGitBranch()
    return luaeval("require('functions.utils').lightline_gitbranch()")
  endfunction

  function! g:LightlineGitHunks()
    return luaeval("require('functions.utils').lightline_githunks()")
  endfunction

  function! g:LightlineFilename()
    return expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
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
      {'gitbranch', 'githunks', 'readonly', 'filename', 'modified'},
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
    githunks = 'LightlineGitHunks',
    readonly = 'LightlineReadonly',
    filename = 'LightlineFilename',
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

-- vim-leader-guide
vim.g.mapleader = ' '
vim.g.lmap = {
  b = {
    name = 'buffers',
    ['?'] = 'fzf-buffers',
    d = 'buffer-delete',
    D = 'buffer-delete-stay',
    l = 'fzf-buffer-lines',
    n = 'next-buffer',
    p = 'previous-buffer',
  },
  f = {
    name = 'files',
    ['?'] = 'fzf-ripgrep',
    f = 'fzf-files',
    g = 'fzf-git-files',
    p = 'fzf-ripgrep-prompt', -- TODO: use vim.fn.prompt!
  },
  g = {
    name = 'git',
    r = 'reset-hunk',
    s = 'stage-hunk',
    p = 'preview-hunk',
    u = 'undo-stage-hunk',
  },
  l = {
    name = 'lsp',
    c = 'lsp-code-action',
    r = 'lsp-rename',
  },
  t = {
    name = 'terminal',
    n = 'new-terminal',
    s = 'split-terminal',
    v = 'vsplit-terminal',
    t = 'tabnew-terminal',
  },
}

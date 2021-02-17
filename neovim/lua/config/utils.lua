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

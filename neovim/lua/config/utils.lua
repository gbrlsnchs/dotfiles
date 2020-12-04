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
  l = {
    name = 'lsp',
    c = 'lsp-code-action',
    r = 'lsp-rename',
  },
  t = {
    name = 'terminal',
    s = 'split-terminal',
    v = 'vsplit-terminal',
    t = 'tabnew-terminal',
  },
}

vim.fn['leaderGuide#register_prefix_descriptions']('<Space>', 'g:lmap')
vim.cmd [[nnoremap <silent> <Leader> :<C-u>LeaderGuide '<Space>'<CR>]]
--- Buffer mappings
vim.cmd [[nnoremap <Leader>b? <Cmd>Buffers<CR>]]
vim.cmd [[nnoremap <Leader>bl <Cmd>BLines<CR>]]
vim.cmd [[nnoremap <Leader>bn <Cmd>bnext<CR>]]
vim.cmd [[nnoremap <Leader>bp <Cmd>bprevious<CR>]]
--- Find mappings
vim.cmd [[nnoremap <Leader>f? <Cmd>Rg<CR>]]
vim.cmd [[nnoremap <Leader>ff <Cmd>Files<CR>]]
vim.cmd [[nnoremap <Leader>fg <Cmd>GitFiles<CR>]]
vim.cmd [[nnoremap <Leader>fp :Rg ]]
--- LSP mappings
vim.cmd [[nnoremap <Leader>lc :lua vim.lsp.buf.code_action()<CR>]]
vim.cmd [[nnoremap <Leader>lr :lua vim.lsp.buf.rename()<CR>]]
--- Terminal mappings
vim.cmd [[nnoremap <Leader>ts :split +terminal<CR>]]
vim.cmd [[nnoremap <Leader>tv :vsplit +terminal<CR>]]
vim.cmd [[nnoremap <Leader>tt :tabnew +terminal<CR>]]

let $GIT_EDITOR = "nvr -cc tabnew --remote-wait +'setlocal bufhidden=wipe'"
let $VISUAL = "nvr -cc split --remote-wait +'setlocal bufhidden=wipe'"

lua require('init')

syntax on

set nocompatible
set noshowmode
set number
set laststatus=2
set showtabline=2
set signcolumn=yes:2
set relativenumber
set pumheight=10
set title
set incsearch
set inccommand=split
set completeopt=menuone,noinsert,noselect
set shortmess+=c
set diffopt+=algorithm:patience,indent-heuristic,iwhiteall,hiddenoff
set backspace=2
set virtualedit=block
set expandtab
set autoindent
set tabstop=4
set shiftwidth=2
set colorcolumn=100
set wrap
set linebreak
set list lcs+=tab:‣\ ,eol:↴,trail:␣
set timeoutlen=500
set splitright
set splitbelow
set hidden
set foldlevel=99
set spell

autocmd TermOpen * setlocal nospell

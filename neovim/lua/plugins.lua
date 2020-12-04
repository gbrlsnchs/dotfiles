-- TODO: Dinamically download packer.nvim when it doesn't exist.
-- TODO: Use `vim.cmd` after upgrading to nightly builds.
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  use {'wbthomason/packer.nvim', opt = true}

  --- Navigation
  use 'mhinz/vim-startify'
  use 'junegunn/fzf.vim'

  --- LSP
  use {
    'neovim/nvim-lspconfig',
    opt = true,
  }
  use {
    'nvim-lua/completion-nvim',
    opt = true,
    requires = {
      {'hrsh7th/vim-vsnip', opt = true},
      {'hrsh7th/vim-vsnip-integ', opt = true},
    },
  }
  use {
    'tjdevries/nlua.nvim',
    opt = true,
  }

  --- Git
  -- I'm trying to move to neovim-remote with integrated terminal.
  use {
    'lewis6991/gitsigns.nvim',
    branch = 'main',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    config = [[require('config.gitsigns')]],
  }

  --- Utils
  use 'moll/vim-bbye'
  use 'tpope/vim-surround'
  use 'tpope/vim-commentary'
  use 'tpope/vim-sleuth'
  use 'lambdalisue/suda.vim'
  use {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  }
  use {
    'iamcco/markdown-preview.nvim',
    run = 'cd app && yarn install',
    ft = {'markdown'},
    cmd = 'MarkdownPreview',
  }
  use {
    'itchyny/lightline.vim',
    requires = {
      {'itchyny/vim-gitbranch'},
    },
  }
  use 'spinks/vim-leader-guide'

  --- Syntax
  use {
    'nvim-treesitter/nvim-treesitter',
    opt = true,
  }
  use 'editorconfig/editorconfig-vim'

  --- Theme
  use 'arcticicestudio/nord-vim'
end)

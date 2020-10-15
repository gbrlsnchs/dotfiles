-- TODO: Dinamically download packer.nvim when it doesn't exist.
-- TODO: Use `vim.cmd` after upgrading to nightly builds.
vim.cmd [[packadd packer.nvim]]
vim._update_package_paths()

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
    'nvim-lua/diagnostic-nvim',
    opt = true,
  }

  --- Git
  -- I'm trying to move to neovim-remote with integrated terminal.

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

  --- Syntax
  use {
    'nvim-treesitter/nvim-treesitter',
    opt = true,
  }

  --- Theme
  use 'arcticicestudio/nord-vim'
end)

require('utils.packer').bootstrap()

return require('packer').startup(function()
  use(require('specs.packer'))

  --- Navigation
  use(require('specs.startify'))
  use(require('specs.fzf'))
  use(require('specs.lspconfig'))
  use(require('specs.compe'))
  use(require('specs.gitsigns'))
  use(require('specs.leader_guide'))

  --- Utils
  use 'moll/vim-bbye'
  use 'tpope/vim-surround'
  use 'tpope/vim-commentary'
  use 'tpope/vim-sleuth'
  use 'lambdalisue/suda.vim'
  use {
    'RRethy/vim-hexokinase',
    run = 'make hexokinase',
  }
  use {
    'iamcco/markdown-preview.nvim',
    run = 'cd app && yarn install',
    ft = {'markdown', 'plantuml'},
    cmd = 'MarkdownPreview',
    config = function()
      vim.g.mkdp_filetypes = {'markdown', 'plantuml'}
    end,
  }
  use {
    'itchyny/lightline.vim',
    requires = {
      {'itchyny/vim-gitbranch'},
    },
  }
  use 'dstein64/nvim-scrollview'

  --- Syntax
  use {
    'nvim-treesitter/nvim-treesitter',
    opt = true,
    run = ':TSUpdate',
  }
  use 'editorconfig/editorconfig-vim'
  use {
    'https://github.com/aklt/plantuml-syntax',
    config = function()
      vim.g.plantuml_set_makepr = false
    end,
  }

  --- Theme
  use 'arcticicestudio/nord-vim'
end)

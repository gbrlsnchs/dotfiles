vim.cmd [[packadd vim-vsnip]]
vim.cmd [[packadd vim-vsnip-integ]]
vim.cmd [[packadd completion-nvim]]
vim.cmd [[packadd diagnostic-nvim]]
vim.cmd [[packadd nvim-lspconfig]]

local completion = require('completion')
local diagnostic = require('diagnostic')
local nvim_lsp = require('nvim_lsp')

local function custom_attach(client)
  --- Custom LSP keybindings
  vim.cmd [[nnoremap <buffer><silent> gd                <Cmd>lua vim.lsp.buf.declaration()<CR>]]
  vim.cmd [[nnoremap <buffer><silent> <C-]>             <Cmd>lua vim.lsp.buf.definition()<CR>]]
  vim.cmd [[nnoremap <buffer><silent> K                 <Cmd>lua vim.lsp.buf.hover()<CR>]]
  vim.cmd [[nnoremap <buffer><silent> <C-h>             <Cmd>lua require('jumpLoc').openLineDiagnostics()<CR>]]
  vim.cmd [[nnoremap <buffer><silent> gD                <Cmd>lua vim.lsp.buf.implementation()<CR>]]
  vim.cmd [[nnoremap <buffer><silent> <C-k>             <Cmd>lua vim.lsp.buf.signature_help()<CR>]]
  vim.cmd [[nnoremap <buffer><silent> 1gD               <Cmd>lua vim.lsp.buf.type_definition()<CR>]]
  vim.cmd [[nnoremap <buffer><silent> gr                <Cmd>lua vim.lsp.buf.references()<CR>]]
  vim.cmd [[nnoremap <buffer><silent> g0                <Cmd>lua vim.lsp.buf.document_symbol()<CR>]]
  vim.cmd [[inoremap <buffer><silent><expr> <C-Space>   completion#trigger_completion()]]
  vim.cmd [[inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"]]
  vim.cmd [[inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"]]

  vim.cmd [[augroup lsp]]
  vim.cmd       [[au! BufWritePre <buffer> :lua vim.lsp.buf.formatting_sync()]]
  vim.cmd [[augroup END]]

  --- Custom attachments
  completion.on_attach(client)
  diagnostic.on_attach(client)
end

local configs = {
  cssls = {},
  diagnosticls = {
    filetypes = {
      'typescript',
      'typescriptreact',
      'typescript.tsx',
    },
    root_dir = nvim_lsp.util.root_pattern('package.json'),
    init_options = {
      formatters = {
        ['prettier-ts'] = {
          command = './node_modules/.bin/prettier',
          args = {'--stdin-filepath', '%filename'},
          rootPatterns = {'package.json'},
          requiredFiles = {
            '.prettierrc',
            '.prettierrc.json',
            '.prettierrc.yml',
            '.prettierrc.yaml',
            '.prettierrc.json5',
            '.prettierrc.js',
            '.prettierrc.cjs',
            '.prettierrc.toml',
            'prettier.config.js',
            'prettier.config.cjs',
          },
        },
      },
      formatFiletypes = {
        typescript = 'prettier-ts',
        typescriptreact = 'prettier-ts',
        ['typescript.tsx'] = 'prettier-ts',
      },
    },
  },
  gopls = {},
  rust_analyzer = {
    settings = {
      ['rust-analyzer'] = {
        checkOnSave = {
          command = 'clipply',
          overrideCommand = {
            'cargo',
            'clippy',
            '--workspace',
            '--message-format=json',
            '--all-targets',
          },
        },
      },
    },
  },
  tsserver = {},
}

-- Temporarily disable servers by adding their names here.
local denylist = {
  diagnosticls = true,
}

-- Add custom attach handler and register settings.
for conf, settings in pairs(configs) do
  if denylist[conf] then
    goto continue
  end

  settings.on_attach = custom_attach

  nvim_lsp[conf].setup(settings)

  ::continue::
end

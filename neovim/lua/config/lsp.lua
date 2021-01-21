vim.cmd [[packadd vim-vsnip]]
vim.cmd [[packadd vim-vsnip-integ]]
vim.cmd [[packadd completion-nvim]]
vim.cmd [[packadd nvim-lspconfig]]

local completion = require('completion')
local nvim_lsp = require('lspconfig')

local function global_attach(client)
  --- Custom LSP keybindings
  vim.cmd [[nnoremap <buffer><silent> gd                <Cmd>lua vim.lsp.buf.declaration()<CR>]]
  vim.cmd [[nnoremap <buffer><silent> <C-]>             <Cmd>lua vim.lsp.buf.definition()<CR>]]
  vim.cmd [[nnoremap <buffer><silent> K                 <Cmd>lua vim.lsp.buf.hover()<CR>]]
  vim.cmd [[nnoremap <buffer><silent> <C-h>             <Cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>]]
  vim.cmd [[nnoremap <buffer><silent> gD                <Cmd>lua vim.lsp.buf.implementation()<CR>]]
  vim.cmd [[nnoremap <buffer><silent> <C-k>             <Cmd>lua vim.lsp.buf.signature_help()<CR>]]
  vim.cmd [[nnoremap <buffer><silent> 1gD               <Cmd>lua vim.lsp.buf.type_definition()<CR>]]
  vim.cmd [[nnoremap <buffer><silent> gr                <Cmd>lua vim.lsp.buf.references()<CR>]]
  vim.cmd [[nnoremap <buffer><silent> g0                <Cmd>lua vim.lsp.buf.document_symbol()<CR>]]
  vim.cmd [[inoremap <buffer><silent><expr> <C-Space>   completion#trigger_completion()]]
  vim.cmd [[inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"]]
  vim.cmd [[inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"]]

  if client.resolved_capabilities.document_formatting then
    print('initting server ' .. client.name)
    vim.cmd [[augroup lsp_formatting]]
    vim.cmd [[autocmd!]]
    vim.cmd [[autocmd BufWritePre <buffer> :lua vim.lsp.buf.formatting_sync()]]
    vim.cmd [[augroup END]]
  end

  vim.cmd [[sign define LspDiagnosticsSignError text=🅴 texthl=LspDiagnosticsSignError linehl= numhl=]]
  vim.cmd [[sign define LspDiagnosticsSignWarning text=🆆 texthl=LspDiagnosticsSignWarning linehl= numhl=]]
  vim.cmd [[sign define LspDiagnosticsSignInformation text=🅸 texthl=LspDiagnosticsSignInformation linehl= numhl=]]
  vim.cmd [[sign define LspDiagnosticsSignHint text=🅷 texthl=LspDiagnosticsSignHint linehl= numhl=]]

  --- Custom attachments
  completion.on_attach(client)
end

vim.g.completion_customize_lsp_label = {
  Function = 'ƒ (function)',
  Method = '⊞ (method)',
  Variable = '⍺ (variable)',
  Constant = 'π (constant)',
  Struct = '⍋ (struct)',
  Class = '🯅 (class)',
  Interface = '⍦ (interface)',
  Text = '¶ (text)',
  Enum = '⚑ (enum)',
  EnumMember = '⚐ (enum member)',
  Module = '⌹ (module)',
  Color = '⊳ (color)',
  Property = '⊡ (property)',
  Field = '⊙ (field)',
  Unit = '⊡ (unit)',
  File = '☵ (file)',
  Value = '⅓ (value)',
  Event = '⚡(event)',
  Folder = '≣ (folder)',
  Keyword = '≝ (keyword)',
  Snippet = '⊕ (snippet)',
  Operator = '✚ (operator)',
  Reference = '≔ (reference)',
  TypeParameter = '⍶ (type parameter)',
  Default = '⍰ (default)',
}

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
  {
    virtual_text = false,
    signs = true,
  }
)

local efm_formatters = {
  prettier = {
    formatCommand = [[./node_modules/.bin/prettier]],
    rootMarkers = {'package.json'},
  },
}

local configs = {
  cssls = {},
  efm = {
    cmd = {'efm-langserver', '-logfile', '/tmp/efm.log', '-loglevel', '5'},
    init_options = {
      documentFormatting = true,
    },
    filetypes = {'typescript', 'typescriptreact'},
    settings = {
      rootMarkers = {'.git/'},
      languages = {
        typescript = {efm_formatters.prettier},
        typescriptreact = {efm_formatters.prettier},
      },
    },
  },
  gopls = {},
  pyright = {},
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
  sumneko_lua = {
    cmd = {'lua-language-server'},
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
        },
        diagnostics = {
          globals = {'use', 'vim'},
        },
        workspace = {
          library = {
            [vim.fn.expand('$VIMRUNTIME/lua')] = true,
            [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
          },
        },
      },
    },
  },
  tsserver = {
    on_attach = function(client)
      client.resolved_capabilities.document_formatting = false
    end,
  },
}

-- Temporarily disable servers by adding their names here.
local denylist = {}

-- Add custom attach handler and register settings.
for conf, settings in pairs(configs) do
  if denylist[conf] then
    goto continue
  end

  local local_attach = settings.on_attach
  if local_attach ~= nil then
    settings.on_attach = function(client)
      local_attach(client)
      global_attach(client)
    end
  else
    settings.on_attach = global_attach
  end

  nvim_lsp[conf].setup(settings)

  ::continue::
end

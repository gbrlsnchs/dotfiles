vim.cmd [[packadd vim-vsnip]]
vim.cmd [[packadd vim-vsnip-integ]]
vim.cmd [[packadd completion-nvim]]
vim.cmd [[packadd diagnostic-nvim]]
vim.cmd [[packadd nvim-lspconfig]]

local completion = require('completion')
local diagnostic = require('diagnostic')
local nvim_lsp = require('nvim_lsp')

local function custom_attach()
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
  completion.on_attach()
  diagnostic.on_attach()
end

local configs = {
  gopls = {},
  tsserver = {},
}

-- Add custom attach handler and register settings.
for conf, settings in pairs(configs) do
  settings.on_attach = custom_attach

  nvim_lsp[conf].setup(settings)
end

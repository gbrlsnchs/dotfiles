local M = {}

local is_disabled = os.getenv('NVIM_DISABLE_LSP')

M.cmd_name = function(feat)
  return string.format('<Cmd>lua vim.lsp.buf.%s()<CR>', feat)
end

M.is_enabled = function()
  return not is_disabled
end

return M

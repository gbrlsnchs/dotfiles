local M = {}

local is_disabled = os.getenv('NVIM_DISABLE_LSP')

M.is_enabled = function()
  return not is_disabled
end

return M

local M = {}

local is_disabled = os.getenv('NVIM_DISABLE_LSP')

M.cmd_name = function(feat)
  return string.format('<Cmd>lua vim.lsp.buf.%s()<CR>', feat)
end

M.on_buf_enter = function(_)
  local map_opts = {noremap = true, silent = true}
  local set_keymap = vim.api.nvim_buf_set_keymap

  set_keymap(0, 'n', 'gd',    M.cmd_name('declaration'), map_opts)
  set_keymap(0, 'n', '<C-]>', M.cmd_name('definition'), map_opts)
  set_keymap(0, 'n', 'K',     M.cmd_name('hover'), map_opts)
  set_keymap(0, 'n', 'gD',    M.cmd_name('implementation'), map_opts)
  set_keymap(0, 'n', '<C-k>', M.cmd_name('signature_help'), map_opts)
end

M.is_enabled = function()
  return not is_disabled
end

return M

local state_path = vim.fn.stdpath("state")

local M = {}

M.cmd = { "jdtls", "-data", string.format("%s/jdtls", state_path) }

return M

local M = {}

M.lightline_readonly = function()
  return (vim.bo.readonly or vim.o.readonly) and '' or ''
end

M.lightline_gitbranch = function()
  local git_branch = vim.fn['gitbranch#name']()

  if git_branch == nil or git_branch == '' then
    return ''
  end

  return ' ' .. git_branch
end

M.lightline_githunks = function()
  return vim.b.gitsigns_status or ''
end

return M

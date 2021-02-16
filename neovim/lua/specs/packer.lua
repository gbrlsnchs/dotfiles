local M = {'wbthomason/packer.nvim'}

M.config = function()
	vim.cmd('autocmd BufWritePost plugins.lua PackerCompile')
end

return M

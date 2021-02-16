local M = {'ojroques/nvim-lspfuzzy'}

M.config = function()
	require('lspfuzzy').setup({})
end

M.cond = function()
	return require('utils.lsp').is_enabled()
end

return M

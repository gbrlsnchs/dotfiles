local M = {}

M.bootstrap = function()
	local install_path = string.format('%s/%s',
		vim.fn.stdpath('data'),
		'site/pack/packer/start/packer.nvim'
	)

	if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
		local git_url = 'https://github.com/wbthomason/packer.nvim'
		local clone_cmd = string.format('!git clone %s %s', git_url, install_path)

		vim.cmd(clone_cmd)
	end
end

return M

local listen_addr = vim.v.servername
local remote_nvim

if vim.fn.executable("nvr") == 1 then
	remote_nvim = string.format("nvr --servername %s", listen_addr)
else
	remote_nvim = string.format("%s --server %s", vim.v.progname, listen_addr)
end

vim.env.EDITOR = string.format("%s --remote-tab-wait", remote_nvim)
vim.env.VISUAL = string.format("%s --remote-tab-wait", remote_nvim)
vim.env.GIT_EDITOR = string.format("%s --remote-tab-wait", remote_nvim)
vim.env.GIT_PAGER = string.format("%s --remote-tab-wait +'Man! | setfiletype git' -", remote_nvim)

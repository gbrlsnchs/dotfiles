local util = require("me.api.util")

local listen_addr = vim.v.servername
local remote_nvim

if vim.fn.executable("nvr") == 1 then
	remote_nvim = string.format("nvr --servername %s", listen_addr)
else
	remote_nvim = string.format("%s --server %s", vim.v.progname, listen_addr)
end


local M = {}

--- Sets up environment variables and stuff.
--- @param opts table: List of custom environment variables to be set for the whole session.
function M.setup(opts)
	opts = util.tbl_merge(opts, {
		EDITOR = string.format("%s --remote-wait", remote_nvim),
		VISUAL = string.format("%s --remote-wait", remote_nvim),
		GIT_EDITOR = string.format("%s -cc tabnew --remote-wait +'setlocal bufhidden=wipe'", remote_nvim),
		GIT_PAGER = string.format("%s -cc tabnew --remote-wait +'Man! | setlocal bufhidden=wipe number relativenumber | setfiletype git' -", remote_nvim),
	})

	for var_name, var_value in pairs(opts) do
		vim.env[var_name] = var_value
	end
end

return M

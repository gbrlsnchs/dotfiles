local config = require("me.api.config")

local listen_addr = vim.v.servername
local remote_nvim

local function set_env()
	local env = config.get("env") or {}

	for varname, value in pairs(env) do
		if type(value) == "table" then
			value = table.concat(value, ",")
		end
		vim.env[varname] = value
	end
end

if vim.fn.executable("nvr") == 1 then
	remote_nvim = string.format("nvr --servername %s", listen_addr)
else
	remote_nvim = string.format("%s --server %s", vim.v.progname, listen_addr)
end

vim.env.EDITOR = string.format("%s --remote-wait", remote_nvim)
vim.env.VISUAL = string.format("%s --remote-wait", remote_nvim)
vim.env.GIT_EDITOR = string.format("%s --remote-wait", remote_nvim)
vim.env.GIT_PAGER = string.format("%s --remote-wait +'setfiletype git' -", remote_nvim)

-- HACK: This is an undocumented feature of Git. Usable until it stops working.
-- vim.env.GIT_CONFIG_PARAMETERS = "'color.ui=never'"

config.on_change(set_env, "env")
set_env()

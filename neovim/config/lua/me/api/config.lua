local yml = require("lyaml")

local io = require("me.api.io")

local config = {}

local M = {}

function M.get(...)
	return vim.tbl_get(config, ...)
end

function M.set(key, value)
	config[key] = vim.tbl_deep_extend("keep", config[key] or {}, value)
end

function M.read()
	local nvimrc = io.read_file(".nvimrc")
	local overrides

	if nvimrc then
		-- Substitute environment variables.
		nvimrc = nvimrc
			:gsub("$%$", "\0")
			:gsub("${([%w_]+)}", os.getenv)
			:gsub("$([%w_]+)", os.getenv)
			:gsub("%z", "$")

		overrides = yml.load(nvimrc)
	end

	config = vim.tbl_deep_extend("force", config, overrides or {})

	-- Update environment variables.
	for var_name, var_value in pairs(config.env or {}) do
		vim.env[var_name] = var_value
	end
end

return M

local yml = require("lyaml")

local io = require("me.api.io")

local config = {}
local handlers = {}
local handlers_added = {}
local sections = {}

local M = {}

function M.get(...)
	return vim.tbl_get(config, ...)
end

function M.set(key, value)
	config[key] = vim.tbl_deep_extend("keep", config[key] or {}, value)
end

--- Registers a callback to be executed when the configuration changes.
--- @param fn function: Callback to be executed.
--- @param section string: Configuration section for the callback to react to.
function M.on_change(fn, section)
	if handlers_added[fn] then
		return
	end

	if not handlers[section] then
		table.insert(sections, section)
		handlers[section] = { fn }
	else
		table.insert(handlers[section], fn)
	end

	handlers_added[fn] = true
end

function M.read()
	local nvimrc = io.read_file(".nvimrc")
	local overrides = {}

	if nvimrc then
		-- Substitute environment variables.
		nvimrc = nvimrc
			:gsub("$%$", "\0")
			:gsub("${([%w_]+)}", os.getenv)
			:gsub("$([%w_]+)", os.getenv)
			:gsub("%z", "$")

		overrides = yml.load(nvimrc)
	end

	config = vim.tbl_deep_extend("force", config, overrides)

	for _, section in ipairs(sections) do
		for _, fn in ipairs(handlers[section] or {}) do
			fn()
		end
	end
end

return M

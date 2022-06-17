-- TODO: Log errors.
local function bootstrap()
	local rocks_home = vim.fn.stdpath("data") .. "/site/rocks"

	-- HACK: This lets us load LuaRocks packages from wherever we want.
	package.path = package.path .. ";" .. (rocks_home .. "/share/lua/5.1/?.lua")
	package.path = package.path .. ";" .. (rocks_home .. "/share/lua/5.1/?/init.lua")
	package.cpath = package.cpath .. ";" .. (rocks_home .. "/lib/lua/5.1/?.so")
	package.cpath = package.cpath .. ";" .. (rocks_home .. "/lib/lua/5.1/?/loadall.so")

	local yml = require("lyaml")

	local io = require("me.api.io")

	local opts_yml = io.read_file("neovim.yml")

	if not opts_yml then
		return nil
	end

	-- Substitute environment variables.
	opts_yml = opts_yml:gsub('$%$', '\0')
		:gsub('${([%w_]+)}', os.getenv)
		:gsub('$([%w_]+)', os.getenv)
		:gsub('%z', '$')

	return yml.load(opts_yml)
end

local opts = bootstrap() or {}

-- Order of loading matters.
-- TODO: Set up 'macros' and SQLite connection.
local modules = {
	"session",
	"env",
	"options",
	"editor",
	"syntax",
	"ui",
	"diagnostics",
	"lsp",
	"git",
	"statusline",
}

for _, module in ipairs(modules) do
	local ok, mod = pcall(require, "me.cfg." .. module)

	if not ok then
		local errmsg = string.format("Could not load %q: %q", module, mod)

		vim.notify(errmsg, vim.log.levels.WARN)
	else
		mod.setup(vim.tbl_get(opts, module))
	end
end

local rocks_home = vim.fn.stdpath("data") .. "/site/rocks"

-- HACK: This lets us load LuaRocks packages from wherever we want.
package.path = package.path .. ";" .. (rocks_home .. "/share/lua/5.1/?.lua")
package.path = package.path .. ";" .. (rocks_home .. "/share/lua/5.1/?/init.lua")
package.cpath = package.cpath .. ";" .. (rocks_home .. "/lib/lua/5.1/?.so")
package.cpath = package.cpath .. ";" .. (rocks_home .. "/lib/lua/5.1/?/loadall.so")

local config = require("me.api.config")

config.read()

local modprobe = {
	{ name = "log" },
	{
		name = "session",
		list = {
			{ database = true },
		},
	},
	{
		name = "editor",
		list = {
			{ options = true },
			{ treesitter = true },
			{
				diagnostics = true,
				cfilter = true,
				preview = true,
				fold = false,
				env = true,
				au = true,
				palette = true,
				files = true,
				buffers = true,
				grep = true,
				term = true,
				misc = true,
				colorizer = true,
				guides = true,
				select = true,
				quickfix = true,
				filetypes = true,
				treesitter = true,
				autocompl = true,
			},
		},
	},
	{
		name = "git",
		list = {
			{ signs = true },
		},
	},
	{
		name = "lsp",
		list = {
			{ handlers = true, langs = true },
		},
	},
	{ name = "bars" },
}

local ignored = {}
for idx, mod in ipairs(modprobe) do
	local name = mod.name
	local ok, err = pcall(require, "me.cfg." .. name)
	if not ok then
		ignored[idx] = true
		vim.notify(err, vim.log.levels.WARN)
	end
end

for idx, mod in ipairs(modprobe) do
	if ignored[idx] or not vim.tbl_islist(mod.list) then
		goto continue
	end

	for _, submod in ipairs(mod.list) do
		for name, enabled in pairs(submod) do
			if enabled then
				local modpath = string.format("me.cfg.%s.%s", mod.name, name)
				local ok, v = pcall(require, modpath)

				if not ok then
					vim.notify(
						string.format("Could not load %q: %q", modpath, v),
						vim.log.levels.WARN
					)
				end
			end
		end
	end

	::continue::
end

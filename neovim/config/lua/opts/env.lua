local logger = require("lib.logger")

-- HACK: This lets us load LuaRocks packages from wherever we want.
local rocks_home = vim.fn.stdpath("data") .. "/site/rocks"
package.path = package.path .. ";" .. (rocks_home .. "/share/lua/5.1/?.lua")
package.cpath = package.cpath .. ";" .. (rocks_home .. "/lib/lua/5.1/?.so")

local editor_exe = "nvr"

if vim.fn.executable(editor_exe) ~= 1 then
	logger.warnf("Skipping setting internal editor/pager because %q is not installed")

	return
end

vim.env.EDITOR = ("%s --remote-wait"):format(editor_exe)
vim.env.GIT_EDITOR = ("%s -cc tabnew --remote-wait +'setlocal bufhidden=wipe'"):format(editor_exe)
vim.env.GIT_PAGER = (
	"%s -cc tabnew --remote-wait +'Man! | setlocal bufhidden=wipe number relativenumber | setfiletype git' -"
):format(editor_exe)

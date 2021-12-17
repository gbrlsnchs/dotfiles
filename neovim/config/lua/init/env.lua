local logger = require("lib.logger")

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

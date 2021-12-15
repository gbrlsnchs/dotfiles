vim.env.EDITOR = "nvr --remote-wait"
vim.env.GIT_EDITOR = "nvr -cc tabnew --remote-wait +'setlocal bufhidden=wipe'"
vim.env.GIT_PAGER =
	"nvr -cc tabnew --remote-wait +'Man! | setlocal bufhidden=wipe number relativenumber | setfiletype git' -"

vim.notify = require("internal.notify")

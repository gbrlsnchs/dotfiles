local winpick = require("winpick")

local excmd = require("me.api.excmd")
local win = require("me.api.win")
local util = require("me.api.util")

local function open(orientation)
	local precmd
	local pick_win = true

	if orientation == "horizontal" then
		precmd = "split"
	elseif orientation == "vertical" then
		precmd = "vsplit"
	elseif orientation == "tab" then
		precmd = "tabnew"
		pick_win = false
	end

	local cmd = "terminal"
	if precmd then
		cmd = string.format("%s +%s", precmd, cmd)
	end

	if pick_win and not win.focus(winpick.select()) then
		return
	end

	vim.cmd(cmd)
	vim.cmd("startinsert")
end

excmd.register("Terminal", {
	TermOpen = {
		desc = "Opens a new terminal instance",
		callback = util.with_fargs(function(orientation)
			open(orientation)
		end),
		opts = {
			nargs = "?",
			complete = function()
				return { "horizontal", "vertical", "tab" }
			end,
			keymap = { keys = "<Leader>to" },
			actions = {
				["ctrl-x"] = {
					arg = "horizontal",
					keymap = { keys = "<Leader>ts" },
				},
				["ctrl-v"] = {
					arg = "vertical",
					keymap = { keys = "<Leader>tv" },
				},
				["ctrl-t"] = {
					arg = "tab",
					keymap = { keys = "<Leader>tt" },
				},
			},
		},
	},
})

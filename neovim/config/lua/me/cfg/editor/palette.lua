local excmd = require("me.api.excmd")

local api = vim.api
local default_cmd_group = "---"

local M = {}

--- Open the command palette. Fun fact: it's recursive.
function M.open(range)
	local bufnr = vim.api.nvim_get_current_buf()
	local cmdlist = excmd.list(bufnr, range and "v" or "n")

	local opts = {
		prompt = "Command palette:",
		actions = { "ctrl-x", "ctrl-v", "ctrl-t", "ctrl-s" },
		index_items = true,
		header = table.concat({ "#", "Group", "Description", "Keymap", "Command" }, "\t"),
		format_item = function(cmd)
			local parts = {
				cmd.group or default_cmd_group,
				cmd.desc,
				cmd.keymap and cmd.keymap.keys or default_cmd_group,
				cmd.name,
			}

			return table.concat(parts, "\t")
		end,
	}

	vim.ui.select(cmdlist, opts, function(cmd)
		if not cmd then
			return nil
		end

		return function(action)
			local excmd_name = cmd.name
			local actions = cmd.actions or {}
			local chosen_action = actions[action]

			if action and not chosen_action then
				M.open()
				return
			end

			chosen_action = chosen_action or {}
			if chosen_action.arg then
				local arg = chosen_action.arg

				if type(chosen_action.arg) == "function" then
					arg = arg(bufnr)
				end

				excmd_name = excmd_name .. " " .. arg
			end

			if range then
				excmd_name = string.format("%d,%d%s", range[1], range[2], excmd_name)
			end

			api.nvim_command(excmd_name)
			vim.fn.histadd("cmd", excmd_name)
		end
	end)
end

return M

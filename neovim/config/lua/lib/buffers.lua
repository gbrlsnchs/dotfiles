local winpick = require("winpick")

local fuzzy = require("lib.fuzzy")

local action_types = fuzzy.action_types
local api = vim.api

local function list()
	local buf_info = vim.fn.getbufinfo({
		buflisted = true,
		bufloaded = false,
	})

	local buffers = {}
	for _, info in ipairs(buf_info) do
		local vars = info.variables or {}

		table.insert(buffers, {
			id = info.bufnr,
			name = vars.term_title or info.name,
			lnum = math.max(info.lnum, 1),
			type = vars.terminal_job_pid and "terminal" or "text",
		})
	end

	return buffers
end

local M = {}

function M.find()
	local buffers = list()
	local opts = {
		prompt = "Buffers:",
		header = "#\tName\tLine\tType",
		format_item = function(buffer)
			local parts = {
				buffer.name,
				buffer.lnum,
				buffer.type,
			}

			return table.concat(parts, "\t")
		end,
		actions = { action_types.C_X, action_types.C_V, action_types.C_T },
	}

	vim.ui.select(buffers, opts, function(buffer)
		if not buffer then
			return
		end

		local precmd
		local pick_win = true
		local action = fuzzy.get_action()

		if action == action_types.C_X then
			precmd = "split"
		elseif action == action_types.C_V then
			precmd = "vsplit"
		elseif action == action_types.C_T then
			precmd = "tabnew"
			pick_win = false
		end

		if pick_win and not winpick.pick_window() then
			return
		end

		if precmd then
			vim.cmd(precmd)
		end

		api.nvim_win_set_buf(0, buffer.id)
		api.nvim_win_set_cursor(0, { buffer.lnum, 0 })
	end)
end

return M

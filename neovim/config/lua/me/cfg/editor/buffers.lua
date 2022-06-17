local winpick = require("winpick")

local win = require("me.api.win")

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
			name = vars.term_title or vim.fn.fnamemodify(info.name, ":~:."),
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
		header = "#\tName\tLine\tType\tCurrent",
		format_item = function(buffer)
			local parts = {
				buffer.name,
				buffer.lnum,
				buffer.type,
				(buffer.id == api.nvim_get_current_buf()) and "yes" or "no",
			}
			return table.concat(parts, "\t")
		end,
		actions = { "ctrl-x", "ctrl-v", "ctrl-t" },
	}

	vim.ui.select(buffers, opts, function(buffer)
		return function(action)
			if not buffer then
				return
			end

			local precmd
			local pick_win = true

			if action == "ctrl-x" then
				precmd = "split"
			elseif action == "ctrl-v" then
				precmd = "vsplit"
			elseif action == "ctrl-t" then
				precmd = "tabnew"
				pick_win = false
			end

			if pick_win and not win.focus(winpick.select()) then
				return
			end

			if precmd then
				vim.cmd(precmd)
			end

			api.nvim_win_set_buf(0, buffer.id)
			api.nvim_win_set_cursor(0, { buffer.lnum, 0 })
		end
	end)
end

return M

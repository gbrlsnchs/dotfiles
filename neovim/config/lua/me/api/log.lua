local win = require("me.api.win")

local api = vim.api
local log_levels = vim.log.levels

local first_write = true
local buffer
local unread_logs = 0
local unread_severity = 0

--- Notifies message with given level to the logs buffer.
--- @param msg string: The log message.
--- @param level number | nil: Log severity level.
local function notify(msg, level)
	local now = os.date("%d/%m/%Y %H:%M:%S")

	level = level or log_levels.INFO

	local index = -1
	if first_write then
		index = 0
		first_write = false
	end

	local msg_lines = {}
	for s in msg:gmatch("[^\r\n]+") do
		table.insert(msg_lines, s)
	end

	if #msg_lines == 0 then
		return
	end

	msg = msg_lines[1]

	if level == log_levels.ERROR then
		msg = "ERROR " .. msg
	elseif level == log_levels.WARN then
		msg = "WARN  " .. msg
	elseif level == log_levels.INFO then
		msg = "INFO  " .. msg
	elseif level == log_levels.DEBUG then
		msg = "DEBUG " .. msg
	elseif level == log_levels.TRACE then
		msg = "TRACE " .. msg
	end

	local lines = { now .. " " .. msg }
	local padding = string.rep(" ", now:len() + 7)

	local other_lines = vim.list_slice(msg_lines, 2)
	for _, s in ipairs(other_lines) do
		table.insert(lines, padding .. s)
	end

	api.nvim_buf_set_lines(buffer, index, -1, true, lines)

	local preview_win = win.get_preview()

	if not preview_win then
		unread_logs = unread_logs + 1
		unread_severity = math.max(unread_severity, level)

		return
	end

	local total_lines = api.nvim_buf_line_count(buffer)
	local buf_max_limit = 1000
	local diff = total_lines - buf_max_limit

	if diff > 0 then
		-- Truncate logs buffer if it surpasses the limit.
		api.nvim_buf_set_lines(buffer, 0, diff, true, {})
	else
		diff = 0
	end

	local row = math.max(total_lines - diff - (index + 1), 1)

	api.nvim_win_set_cursor(preview_win, { row, 0 })
end

local M = {}

--- Initializes the logs buffer.
function M.setup()
	buffer = api.nvim_create_buf(false, false)

	api.nvim_buf_set_option(buffer, "buftype", "nofile")
	api.nvim_buf_set_option(buffer, "filetype", "logs")
	api.nvim_buf_set_option(buffer, "modeline", false)
	api.nvim_buf_set_option(buffer, "swapfile", false)

	vim.notify = notify
end

--- Gets the buffer number from the logs buffer.
--- @return number: Buffer number of the logs buffer.
function M.get_buffer()
	return buffer
end

--- Gets total number of unread logs.
--- @return table: Table containing number of unread logs and greatest severity.
function M.get_unread()
	return { count = unread_logs, severity = unread_severity }
end

--- Marks logs as read.
function M.reset_unread()
	unread_logs = 0
	unread_severity = 0
end

function M.preview()
	-- HACK: This forces the preview to open when current window doesn't have a file name.
	local tmp = vim.fn.tempname()
	vim.cmd.pedit(tmp)

	local preview_win = win.get_preview()
	local logs_buffer = M.get_buffer()

	api.nvim_win_set_buf(preview_win, logs_buffer)
	api.nvim_win_set_option(preview_win, "number", false)
	api.nvim_win_set_option(preview_win, "relativenumber", false)
	api.nvim_win_set_option(preview_win, "list", false)
	api.nvim_win_call(preview_win, function()
		vim.cmd("wincmd J | normal G")
	end)

	vim.cmd.bdelete(tmp)

	M.reset_unread()
end


return M

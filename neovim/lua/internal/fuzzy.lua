local buffers = require("internal.buffers")
local files = require("internal.files")
local Logger = require("internal.logger")

local FuzzyCommand = require("internal.fuzzy.command")
local util = require("internal.fuzzy.util")

-- ideas:
-- fd --print0 | fzf --print0
-- git log (with checkout and preview): git log --oneline | fzf --preview 'git show --name-only {1}'
-- fd file:line
-- oldfiles

local function convert_to_relative(abs_path)
	return vim.fn.fnamemodify(abs_path, ":~:.")
end

local function make_bufname(buf)
	-- Make filename relative.
	local fname = convert_to_relative(buf.name)

	return ("%s:%d (%d)"):format(fname, buf.line, buf.id)
end

local M = {}

function M.cword_file_line()
	local query = vim.fn.expand("<cWORD>")
	local partial_fname, line = query:match("(.+):(%d+)")

	line = line or 1

	if not partial_fname then
		Logger:new("file:line"):warn("Invalid filename under cursor")
		return
	end

	local function goto_line()
		vim.api.nvim_win_set_cursor(0, { line, 0 })
	end

	FuzzyCommand
		:new({
			prompt = ("%s:%s>"):format(partial_fname, line),
			default_action = files.open_in_win,
			actions = {
				[FuzzyCommand.action_types.C_X] = function(filename)
					files.open(filename, files.directions.HORIZONTAL)
				end,
				[FuzzyCommand.action_types.C_V] = function(filename)
					files.open(filename, files.directions.VERTICAL)
				end,
				[FuzzyCommand.action_types.C_T] = function(filename)
					files.open(filename, files.directions.TAB)
				end,
			},
		})
		:run(("fd -0 %s | xargs -0 ls -t1"):format(partial_fname), function(result)
			result.action(result.item)
			goto_line()
		end)
end

function M.oldfiles()
	local cwd = vim.loop.cwd()
	local oldfiles = vim.tbl_filter(function(fname)
		return vim.fn.matchstrpos(fname, cwd)[2] ~= -1 and vim.fn.filereadable(fname) ~= 0
	end, vim.v.oldfiles)
	local items = vim.tbl_map(function(fname)
		return convert_to_relative(fname)
	end, oldfiles)

	FuzzyCommand
		:new({
			prompt = "Oldfiles",
			default_action = files.open_in_win,
			actions = {
				[FuzzyCommand.action_types.C_X] = function(filename)
					files.open(filename, files.directions.HORIZONTAL)
				end,
				[FuzzyCommand.action_types.C_V] = function(filename)
					files.open(filename, files.directions.VERTICAL)
				end,
				[FuzzyCommand.action_types.C_T] = function(filename)
					files.open(filename, files.directions.TAB)
				end,
			},
		})
		:run(items, function(result)
			result.action(result.item)
		end)
end

function M.buffers()
	local buf_list = buffers.list()
	local bufs = { buf_list.current_buf, unpack(buf_list.text_buffers) }
	local items = {}

	for _, buf in ipairs(bufs) do
		table.insert(items, make_bufname(buf))
	end

	FuzzyCommand
		:new({
			prompt = "Buffers>",
			show_header = true,
			default_action = util.buffer_wrap(buffers.open_in_win),
		})
		:run(items, function(result)
			local _, line, bufnr = result.item:match("^(.+):(%d+)%s%((%d+)%)$")
			result.action(tonumber(bufnr), tonumber(line))
		end)
end

function M.git_diff()
	FuzzyCommand
		:new({
			prompt = "Dirty>",
			default_action = files.open,
			actions = {
				[FuzzyCommand.action_types.C_X] = function(filename)
					files.open(filename, files.directions.HORIZONTAL)
				end,
				[FuzzyCommand.action_types.C_V] = function(filename)
					files.open(filename, files.directions.VERTICAL)
				end,
				[FuzzyCommand.action_types.C_T] = function(filename)
					files.open(filename, files.directions.TAB)
				end,
			},
		})
		:run("git --no-pager diff --name-only", function(result)
			result.action(result.item)
		end)
end

function M.terminals()
	local buf_list = buffers.list()
	local bufs = buf_list.term_buffers
	local items = {}
	local line_list = {}

	for _, buf in ipairs(bufs) do
		local id = buf.id
		line_list[tostring(id)] = buf.line_count

		table.insert(items, ("[%s] %s (%d)"):format(buf.title, buf.name, id))
	end

	FuzzyCommand
		:new({
			prompt = "Terminals>",
		})
		:run(items, function(result)
			local bufnr = result.item:match("%((%d+)%)$")
			result.action(tonumber(bufnr), tonumber(line_list[bufnr]))
		end)
end

return M

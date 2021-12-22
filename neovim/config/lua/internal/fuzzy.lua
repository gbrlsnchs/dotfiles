local buffers = require("internal.buffers")
local files = require("internal.files")
local command = require("lib.command")
local logger = require("lib.logger")

local FuzzyCommand = require("internal.fuzzy.command")

-- ideas:
-- git log (with checkout and preview): git log --oneline | fzf --preview 'git show --name-only {1}'

local function convert_to_relative(abs_path)
	return vim.fn.fnamemodify(abs_path, ":~:.")
end

local function make_bufname(buf)
	-- Make filename relative.
	local fname = convert_to_relative(buf.name)

	return ("%s:%d (%d)"):format(fname, buf.line, buf.id)
end

local M = {}

function M.find(opts)
	opts = vim.tbl_deep_extend("keep", opts or {}, {
		search_type = nil,
		prompt = "Files",
		use_file_cwd = false,
	})

	local cmd = ("%s -0"):format(vim.env.FZF_DEFAULT_COMMAND)
	local prompt = opts.prompt

	if opts.search_type then
		cmd = cmd:gsub("file", opts.search_type)
	elseif opts.use_file_cwd then
		local file_cwd = vim.fn.expand("%:h")
		if vim.fn.isdirectory(file_cwd) == 1 then
			cmd = ("%s . %s"):format(cmd, file_cwd)
			prompt = ("Files (%s)"):format(file_cwd)
		else
			logger:warn("Current buffer has no valid directory, falling back to cwd")
		end
	end

	FuzzyCommand
		:new({
			prompt = prompt,
			default_action = files.open,
			use_null_character = true,
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
		:run(cmd, function(result)
			result.action(result.item)
		end)
end

function M.cword_file_line()
	local query = vim.fn.expand("<cWORD>")
	local partial_fname, line, col = query:match("(.+):(%d+):(%d+)")

	local cmd = "fd -0 --full-path '%s' | xargs -0 ls -t1"
	local prompt = ("%s:%s:%s"):format(partial_fname, line, col)

	if not partial_fname then
		partial_fname, line = query:match("(.+):(%d+)")
		prompt = ("%s:%s"):format(partial_fname, line)
	end

	if not partial_fname then
		-- Let's do a best-efforts search then.
		partial_fname = query
		cmd = "fd --full-path '%s'"
		prompt = ("cWORD (%s)"):format(query)
	end

	line = line or 1
	col = (col or 1) - 1 -- it's zero-indexed

	FuzzyCommand
		:new({
			prompt = prompt,
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
		:run(cmd:format(partial_fname), function(result)
			result.action(result.item)
			vim.api.nvim_win_set_cursor(0, { tonumber(line), tonumber(col) })
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
			prompt = "Buffers",
			show_header = true,
		})
		:run(items, function(result)
			local _, line, bufnr = result.item:match("^(.+):(%d+)%s%((%d+)%)$")
			result.action(tonumber(bufnr), tonumber(line))
		end)
end

function M.git_diff()
	FuzzyCommand
		:new({
			prompt = "Changes",
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
		:run("git ls-files --modified --others --exclude-standard", function(result)
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

		table.insert(items, ("%s (%d)"):format(buf.name, id))
	end

	FuzzyCommand
		:new({
			prompt = "Terminals",
		})
		:run(items, function(result)
			local bufnr = result.item:match("%((%d+)%)$")
			result.action(tonumber(bufnr), tonumber(line_list[bufnr]))
		end)
end

function M.commands()
	local bufnr = vim.api.nvim_get_current_buf()
	local keymaps = command.list(bufnr)

	FuzzyCommand
		:new({
			prompt = "Command Palette",
			default_action = function(desc)
				command.run(bufnr, desc)
			end,
			actions = {
				[FuzzyCommand.action_types.C_X] = function(desc)
					command.run(bufnr, desc, command.tags.horizontal)
				end,
				[FuzzyCommand.action_types.C_V] = function(desc)
					command.run(bufnr, desc, command.tags.vertical)
				end,
				[FuzzyCommand.action_types.C_T] = function(desc)
					command.run(bufnr, desc, command.tags.tab)
				end,
			},
		})
		:run(keymaps, function(result)
			result.action(result.item)
		end)
end

return M

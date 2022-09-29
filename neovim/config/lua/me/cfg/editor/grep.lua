local exec = require("me.api.exec")
local excmd = require("me.api.excmd")
local util = require("me.api.util")

--- Parses input from <f-args>, filtering empty strings.
--- @param query table: List of strings that compose a query.
--- @return string | nil: Whitespace-separated query.
local function parse_fargs(query)
	-- TODO: Optimize?
	if type(query) == "string" then
		query = { query }
	end

	query = vim.tbl_filter(function(s)
		return s:len() > 0 -- filter out empty strings
	end, query or {})

	if vim.tbl_isempty(query) then
		return nil
	end

	return table.concat(query, " ")
end

--- Prompts for a query.
--- @param msg string: Message displayed in the prompt.
local function prompt(msg, callback)
	vim.ui.input({ prompt = string.format("%s: ", msg) }, function(query)
		if not query or query:len() == 0 then
			return
		end
		callback(query)
	end)
end

--- Shows the result of a query when exit code is appropriate for so.
local function show_result(query)
	query = table.concat(query, " ")

	return function(result, exit_code)
		if exit_code == 1 or #result == 0 then
			vim.notify(string.format("No results from the query %q", query))
			return
		end

		if exit_code == 2 then
			vim.notify(
				string.format("The query %q was only partially successful", query),
				vim.log.levels.WARN
			)
		end

		vim.fn.setqflist({}, "r", {
			lines = result,
		})
		vim.cmd("copen")
	end
end

--- Execute a search.
--- @param cmd string: Command to be executed.
--- @param args table: List of command arguments.
local function search(cmd, args, query, opts)
	opts = util.tbl_merge(opts, { global = true })
	query = parse_fargs(query)

	local base_dir = "."
	local function callback(query_args)
		local cmd_args = vim.list_extend(args, { query_args, base_dir })

		exec.cmd(cmd, cmd_args, show_result(vim.list_extend({ cmd }, cmd_args)))
	end

	if not query then
		local prompt_msg
		if opts.global then
			prompt_msg = "Search in the whole project"
		else
			base_dir = vim.fn.expand("%:h")
			prompt_msg = string.format("Search in %q", base_dir)
		end

		prompt_msg = string.format("[%s] %s", cmd, prompt_msg)
		prompt(prompt_msg, callback)
	else
		callback(query)
	end
end

--- Search using ripgrep or Git and fills the quickfix list with results.
local function grep(query, opts)
	search("rg", { "--vimgrep", "--no-heading", "--smart-case" }, query, opts)
end

local function git_grep(query, opts)
	search("git", { "grep", "--column", "-n" }, query, opts)
end

excmd.register("Grep", {
	Grep = {
		desc = "Search text in files",
		callback = util.with_fargs(function(query)
			grep(query)
		end),
		opts = {
			nargs = "*",
			keymap = { keys = "<Leader>gf" },
		},
	},
	GrepCd = {
		desc = "Search text in files from current directory",
		callback = util.with_fargs(function(query)
			grep(query, { global = false })
		end),
		opts = {
			nargs = "*",
			keymap = { keys = "<Leader>gF" },
		},
	},
	GitGrep = {
		desc = "Search text in files using Git",
		callback = util.with_fargs(function(query)
			git_grep(query)
		end),
		opts = {
			nargs = "*",
			keymap = { keys = "<Leader>gg" },
		},
	},
	GitGrepCd = {
		desc = "Search text in files for current directory using Git",
		callback = util.with_fargs(function(query)
			git_grep(query, { global = false })
		end),
		opts = {
			nargs = "*",
			keymap = { keys = "<Leader>gG" },
		},
	},
})

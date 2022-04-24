local Job = require("plenary.job")

local logger = require("lib.logger")

local function prompt(scope, ...)
	local query = vim.tbl_filter(function(word)
		return #word > 0
	end, { ... })

	if #query > 0 then
		return table.concat(query, " ")
	end

	local word = vim.fn.input(string.format("(%s) Search for: ", scope))

	if not word or word:len() == 0 then
		return
	end

	return word
end

local function run(cmd, ...)
	local args = { ... }

	Job
		:new({
			command = cmd,
			args = args,
			interactive = false,
			on_exit = vim.schedule_wrap(function(job, exit_code)
				local result = job:result()

				if exit_code == 1 or #result == 0 then
					logger.infof("No results found for query %q", args[#args])
					return
				end

				if exit_code == 2 then
					logger.warn("Search was partially successful (exit code 2)")
				end

				vim.fn.setqflist({}, "r", {
					lines = result,
				})
				vim.cmd("copen")
			end),
		})
		:start()
end

local M = {}

function M.search(...)
	local query = prompt("global", ...)
	if not query then
		logger.info("Search aborted")
		return
	end

	run("rg", "--vimgrep", "--no-heading", "--smart-case", query)
end

function M.search_in_dir(...)
	local file = vim.fn.expand("%")
	if vim.fn.isdirectory(file) == 0 then
		file = vim.fn.expand("%:h")
	end

	local query = prompt("directory", ...)
	if not query then
		logger.info("Search aborted!")
		return
	end

	run("rg", "--vimgrep", "--no-heading", "--smart-case", query, file)
end

function M.git_search(...)
	local query = prompt("git", ...)
	if not query then
		logger.info("Search with Git aborted!")
		return
	end

	run("git", "grep", "--column", "-n", query)
end

return M

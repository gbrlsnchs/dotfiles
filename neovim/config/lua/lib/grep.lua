local Job = require("plenary.job")

local logger = require("lib.logger")

local function prompt(...)
	local query = { ... }
	if #query > 0 then
		return table.concat(query, " ")
	end

	local word = vim.fn.input("Search for: ")

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

				if exit_code ~= 0 or #result == 0 then
					logger.infof("No results found for query %q", args[#args])
					return
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
	local query = prompt(...)
	if not query then
		logger.info("Search aborted!")
		return
	end

	run("rg", "--vimgrep", "--no-heading", "--smart-case", query)
end

function M.git_search(...)
	local query = prompt(...)
	if not query then
		logger.info("Search with Git aborted!")
		return
	end

	run("git", "grep", "--column", "-n", query)
end

return M

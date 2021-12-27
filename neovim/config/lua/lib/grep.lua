local Job = require("plenary.job")

local logger = require("lib.logger")

local function prompt()
	local word = vim.fn.input("Search for: ")

	if not word or word:len() == 0 then
		return
	end

	return word
end

local M = {}

function M.search(query)
	query = query or prompt()
	if not query then
		logger.info("Search aborted!")
	end

	Job
		:new({
			command = "rg",
			args = { "--vimgrep", "--no-heading", "--smart-case", query },
			interactive = false,
			on_exit = vim.schedule_wrap(function(job, exit_code)
				local result = job:result()

				if exit_code ~= 0 or #result == 0 then
					logger.infof("No results found for query %q", query)
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

return M

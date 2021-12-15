local Job = require("plenary.job")

local Logger = require("internal.logger")
local Prompt = require("internal.prompt")

local M = {}

function M:new(prefix, cmd, args)
	local tool = {
		logger = Logger:new(prefix),
		prompt = Prompt:new(prefix),
		cmd = cmd,
		args = args,
	}
	self.__index = self

	return setmetatable(tool, self)
end

function M:prompt_for_query(query)
	query = query or self.prompt:input("Search for: ")

	self.query = query

	return self
end

function M:run()
	vim.cmd("mode")

	if #self.query == 0 then
		self.logger:warn("Search aborted")
		return
	end

	table.insert(self.args, self.query)
	Job
		:new({
			command = self.cmd,
			args = self.args,
			cwd = vim.fn.getcwd(),
			interactive = false,
			on_exit = vim.schedule_wrap(function(job, exit_code)
				local result = job:result()

				if exit_code ~= 0 or #result == 0 then
					self.logger:warn('No results found for "%s"', self.query)
					return
				end

				vim.fn.setqflist({}, "r", {
					lines = result,
				})
				vim.cmd("botright copen")
			end),
		})
		:start()
end

return M

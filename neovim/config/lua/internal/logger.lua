local tables = require("internal.tables")

local levels = tables.readonly({
	TRACE = vim.lsp.log_levels.TRACE,
	DEBUG = vim.lsp.log_levels.DEBUG,
	INFO = vim.lsp.log_levels.INFO,
	WARN = vim.lsp.log_levels.WARN,
	ERROR = vim.lsp.log_levels.ERROR,
})

local Logger = {}

function Logger:new(prefix)
	prefix = vim.tbl_filter(function(v)
		return type(v) == "string"
	end, {
		self.prefix,
		prefix,
	})
	local logger = {
		prefix = table.concat(prefix, " / "),
	}
	self.__index = self

	return setmetatable(logger, self)
end

function Logger:parse_msg(msg, ...)
	msg = msg:format(...)

	return ("(%s) %s"):format(self.prefix, msg)
end

function Logger:error(msg, ...)
	vim.notify(self:parse_msg(msg, ...), levels.ERROR)
end

function Logger:warn(msg, ...)
	vim.notify(self:parse_msg(msg, ...), levels.WARN)
end

function Logger:info(msg, ...)
	vim.notify(self:parse_msg(msg, ...), levels.INFO)
end

function Logger:debug(msg, ...)
	vim.notify(self:parse_msg(msg, ...), levels.DEBUG)
end

function Logger:trace(msg, ...)
	vim.notify(self:parse_msg(msg, ...), levels.TRACE)
end

return Logger:new("Neovim")

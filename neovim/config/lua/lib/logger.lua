-- TODO: Document functions.
local M = {}

local levels = {
	TRACE = vim.log.levels.TRACE,
	DEBUG = vim.log.levels.DEBUG,
	INFO = vim.log.levels.INFO,
	WARN = vim.log.levels.WARN,
	ERROR = vim.log.levels.ERROR,
}

M.levels = levels

function M.error(msg)
	vim.notify(msg, levels.ERROR)
end
function M.errorf(msg, ...)
	vim.notify(msg:format(...), levels.ERROR)
end

function M.warn(msg)
	vim.notify(msg, levels.WARN)
end
function M.warnf(msg, ...)
	vim.notify(msg:format(...), levels.WARN)
end

function M.info(msg)
	vim.notify(msg, levels.INFO)
end
function M.infof(msg, ...)
	vim.notify(msg:format(...), levels.INFO)
end

function M.debug(msg)
	vim.notify(msg, levels.DEBUG)
end
function M.debugf(msg, ...)
	vim.notify(msg:format(...), levels.DEBUG)
end

function M.trace(msg)
	vim.notify(msg, levels.TRACE)
end
function M.tracef(msg, ...)
	vim.notify(msg:format(...), levels.TRACE)
end

return M

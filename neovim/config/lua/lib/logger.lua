-- TODO: Document functions.
local M = {}

local levels = {
	ERROR = 0,
	WARN = 1,
	INFO = 2,
	DEBUG = 3,
	TRACE = 4,
}

M.levels = levels

function M.error(msg)
	M.errorf(msg)
end
function M.errorf(msg, ...)
	vim.notify(("[ERROR] " .. msg):format(...), levels.ERROR)
end

function M.warn(msg)
	M.warnf(msg)
end
function M.warnf(msg, ...)
	vim.notify(("[WARN] " .. msg):format(...), levels.WARN)
end

function M.info(msg)
	M.infof(msg)
end
function M.infof(msg, ...)
	vim.notify(("[INFO] " .. msg):format(...), levels.INFO)
end

function M.debug(msg)
	M.debugf(msg)
end
function M.debugf(msg, ...)
	vim.notify(("[DEBUG] " .. msg):format(...), levels.DEBUG)
end

function M.trace(msg)
	M.tracef(msg)
end
function M.tracef(msg, ...)
	vim.notify(("[TRACE] " .. msg):format(...), levels.TRACE)
end

return M

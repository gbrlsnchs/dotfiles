local sqlite = require("lsqlite3")

local db_uri = vim.fn.stdpath("data") .. "/nvim.sqlite3"
local db = sqlite.open(db_uri)

local M = {}

-- Executes multiple queries. Doesn't return anything other than a possible error message. Each
-- query must end with a semicolon.
function M.exec(...)
	local querystr = table.concat({ ... }, "")

	if db:exec(querystr) == sqlite.OK then
		return nil
	end
	return db:errmsg()
end

-- Executes a prepared statement. Returns rows and a possible error message.
function M.exec_stmt(query, ...)
	local stmt = db:prepare(query)
	local first = ...
	local args = first
	if type(first) ~= "table" then
		args = { ... }
	end

	if stmt:bind_names(args) == sqlite.ERROR then
		return nil, db:errmsg()
	end

	local rows = {}
	for row in stmt:nrows() do
		table.insert(rows, row)
	end
	if stmt:finalize() == sqlite.OK then
		return { rows = rows, count = db:changes() }, nil
	end

	return nil, db:errmsg()
end

return M

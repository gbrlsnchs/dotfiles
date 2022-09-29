local sqlite = require("lsqlite3")

local db = sqlite.open(vim.fn.stdpath("state") .. "/neovim.sqlite3")

local M = {}

--- Executes one or more queries. This is useful when return values for the queries are not needed.
--- @param ... string: List of queries to be executed.
--- @return string|nil: The error message if there's an error with any of the queries.
function M.exec(...)
	local q = table.concat({ ... }, "")

	if db:exec(q) == sqlite.OK then
		return nil
	end

	return db:errmsg()
end

--- Executes a query using a prepared statement.
--- @param query string: The query to be executed.
--- @param ... any: Variables to be used in the query, if any.
--- @return table | nil: The result of the query containing rows and count (of affected rows).
--- @return string | nil: The error message if there are any errors with the statement.
function M.exec_stmt(query, ...)
	local stmt = db:prepare(query)
	local vars = { ... }

	if stmt:bind_names(vars) == sqlite.ERROR then
		return nil, db:errmsg()
	end

	local rows = {}
	for row in stmt:nrows() do
		table.insert(rows, row)
	end

	if stmt:finalize() == sqlite.ERROR then
		return nil, db:errmsg()
	end

	return { rows = rows, count = db:changes() }, nil
end

--- Closes the database connection.
function M.close()
	pcall(db.close, db)
end

return M

local db = require("lib.db")
local logger = require("lib.logger")

local project_id
local session_started = false

local M = {}

local projects_table = [[
CREATE TABLE IF NOT EXISTS projects (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	path TEXT UNIQUE NOT NULL
);
]]

local oldfiles_table = [[
CREATE TABLE IF NOT EXISTS oldfiles (
	project_id INTEGER NOT NULL,
	path TEXT NOT NULL,
	hits INTEGER DEFAULT 0,
	last_hit DATETIME DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (project_id, path),
	FOREIGN KEY (project_id) REFERENCES projects (id)
);
]]

function M.init()
	local err

	err = db.exec(projects_table, oldfiles_table)
	if err then
		logger.errorf("Could not create base tables: %q", err)
		return false
	end

	_, err = db.exec_stmt("INSERT OR IGNORE INTO projects (path) VALUES (?)", vim.loop.cwd())
	if err then
		logger.errorf("Could not insert project: %q", err)
		return false
	end

	session_started = true

	return true
end

function M.get_project_id()
	if not session_started then
		return
	end

	if not project_id then
		local result, err = db.exec_stmt("SELECT id FROM projects WHERE path = ?", vim.loop.cwd())
		if err then
			logger.errorf("Could not retrieve project ID: %q", err)
			return
		end

		project_id = result.rows[1].id
	end

	return project_id
end

function M.close()
	logger.debug("Closing SQLite database connection")

	db:close()
end

return M

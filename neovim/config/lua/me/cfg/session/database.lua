local db = require("me.api.db")
local config = require("me.api.config")

local api = vim.api
local augroup = api.nvim_create_augroup("session", {})

local projects_table = [[
CREATE TABLE IF NOT EXISTS projects (
	name TEXT PRIMARY KEY
);
]]

local oldfiles_table = [[
CREATE TABLE IF NOT EXISTS oldfiles (
	project_name TEXT NOT NULL REFERENCES projects (name),
	path TEXT NOT NULL,
	hits INTEGER DEFAULT 0,
	last_hit DATETIME DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (project_name, path)
);
]]

local err

err = db.exec(projects_table, oldfiles_table)
if err then
	vim.notify(err, vim.log.levels.ERROR)
	return
end

local project_name = config.get("session", "project_name")

if not project_name then
	vim.notify("No project name set, skipping project registration", vim.log.levels.WARN)
	return
end

_, err = db.exec_stmt("INSERT OR IGNORE INTO projects VALUES (?)", project_name)
if err then
	vim.notify(err, vim.log.levels.ERROR)
end

api.nvim_create_autocmd("VimLeavePre", {
	group = augroup,
	callback = function()
		db:close()
	end,
})

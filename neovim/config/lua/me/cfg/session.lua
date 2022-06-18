local log = require("me.api.log")
local db = require("me.api.db")
local session = require("me.api.session")
local util = require("me.api.util")

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

local M = {}

function M.setup(opts)
	opts = util.tbl_merge(opts, {
		project_name = nil,
	})

	log.init()

	local err

	err = db.exec(projects_table, oldfiles_table)
	if err then
		vim.notify(err, vim.log.levels.ERROR)
		return
	end

	local project_name = opts.project_name

	if not project_name then
		vim.notify("No project name set, skipping project registration", vim.log.levels.WARN)
		return
	end

	session.update({ project_name = project_name })

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
end

return M

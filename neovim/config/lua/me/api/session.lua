local util = require("me.api.util")

local session_obj = {}

local M = {}

--- Updates the session object.
--- @param session table: Session object to be merged to existing session data.
function M.update(session)
	session_obj = util.tbl_merge(session, session_obj)
end

--- Retrieves an option from the session object.
--- @param key string: Key of the option to be retrieved.
--- @return any: The requested property from the session object.
function M.get_option(key)
	return session_obj[key]
end

return M

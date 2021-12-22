local M = {}

function M.create_factory(defaults)
	return function(keys, tag)
		local keymap
		if keys then
			keymap = { keys = keys }
		end

		return vim.tbl_deep_extend("force", defaults, {
			keymap = keymap or {},
			tag = tag,
		})
	end
end

return M

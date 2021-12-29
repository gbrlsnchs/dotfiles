local action_types = {
	C_X = "ctrl-x",
	C_V = "ctrl-v",
	C_T = "ctrl-t",
}

local actions = {
	[action_types.C_X] = true,
	[action_types.C_V] = true,
	[action_types.C_T] = true,
}

local current_action
local cancel_handler = nil

local M = {}

M.action_types = action_types

function M.prepare_cancel(on_choice)
	cancel_handler = function()
		cancel_handler = nil

		if vim.v.event.status ~= 0 then
			on_choice(nil, nil)
		end
	end
end

function M.cancel()
	cancel_handler()
end

function M.get_action()
	return current_action
end

function M.set_action(choice)
	-- This handles cancelations and default actions.
	if not choice or choice == "" then
		return nil
	end

	-- This handles special actions like, for example, Ctrl-V.
	if actions[choice] then
		current_action = choice
		return nil
	end

	return function()
		current_action = nil
	end
end

return M

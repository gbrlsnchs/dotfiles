local fzf = require("fzf")

local tables = require("internal.tables")
local buffers = require("internal.buffers")

local util = require("internal.fuzzy.util")

local M = {}

M.action_types = tables.readonly({
	C_X = "ctrl-x",
	C_V = "ctrl-v",
	C_T = "ctrl-t",
})

function M:new(opts)
	opts = opts or {}
	opts = vim.tbl_deep_extend("keep", opts, {
		show_header = false,
		prompt = ">",
		default_action = util.buffer_wrap(buffers.open),
		actions = {
			[M.action_types.C_X] = util.buffer_wrap(buffers.open_horizontal),
			[M.action_types.C_V] = util.buffer_wrap(buffers.open_vertical),
			[M.action_types.C_T] = util.buffer_wrap(buffers.open_tab),
			-- TODO: New actions:
			-- * Delete buffer
			-- * Kill terminal
			-- * Select a window
		},
	})

	return setmetatable(opts, { __index = self })
end

function M:_build_args()
	local args = {}

	if self.show_header then
		table.insert(args, "--header-lines=1")
	end

	table.insert(args, ("--prompt='%s '"):format(self.prompt))

	local expects = {}
	for keystroke, _ in pairs(self.actions) do
		table.insert(expects, keystroke)
	end

	if #expects > 0 then
		local expect_value = table.concat(expects, ",")
		table.insert(args, ("--expect='%s'"):format(expect_value))
	end

	args = table.concat(args, " ")
	return args
end

function M:run(input, f)
	vim.schedule(coroutine.wrap(function()
		local result = fzf.fzf(input, self:_build_args())
		if not result then
			return
		end

		local item = result[2]
		if not item then
			return
		end

		local action = self.actions[result[1]] or self.default_action

		f({
			item = item,
			action = action,
		})
	end))
end

return M
local util = require("me.api.util")

local api = vim.api

--- Splits a string into columns based on a tab separator.
--- @return table: A list containing each column size.
local function parse_column_widths(str)
	local matches = {}

	local idx = 0
	while true do
		local pivot = idx + 1
		idx = str:find("\t", pivot)

		if not idx then
			-- Return what's left in the string from the pivot until the end.
			table.insert(matches, str:sub(pivot):len())

			break
		end

		table.insert(matches, str:sub(pivot, idx - 1):len())
	end

	return matches
end

--- Formats a table using elastic tabstops.
--- @return table|nil
local function format_table(items, opts)
	local formatted_lines
	local max_column_sizes
	local narrowest_column_sizes
	local tab_cache
	local idx_offset

	-- FZF handles strings as external commands (for example the fd command).
	-- Therefore it doesn't need any parsing and we can safely skip it.
	if type(items) == "string" or not opts.index_items then
		return
	end

	if opts.kind == "codeaction" then
		opts.header = "#\tAction"
	end

	if opts.header then
		items = vim.list_extend({ opts.header }, items)
	end

	formatted_lines = {}
	max_column_sizes = {}
	narrowest_column_sizes = {}
	tab_cache = {}
	idx_offset = 0 -- used to compensate prompts with a header line

	for idx, item in ipairs(items) do
		local label

		if opts.format_item then
			if idx == 1 and opts.header then
				-- TODO: Receive a list of column names, format them automagically.
				label = opts.header
				idx_offset = 1
				-- Skip indexing and formatting, since header is already formatted.
				goto elastic_tabstops
			end

			item = opts.format_item(item)
		end

		label = ("%d\t%s"):format(idx - idx_offset, item)

		::elastic_tabstops::
		-- My tabwriter algorithm:
		-- 1. Add a label, which is a tab-separated string of columns, to our soon-to-be-formatted
		-- list. Headers don't contain indexes, but other items do (this is how we identify the
		-- items later).
		table.insert(formatted_lines, label)

		-- 2. Get the size of each item's column.
		local widths = parse_column_widths(label)
		-- 3. For each column, check whether they're the narrowest/widest in the table.
		for i, w in ipairs(widths) do
			if not max_column_sizes[i] then
				narrowest_column_sizes[i] = w
				max_column_sizes[i] = w
				goto continue
			end

			if w > max_column_sizes[i] then
				max_column_sizes[i] = w
			end

			if w < narrowest_column_sizes[i] then
				narrowest_column_sizes[i] = w
			end

			::continue::
		end
		-- 4. We don't want to calculate each item's column widths again, so let's cache them
		-- for further usage, where we can map 'items' and 'tab_cache' 1:1.
		table.insert(tab_cache, widths)
	end

	-- 5. For each label to be formatted, we will iterate over its columns in order to swap tabs for
	-- a padding, which depends on the size of the widest column and the word in the column itself.
	for idx, line in ipairs(formatted_lines) do
		local widths = tab_cache[idx]
		local column_idx = 1

		formatted_lines[idx] = line:gsub("\t", function()
			local max_column_size = max_column_sizes[column_idx] + 1
			local times = max_column_size - widths[column_idx]

			column_idx = column_idx + 1

			return (" "):rep(times)
		end)
	end

	return formatted_lines
end

--- Builds the appropriate command-line arguments for the 'fzf' command.
--- @param opts table: Options that are going to be translated to command-line arguments.
local function make_args(opts)
	local args = {}

	if opts.header then
		table.insert(args, "--header-lines=1")
	end

	table.insert(args, ("--prompt='%s '"):format(opts.prompt))

	if opts.use_null_character then
		table.insert(args, "--read0")
	end

	local expects = {}
	if opts.actions then
		for _, action in ipairs(opts.actions) do
			table.insert(expects, action)
		end
	end

	if #expects > 0 then
		local expect_value = table.concat(expects, ",")
		table.insert(args, ("--expect='%s'"):format(expect_value))
	end

	if not opts.sort then
		table.insert(args, "--no-sort")
	end

	return args
end

--- Set of labels for FZF actions.
vim.ui.select = function(items, opts, on_choice)
	opts = util.tbl_merge(opts, {
		args = {},
		actions = {},
		index_items = true,
		sort = true,
	})

	local allowed_actions = {}
	for _, action in ipairs(opts.actions) do
		allowed_actions[action] = true
	end

	local formatted_lines = format_table(items, opts)

	local args = vim.list_extend(make_args(opts), { "--layout=reverse" })
	local source = formatted_lines or items or {}

	local action
	local callback = function(item)
		if not item or item == "" then
			return
		end

		if allowed_actions[item] then
			action = item
			return
		end

		local idx
		if formatted_lines and #formatted_lines > 0 then
			idx = tonumber(item:match("^%d+"))
			item = items[idx]
		end

		-- HACK: Theoretically, 'on_choice' shouldn't return any values, and it should also apply
		-- whatever side-effect it's supposed to, but... this way we can defer the action. Does it
		-- work? I don't know yet!
		local action_handler = on_choice(item, idx)
		if action_handler and type(action_handler) == "function" then
			action_handler(action)
		end
	end

	vim.fn["fzf#run"]({
		source = source,
		sink = callback,
		options = table.concat(args, " "),
		window = {
			width = 0.8,
			height = 0.5,
			yoffset = 0.1,
		},
	})

	local prompt_bufnr = api.nvim_get_current_buf()
	local group = api.nvim_create_augroup("ui-select-prompt", {})

	api.nvim_create_autocmd("TermClose", {
		group = group,
		once = true,
		buffer = prompt_bufnr,
		-- NOTE: This is called _before_ the FZF callback is called, so don't try to handle stuff
		-- here, unless it's a cancelation. ;-)
		callback = function()
			local is_cancel = vim.v.event.status ~= 0

			if is_cancel then
				on_choice(nil, nil)
			end

			return true
		end,
	})
end

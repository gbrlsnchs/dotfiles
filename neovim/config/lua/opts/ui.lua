local fuzzy = require("lib.fuzzy")
local logger = require("lib.logger")

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
	for _, action in ipairs(opts.actions) do
		table.insert(expects, action)
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

local function parse_tabs(str)
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

vim.ui.select = function(items, opts, on_choice)
	fuzzy.prepare_cancel(on_choice)

	opts = vim.tbl_extend("keep", opts, {
		args = {},
		actions = {},
		index_items = true,
		sort = true,
	})

	local formatted_lines
	local max_column_sizes
	local narrowest_column_sizes
	local tab_cache
	local idx_offset

	-- FZF handles strings as external commands (for example the fd command).
	-- Therefore it doesn't need any parsing and we can safely skip it.
	if type(items) == "string" or not opts.index_items then
		goto command
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
	idx_offset = 0

	for idx, item in ipairs(items) do
		local label

		if opts.format_item then
			if idx == 1 and opts.header then
				label = opts.header
				idx_offset = 1
				goto elastic_tabstops
			end

			item = opts.format_item(item)
		end

		label = ("%d\t%s"):format(idx - idx_offset, item)

		::elastic_tabstops::
		table.insert(formatted_lines, label)

		-- Tabwriter functionality.
		local widths = parse_tabs(label)
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
		table.insert(tab_cache, widths)
	end

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

	::command::
	logger.debugf("Called vim.ui.select with the following options: %s", vim.inspect(opts))

	local callback = function(item)
		-- This handles responses from FZF about actions.
		local reset_action = fuzzy.set_action(item)
		if not reset_action then
			return
		end

		local idx
		if formatted_lines and #formatted_lines > 0 then
			idx = tonumber(item:match("^%d+"))
			item = items[idx + idx_offset]
		end

		on_choice(item, idx)
		reset_action()
	end

	local args = vim.list_extend(make_args(opts), { "--layout=reverse" })
	local source = formatted_lines or items or {}

	vim.fn["fzf#run"]({
		source = source,
		sink = callback,
		options = table.concat(args, " "),
		window = {
			width = 0.4,
			height = 0.5,
			yoffset = 0.1,
		},
	})

	vim.cmd('autocmd TermClose <buffer> ++once lua require("lib.fuzzy").cancel()')
end

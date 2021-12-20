local Feature = {}

function Feature:new(label)
	return setmetatable({ label = label }, { __index = self })
end

function Feature:derive(label)
	local child_label = ("%s_%s"):format(self.label, label)

	return Feature:new(child_label)
end

function Feature:get_var_name()
	return ("NVIM_DISABLE_%s"):format(self.label:upper())
end

function Feature:is_on()
	return vim.env[self:get_var_name()] ~= "1"
end

function Feature:as_str()
	local var_name = self:get_var_name()

	return ("%s=%s"):format(var_name, vim.env[var_name] or 0)
end

local lsp_feat = Feature:new("lsp")
local tree_sitter_feat = Feature:new("tree_sitter")

return {
	lsp = {
		core = lsp_feat,
		local_settings = lsp_feat:derive("local_settings"),
		lua_dev = lsp_feat:derive("lua_dev"),
	},
	tree_sitter = {
		core = tree_sitter_feat,
		rainbow = tree_sitter_feat:derive("rainbow"),
		spelling = tree_sitter_feat:derive("spelling"),
		auto_tagging = tree_sitter_feat:derive("auto_tagging"),
	},
	indent_lines = Feature:new("indent_lines"),
	git_signs = Feature:new("git_signs"),
	enhanced_filetype = Feature:new("enhanced_filetype"),
	comment_text = Feature:new("comment_text"),
	colorize_hex = Feature:new("colorize_hex"),
}

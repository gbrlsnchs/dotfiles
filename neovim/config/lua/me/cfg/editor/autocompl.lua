local config = require("me.api.config")

if not config.get("editor", "autocompletion") then
	return
end

vim.cmd.packadd("nvim-cmp")
vim.cmd.packadd("cmp-buffer")
vim.cmd.packadd("cmp-path")
vim.cmd.packadd("cmp-cmdline")
vim.cmd.packadd("LuaSnip")
vim.cmd.packadd("cmp_luasnip")

local cmp = require("cmp")
local luasnip = require("luasnip")

local function completion_sources()
	local sources = {
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
	}

	if not config.get("lsp", "enabled") then
		return sources
	end

	vim.cmd.packadd("cmp-nvim-lsp")
	vim.cmd.packadd("cmp-nvim-lsp-signature-help")

	return vim.list_extend({
		{ name = "nvim_lsp" },
		{ name = "nvim_lsp_signature_help" },
	}, sources)
end

local function complete_words()
	cmp.complete({
		config = {
			sources = cmp.config.sources({
				{ name = "buffer" },
			}),
		},
	})
end

cmp.setup({
	window = {
		completion = cmp.config.window.bordered({ border = "single" }),
		documentation = cmp.config.window.bordered({ border = "single" }),
	},
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-n>"] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				complete_words()
			end
		end, { "i", "s", }),
		["<C-p>"] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				complete_words()
			end
		end, { "i", "s", }),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = false }),
	}),
	sources = cmp.config.sources(completion_sources()),
})

cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "buffer" },
	}),
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "cmdline" },
		{ name = "path" },
	}),
})

vim.opt.completeopt = { "menu", "menuone", "noselect" }

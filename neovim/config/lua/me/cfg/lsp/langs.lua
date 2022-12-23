local config = require("me.api.config")
local excmd = require("me.api.excmd")
local util = require("me.api.util")

local api = vim.api
local uv = vim.loop
local nvim_state = vim.fn.stdpath("state")
local nvim_data = vim.fn.stdpath("data")
local cwd = uv.cwd()
local augroup = api.nvim_create_augroup("lsp", {})

--- Wraps an LSP server in a Podman container.
--- @param image string: Container image to be used.
--- @param server table: Configuration table for the LSP server.
--- @return table: The patched server configuration.
local function containerize(image, server)
	server.cmd = {
		"podman",
		"container",
		"run",
		"--rm",
		"--interactive",
		"--network",
		"none",
		"--workdir",
		cwd,
		"--volume",
		string.format("%s:%s:z", cwd, cwd),
		"--pid",
		"host",
		image,
		unpack(server.cmd or {}),
	}

	return server
end

-- Language settings.
local defaults = {
	ccls = {
		filetypes = { "c" },
	},
	gopls = {
		filetypes = { "go" },
		root_dir = { "go.work", "go.mod" },
		settings = {
			experimentalWorkspaceModule = true,
			experimentalPostfixCompletions = true,
			codelenses = {
				generate = true,
				gc_details = true,
				test = true,
				tidy = true,
			},
		},
	},
	jdtls = {
		cmd = { "jdtls", "-data", nvim_state .. "/jdtls" },
		filetypes = { "java" },
	},
	rust_analyzer = {
		cmd = { "rust-analyzer" },
		filetypes = { "rust", },
		root_dir = { "Cargo.toml" },
	},
	lua_language_server = {
		cmd = { "lua-language-server" },
		filetypes = { "lua" },
		settings = {
			Lua = {
				runtime = {
					version = "LuaJIT",
					path = vim.split(package.path, ";"),
				},
				workspace = {
					library = {
						[vim.env.VIMRUNTIME] = true,
						[nvim_data .. "/pack/*/start/*"] = true,
						[nvim_data .. "/pack/*/opt/*"] = true,
						[nvim_data .. "/rocks/*"] = true,
					},
					maxPreload = 2000,
					preloadFileSize = 50000,
				},
				diagnostics = {
					globals = { "vim" },
				},
			},
		},
	},
	texlab = {
		filetypes = { "tex" },
		settings = {
			texlab = {
				forwardSearch = {
					executable = "zathura",
					args = {
						"--synctex-forward",
						"%l:1:%f",
						"%p",
					},
				},
			},
		},
		commands = {
			TexlabBuild = {

			},
		},
	},
	tsserver = containerize("typescript-language-server", {
		filetypes = { "javascript", "typescript" },
		root_dir = { "tsconfig.json", "jsconfig.json", "package.json" },
	}),
	vuels = containerize("vls", {
		filetypes = { "vue" },
		root_dir = { "package.json" },
	}),
	zls = {
		filetypes = { "zig" },
		root_dir = { "build.zig" },
	},
}

--- Restarts all LSP servers or only ones with a specific name.
--- @param name string | nil: Name of the server to be restarted.
local function restart_servers(name)
	local clients = vim.lsp.get_active_clients({ name = name })
	local requested = {}
	local filetypes = {}

	for _, client in ipairs(clients) do
		if requested[client.id] then
			goto continue
		end

		requested[client.id] = true
		local client_fts = client.config.filetypes

		client.stop()

		-- For each buffer that had the client attached to them, reattach them.
		for _, ft in ipairs(client_fts) do
			filetypes[ft] = true
		end

		::continue::
	end

	local function reattach()
		if not vim.tbl_isempty(vim.lsp.get_active_clients()) then
			vim.schedule(reattach)
			return
		end

		for ft in pairs(filetypes) do
			api.nvim_exec_autocmds("FileType", {
				group = augroup,
				pattern = ft,
			})
		end
	end

	reattach()
end

local function register_filetypes()
	local langs = {}
	for name, opts in pairs(defaults) do
		for _, ft in ipairs(opts.filetypes) do
			langs[ft] = langs[ft] or {}
			table.insert(langs[ft], name)
		end
	end

	for lang, servers in pairs(langs) do
		api.nvim_create_autocmd("FileType", {
			pattern = lang,
			group = augroup,
			desc = string.format("LSP functionality for %q", lang),
			callback = function()
				local bufname = api.nvim_buf_get_name(0)
				local dirname = vim.fs.dirname(bufname)

				for _, server_name in ipairs(servers) do
					local server = defaults[server_name]
					if not server then
						vim.notify(string.format(
							"Server %q has no configuration associated to it",
							server_name
						), vim.log.levels.WARN)
						goto continue
					end

					server = vim.tbl_deep_extend("force", server, config.get("lsp", "servers", server_name) or {})
					local capabilities = vim.tbl_deep_extend(
						"force",
						vim.lsp.protocol.make_client_capabilities(),
						server.capabilities or {}
					)

					if config.get("editor", "autocompletion") then
						local cmp_lsp = require("cmp_nvim_lsp")
						capabilities = cmp_lsp.update_capabilities(capabilities)
					end


					server = vim.tbl_deep_extend("keep", server, {
						cmd = { server_name },
						name = server_name,
						capabilities = capabilities,
						on_init = function(client, result)
							if result.offsetencoding then
								client.offset_encoding = result.offsetencoding
							end

							client.notify("workspace/didChangeConfiguration", {
								settings = server.settings or {},
							})
						end,
					})

					server.root_dir = server.root_dir or {}

					local root_file = vim.fs.find(
						vim.list_extend(server.root_dir, { ".git" }),
						{ upward = true, path = dirname }
					)

					server.root_dir = vim.fs.dirname(root_file[1]) or cwd
					server.workspace_folders = vim.tbl_map(
						function(dir)
							return { name = dir, uri = vim.uri_from_fname(dir) }
						end,
						server.workspace_folders or { server.root_dir }
					)

					vim.lsp.start(server)

					::continue::
				end
			end,
		})
	end
end

local function unregister_filetypes()
	local aucmds = api.nvim_get_autocmds({
		group = augroup,
		event = "FileType",
	})

	for _, cmd in ipairs(aucmds) do
		api.nvim_del_autocmd(cmd.id)
	end
end

local function notify_changes()
	local cfg = config.get("lsp", "servers") or {}

	-- Notify configuration changes for all LSP servers that have custom configs.
	for name, opts in pairs(cfg) do
		-- If the server is no longer desired, it has to be shut down.
		local change_count = vim.tbl_count(opts)
		local settings_only = change_count == 1 and opts.settings

		if settings_only then
			local clients = vim.lsp.get_active_clients({ name = name })
			for _, client in ipairs(clients) do
				client.notify("workspace/didChangeConfiguration", {
					settings = vim.tbl_deep_extend(
						"force",
						vim.tbl_get(client, "config", "settings") or {},
						opts.settings or {}
					),
				})
			end
		elseif change_count > 0 then
			restart_servers(name)
		end
	end
end

config.on_change(unregister_filetypes, "lsp")
config.on_change(register_filetypes, "lsp")
config.on_change(notify_changes, "lsp")

register_filetypes()

local inlay_hints
local hints_enabled = config.get("lsp", "inlay_hints")
if hints_enabled then
	util.packadd("lsp-inlayhints.nvim")

	inlay_hints = require("lsp-inlayhints")
	inlay_hints.setup()
end

local filters = {
	sumneko_lua = {
		format = {},
	},
}
api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local bufnr = args.buf
		local client = vim.lsp.get_client_by_id(args.data.client_id)

		if config.get("lsp", "inlay_hints") then
			inlay_hints.on_attach(client, bufnr)
		end

		excmd.register("LSP", {
			LspHover = {
				desc = "Show information about symbol under cursor",
				callback = function()
					vim.lsp.buf.hover()
				end,
				opts = {
					keymap = { keys = "K" },
					buffer = bufnr,
				},
			},
			LspDefinition = {
				desc = "Go to symbol definition",
				callback = function()
					vim.lsp.buf.definition()
				end,
				opts = {
					keymap = { keys = "<C-]>" },
					buffer = bufnr,
				},
			},
			LspImplementation = {
				desc = "Go to symbol implementation",
				callback = function()
					vim.lsp.buf.implementation()
				end,
				opts = {
					keymap = { keys = "gd" },
					buffer = bufnr,
				},
			},
			LspDeclaration = {
				desc = "Go to symbol declaration",
				callback = function()
					vim.lsp.buf.declaration()
				end,
				opts = {
					keymap = { keys = "gD" },
					buffer = bufnr,
				},
			},
			LspTypeDefinition = {
				desc = "Go to symbol type definition",
				callback = function()
					vim.lsp.buf.type_definition()
				end,
				opts = {
					keymap = { keys = "<Leader>lt" },
					buffer = bufnr,
				},
			},
			LspIncomingCalls = {
				desc = "Show incoming calls",
				callback = function()
					vim.lsp.buf.incoming_calls()
				end,
				opts = {
					buffer = bufnr,
				},
			},
			LspOutgoingCalls = {
				desc = "Show outgoing calls",
				callback = function()
					vim.lsp.buf.outgoing_calls()
				end,
				opts = {
					buffer = bufnr,
				},
			},
			LspReferences = {
				desc = "Find symbol references",
				callback = function()
					vim.lsp.buf.references({ includeDeclaration = false })
				end,
				opts = {
					keymap = { keys = "<Leader>lR" },
					buffer = bufnr,
				},
			},
			LspDocumentSymbol = {
				desc = "Search for symbol in current buffer",
				callback = function()
					vim.lsp.buf.document_symbol()
				end,
				opts = {
					keymap = { keys = "<Leader>ls" },
					buffer = bufnr,
				},
			},
			LspFormat = {
				desc = "Format current buffer",
				callback = util.with_range(function(range)
					if range then
						range = vim.tbl_map(function(idx)
							return { idx, 0 }
						end, range)

						vim.lsp.buf.range_formatting(nil, unpack(range))
						return
					end

					local fmt_opts = { async = true }
					local fmt_filters = vim.tbl_get(filters, "format") or {}

					if #fmt_filters == 1 then
						fmt_opts.name = fmt_filters[1]
					elseif #fmt_filters > 1 then
						fmt_opts.filter = function(buf_client)
							return vim.tbl_contains(fmt_filters, buf_client.name)
						end
					end

					vim.lsp.buf.format(fmt_opts)
				end),
				opts = {
					modes = { "n", "v" },
					keymap = { keys = "<Leader>lf" },
					buffer = bufnr,
				},
			},
			LspCodeAction = {
				desc = "Run a code action",
				callback = util.with_range(function(range)
					if range then
						range = vim.tbl_map(function(idx)
							return { idx, 0 }
						end, range)

						vim.lsp.buf.range_code_action(nil, unpack(range))
						return
					end

					vim.lsp.buf.code_action()
				end),
				opts = {
					modes = { "n", "v" },
					keymap = { keys = "<Leader>lc" },
					buffer = bufnr,
				},
			},
			LspRename = {
				desc = "Rename symbol under cursor",
				callback = function()
					vim.lsp.buf.rename()
				end,
				opts = {
					keymap = { keys = "<Leader>lr" },
				},
			},
			LspWorkspaceAddFolder = {
				desc = "Add folder to workspace",
				callback = function()
					vim.lsp.buf.add_workspace_folder()
				end,
				opts = {
					buffer = bufnr,
				},
			},
			LspWorkspaceListFolders = {
				desc = "List workspace folders",
				callback = function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end,
				opts = {
					buffer = bufnr,
				},
			},
			LspWorkspaceRemoveFolder = {
				desc = "Remove folder from workspace",
				callback = function()
					vim.lsp.buf.remove_workspace_folder()
				end,
				opts = {
					buffer = bufnr,
				},
			},
			LspWorkspaceSymbol = {
				desc = "Find workspace symbol",
				callback = util.with_fargs(function(query)
					vim.lsp.buf.workspace_symbol(query)
				end),
				opts = {
					nargs = "+",
					buffer = bufnr,
					keymap = { keys = "<Leader>lS" },
				},
			},
			LspRestart = {
				desc = "Restart all LSP servers",
				callback = function()
					restart_servers()
				end,
				opts = {
					buffer = bufnr,
				},
			},
		})
	end,
	group = augroup,
})

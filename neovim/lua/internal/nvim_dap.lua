local M = {}

local function get_settings(ft, port)
	local settings = {
		go = {
			adapter = {
				type = "executable",
				command = "node",
				args = { os.getenv("HOME") .. "/vscode-go/dist/debugAdapter.js" },
			},
			config = {
				type = "go",
				request = "attach",
				mode = "remote",
				name = "Remote Attached Debugger",
				dlvToolPath = os.getenv("HOME") .. "/go/bin/dlv", -- Or wherever your local delve lives.
				port = port or 42345,
				cwd = vim.fn.getcwd(),
			},
		},
	}

	return settings[ft]
end

function M.launch_adapter()
	local dap = require("dap")

	local ft = vim.bo.filetype
	local buf_settings = get_settings(ft, vim.fn.input("Remote debugging port: "))
	if not buf_settings then
		print(string.format('No settings available for buffer of filetype "%s"'), ft)
		return
	end

	local session = dap.launch(buf_settings.adapter, buf_settings.config)
	if session == nil then
		print("Error launching adapter!")
		return
	end
	dap.repl.open()
end

return M

local function get_adapter(dev_path)
	local home = os.getenv("HOME")
	return string.format("%s/dev/%s", home, dev_path)
end

-- Go
local function setup_go(dap)
	local dlv_path = vim.fn.exepath("dlv")

	dap.adapters.go = {
		type = "executable",
		command = "node",
		args = { get_adapter("github.com/golang/vscode-go/dist/debugAdapter.js") },
	}

	dap.configurations.go = {
		{
			name = "Debug",
			type = "go",
			request = "launch",
			showLog = false,
			program = "${file}",
			dlvToolPath = dlv_path,
			cwd = vim.fn.getcwd(),
		},
		{
			name = "Debug (test)",
			type = "go",
			request = "launch",
			showLog = false,
			program = "${file}",
			dlvToolPath = dlv_path,
			cwd = vim.fn.getcwd(),
		},
		-- TODO: Add this into a util so I can pick the port on the fly.
		{
			name = "Debug (remote)",
			type = "go",
			request = "attach",
			mode = "remote",
			host = "127.0.0.1",
			port = 42345,
			dlvToolPath = dlv_path,
			cwd = vim.fn.getcwd(),
		},
	}
end

return function()
	local dap = require("dap")

	dap.defaults.fallback.terminal_win_cmd = "50vsplit new"

	vim.fn.sign_define("DapBreakpoint", { text = "•", texthl = "ColorColumn", linehl = "", numhl = "" })
	vim.fn.sign_define("DapLogPoint", { text = "¤", texthl = "ColorColumn", linehl = "", numhl = "" })
	vim.fn.sign_define("DapStopped", { text = "→", texthl = "ColorColumn", linehl = "ColorColumn", numhl = "" })

	setup_go(dap)

	local which_key = require("which-key")

	which_key.register({
		name = "debug",
		T = {
			'<Cmd>lua require("dap").toggle_breakpoint(nil, nil, vim.fn.input("Log message: "))<CR>',
			"Toggle breakpoint",
		},
		b = { '<Cmd>lua require("dap").list_breakpoints()<CR>', "Show all breakpoints set" },
		c = { '<Cmd>lua require("dap").continue()<CR>', "Launch or continue a debug session" },
		l = { '<Cmd>lua require("util.nvim_dap").launch_adapter()<CR>', "Launch custom debug session" },
		r = { '<Cmd>lua require("dap").repl.open()<CR>', "Open debugging REPL" },
		s = {
			name = "step",
			O = { '<Cmd>lua require("dap").step_over()<CR>', "Step over code" },
			b = { '<Cmd>lua require("dap").step_back()<CR>', "Step back in code" },
			i = { '<Cmd>lua require("dap").step_into()<CR>', "Step into code" },
			o = { '<Cmd>lua require("dap").step_out()<CR>', "Step out code" },
		},
		t = { '<Cmd>lua require("dap").toggle_breakpoint()<CR>', "Toggle breakpoint" },
	}, {
		prefix = "<Leader>d",
	})
end

local dap = require("dap")
local dapui = require("dapui")

dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

local function dapSymbol(name, icon, color)
	local hl = "Dap" .. name
	vim.fn.sign_define(hl, { text = icon, numhl = "", texthl = color })
end

local keymap = vim.keymap.set

vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#E06C75" })
vim.api.nvim_set_hl(0, "DapLogpoint", { fg = "#6678DD" })
vim.api.nvim_set_hl(0, "DapStopped", { fg = "#E5C07B" })

local function breakpointPrint()
	vim.ui.input({ prompt = "Log point message: " }, function(input)
		-- check if the input is nill or empty
		if input == nil or input == "" then
			return
		end

		dap.set_breakpoint(nil, nil, input)
	end)
end

keymap("n", "<leader>b", dap.toggle_breakpoint)
keymap("n", "<leader>B", function()
	vim.ui.input({ prompt = "Breakpoint condition: " }, function(input)
		-- check if the input is nill or empty
		if input == nil or input == "" then
			return
		end

		dap.set_breakpoint(input, nil, nil)
	end)
end)
keymap("n", "<leader>bp", function()
	vim.ui.input({ prompt = "Log point message: " }, function(input)
		-- check if the input is nill or empty
		if input == nil or input == "" then
			return
		end

		dap.set_breakpoint(nil, nil, input)
	end)
end)
keymap("n", "<F5>", dap.continue)
keymap("n", "<F10>", dap.step_over)
keymap("n", "<F11>", dap.step_into)
keymap("n", "<F12>", dap.step_out)

dapSymbol("Breakpoint", "", "DapBreakpoint")
dapSymbol("BreakpointCondition", "ﳁ", "DapBreakpoint")
dapSymbol("BreakpointRejected", "", "DapBreakpoint")
dapSymbol("LogPoint", "", "DapLogpoint")
dapSymbol("Stopped", "", "DapStopped")

-- Servers
dap.adapters.codelldb = {
	type = "server",
	port = "${port}",
	executable = {
		command = "codelldb",
		args = { "--port", "${port}" },
	},
}

require("dap.ext.vscode").load_launchjs(nil, { codelldb = { "cpp", "h" } })

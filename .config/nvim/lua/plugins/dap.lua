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

-- Dap breakpoint picker

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local themes = require("telescope.themes")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local lookup_table = {
	normal = dap.toggle_breakpoint,
	condition = function()
		vim.ui.input({ prompt = "Condition: " }, function(input)
			-- check if the input is nill or empty
			if input == nil or input == "" then
				return
			end
			dap.set_breakpoint(input, nil, nil)
		end)
	end,
	log = function()
		vim.ui.input({ prompt = "Message: " }, function(input)
			-- check if the input is nill or empty
			if input == nil or input == "" then
				return
			end

			dap.set_breakpoint(nil, nil, input)
		end)
	end,
}

options = {}

for key, _ in pairs(lookup_table) do
	table.insert(options, key)
end

local select_breakpoint = function()
	local opts = {
		attach_mappings = function(prompt_bufnr, map)
			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()

				if selection == nil then
					return
				end
				-- call function from lookup table
				lookup_table[selection[1]]()
			end)
			return true
		end,
	}

	pickers
		.new(opts, {
			prompt_title = "Create breakpoint",
			finder = finders.new_table(options),
			sorter = conf.generic_sorter(opts),
		})
		:find()
end

-- key mapping
keymap("n", "<leader>b", dap.toggle_breakpoint)
keymap("n", "<leader>B", select_breakpoint)
keymap("n", "<F5>", dap.continue)
keymap("n", "<F10>", dap.step_over)
keymap("n", "<F11>", dap.step_into)
keymap("n", "<F12>", dap.step_out)

local bufferline_is_ok, bufferline = pcall(require, "bufferline")
if not bufferline_is_ok then
	print("Bufferline not found")
	return
end

bufferline.setup({
	icons = {
		pinned = {
			button = "",
		},
	},
})

-- nvim-tree settings
local nvim_tree_events = require("nvim-tree.events")
local bufferline_api = require("bufferline.api")

local function get_tree_size()
	return require("nvim-tree.view").View.width
end

nvim_tree_events.subscribe("TreeOpen", function()
	bufferline_api.set_offset(get_tree_size())
end)

nvim_tree_events.subscribe("Resize", function()
	bufferline_api.set_offset(get_tree_size())
end)

nvim_tree_events.subscribe("TreeClose", function()
	bufferline_api.set_offset(0)
end)

-- mapping
local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set

-- move between tabs
keymap("n", "<S-l>", ":BufferNext<cr>", opts)
keymap("n", "<S-h>", ":BufferPrev<cr>", opts)

-- pin tab
keymap("n", "<S-p>", ":BufferPin<cr>", opts)

-- close tab
keymap("n", "<S-c>", ":BufferClose<cr>", opts)

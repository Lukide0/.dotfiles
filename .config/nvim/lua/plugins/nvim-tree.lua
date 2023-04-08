local nvim_tree = require("nvim-tree")
local api = require("nvim-tree.api")

nvim_tree.setup()

local keymap = vim.keymap.set
keymap("n", "<C-b>", api.tree.toggle)

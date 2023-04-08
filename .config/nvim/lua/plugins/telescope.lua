local telescope = require("telescope")

local builtin = require("telescope.builtin")

telescope.setup()
-- find files
vim.keymap.set("n", "<leader>f", builtin.find_files, {})

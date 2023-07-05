local telescope = require("telescope")
local harpoon_mark = require("harpoon.mark")
local harpoon_ui = require("harpoon.ui")

local builtin = require("telescope.builtin")
local keymap = vim.keymap.set

telescope.setup()
telescope.load_extension("harpoon")

-- find files
keymap("n", "<leader>f", builtin.find_files, {})
-- show harpoon marks
keymap("n", "<leader>ls", harpoon_ui.toggle_quick_menu, {})

keymap("n", "<leader>la", harpoon_mark.add_file, {})

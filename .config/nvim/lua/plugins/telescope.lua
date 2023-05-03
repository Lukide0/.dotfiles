local telescope = require("telescope")
local harpoon_mark = require("harpoon.mark")

local builtin = require("telescope.builtin")
local keymap = vim.keymap.set

telescope.setup()
telescope.load_extension("harpoon")

-- find files
keymap("n", "<leader>ff", builtin.find_files, {})
-- show harpoon marks
keymap("n", "<leader>fm", ":Telescope harpoon marks<CR>", {})

keymap("n", "<leader>fa", harpoon_mark.add_file, {})

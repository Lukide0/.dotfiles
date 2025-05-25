local telescope = require("telescope")

local builtin = require("telescope.builtin")
local keymap = vim.keymap.set

telescope.setup({
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
        },
    },
})

telescope.load_extension("ui-select")

-- find files
keymap("n", "<leader>f", builtin.find_files, {})

-- show code actions
keymap("n", "<leader>da", vim.lsp.buf.code_action)

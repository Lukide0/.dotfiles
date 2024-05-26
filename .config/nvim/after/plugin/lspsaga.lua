local lspsaga = require("lspsaga")

lspsaga.setup({
    -- outline
    outline = {
        win_position = "right",
        keys = { toggle_or_jump = "<Enter>", quit = "q" },
    },
    -- winbar
    symbol_in_winbar = { enable = true, separator = " ", folder_level = 1 },
    -- rename
    rename = {
        quit = "<C-c>",
        exec = "<CR>",
        mark = "x",
        confirm = "<CR>",
        in_select = true,
    },
    -- UI settings
    ui = {
        title = true,
        border = "single",
        winblend = 0,
        expand = "",
        collapse = "",
        code_action = "💡",
        kind = {},
    },
})

local keymap = vim.keymap.set

-- toggle outline
keymap("n", "<leader>o", ":Lspsaga outline<CR>")
-- diagnostics workspace
keymap("n", "<leader>dl", ":Lspsaga show_workspace_diagnostics<CR>")
-- diagnostics line
keymap("n", "<leader>dll", ":Lspsaga show_line_diagnostics<CR>")
-- rename symbol
keymap("n", "<leader>r", ":Lspsaga rename<CR>")

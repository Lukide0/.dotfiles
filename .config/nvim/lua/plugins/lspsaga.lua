local lspsaga = require("lspsaga")

lspsaga.setup({
    -- outline
    outline = {
        win_position = "right",
        keys = { expand_or_jump = "<Enter>", quit = "q" },
    },
    -- winbar
    symbol_in_winbar = { enable = true, separator = " ", folder_level = 1 },
})

local keymap = vim.keymap.set

-- toggle outline
keymap("n", "<Leader>o", ":Lspsaga outline<CR>")

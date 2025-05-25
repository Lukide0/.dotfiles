local gitsigns = require("gitsigns")

gitsigns.setup()

local keymap = vim.keymap.set
-- navigation
keymap("n", "[c", function()
    gitsigns.nav_hunk("prev")
end)
keymap("n", "]c", function()
    gitsigns.nav_hunk("next")
end)

keymap("n", "<leader>hS", gitsigns.stage_hunk)
keymap("v", "<leader>hS", function()
    local first_line = vim.fn.line(".")
    local last_line = vim.fn.line("v")

    gitsigns.stage_hunk({ first_line, last_line })
end)

keymap("n", "<leader>hs", gitsigns.preview_hunk_inline)
keymap("n", "<leader>hd", gitsigns.diffthis)
keymap("n", "<leader>hv", gitsigns.select_hunk)
keymap("n", "<leader>hr", gitsigns.reset_hunk)

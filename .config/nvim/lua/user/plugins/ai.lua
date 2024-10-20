return {
    {
        "monkoose/neocodeium",
        event = "VeryLazy",
        config = function()
            local neocodeium = require("neocodeium")
            local keymap = vim.keymap.set
            local opts = { noremap = true, expr = true, silent = false }

            neocodeium.setup({
                manual = true,
            })

            keymap("i", "<C-a>", function()
                neocodeium.accept()
            end, opts)

            keymap("i", "<C-Tab>", function()
                neocodeium.cycle_or_complete()
            end, opts)

            keymap("i", "<C-x>", function()
                neocodeium.clear()
            end, opts)

            -- create an autocommand which closes cmp when ai completions are displayed
            vim.api.nvim_create_autocmd("User", {
                pattern = "NeoCodeiumCompletionDisplayed",
                callback = function()
                    require("cmp").abort()
                end,
            })
        end,
    },
}

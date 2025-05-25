local oil = require("oil")

oil.setup({
    view_options = {
        is_hidden_file = function(name, bufnr)
            return name ~= ".." and vim.startswith(name, ".")
        end,
    },
})

local keymap = vim.keymap.set

keymap("n", "<leader>e", function()
    local cwd = vim.fn.getcwd()
    oil.open(cwd)
end)

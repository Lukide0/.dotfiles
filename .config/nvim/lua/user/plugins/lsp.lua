return {
    "neovim/nvim-lspconfig", -- Configurations for Nvim LSP
    "mason-org/mason.nvim", -- package manager
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {},
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
    },
    "stevearc/conform.nvim",
}

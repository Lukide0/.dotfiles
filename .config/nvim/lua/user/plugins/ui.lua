return {
    "onsails/lspkind.nvim",
    {
        "akinsho/bufferline.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
    },
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require("lualine").setup({
                options = {
                    theme = "onedark",
                    section_separators = { left = "", right = "" },
                    component_separators = { left = "", right = "" },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "filename", "diagnostics", "diff" },
                    lualine_c = { "searchcount" },
                    lualine_x = { "tabs" },
                    lualine_y = { "selectioncount", "progress" },
                    lualine_z = { "location" },
                },
            })
        end,
    },
    "glepnir/lspsaga.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    "lewis6991/gitsigns.nvim",
    {
        "NeogitOrg/neogit",
        dependencies = "nvim-lua/plenary.nvim",
        config = function()
            require("neogit").setup({})
        end,
    },
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
    },
    {
        "debugloop/telescope-undo.nvim",
        dependencies = {
            {
                "nvim-telescope/telescope.nvim",
                dependencies = { "nvim-lua/plenary.nvim" },
            },
        },
        keys = {
            {
                "<leader>u",
                "<cmd>Telescope undo<cr>",
                desc = "undo history",
            },
        },
        opts = {
            extensions = {
                undo = {
                    side_by_side = true,
                    layout_strategy = "vertical",
                },
            },
        },
        config = function(_, opts)
            local telescope = require("telescope")
            telescope.setup(opts)
            telescope.load_extension("undo")
        end,
    },
    {
        "goolord/alpha-nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("alpha").setup(require("alpha.themes.dashboard").config)
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    },
    "nvim-treesitter/nvim-treesitter-context",
}

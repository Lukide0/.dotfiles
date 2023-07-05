return {
	"neovim/nvim-lspconfig", -- Configurations for Nvim LSP
	"williamboman/mason.nvim", -- package manager
	"williamboman/mason-lspconfig.nvim",
	"jay-babu/mason-nvim-dap.nvim",
	{
		"jose-elias-alvarez/null-ls.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	"jay-babu/mason-null-ls.nvim",
}

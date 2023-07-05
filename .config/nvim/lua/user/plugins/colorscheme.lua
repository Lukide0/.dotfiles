return {
	{
		"navarasu/onedark.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme onedark]])

			local onedark = require("onedark")
			onedark.setup({ style = "deep" })
			onedark.load()
		end,
	},
}

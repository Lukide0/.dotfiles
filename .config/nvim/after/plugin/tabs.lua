local bufferline = require("bufferline")

bufferline.setup({
	options = {
		mode = "tabs",
		diagnostics = "nvim_lsp",
		hover = {
			enabled = true,
			delay = 200,
			reveal = { "close" },
		},
		diagnostics_indicator = function(count, level)
			local icon = level:match("error") and " " or " "
			return " " .. icon .. count
		end,
	},
})

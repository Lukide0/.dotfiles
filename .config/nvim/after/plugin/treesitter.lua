local treesitter_configs = require("nvim-treesitter.configs")
local treesitter_context = require("treesitter-context")

treesitter_context.setup()
treesitter_configs.setup({
	sync_install = false,
	highlight = { enable = true, disable = { "" } },
})

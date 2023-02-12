local treesitter_is_ok, treesitter_configs = pcall(require, "nvim-treesitter.configs")
if not treesitter_is_ok then
	print("Treesitter not found")
	return
end

local treesitter_context_is_ok, treesitter_context = pcall(require, "treesitter-context")
if not treesitter_context_is_ok then
	print("treesitter-context not found")
	return
end

treesitter_context.setup()

treesitter_configs.setup({
	sync_install = false,
	highlight = { enable = true, disable = { "" } },
})

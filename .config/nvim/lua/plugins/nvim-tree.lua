local nvim_tree_is_ok, nvim_tree = pcall(require, "nvim-tree")
if not nvim_tree_is_ok then
	print("nvim-tree not found")
	return
end

nvim_tree.setup()

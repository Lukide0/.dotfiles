local telescope_is_ok, telescope = pcall(require, "telescope")
if not telescope_is_ok then
	print("Telescope not found")
	return
end

local builtin_is_ok, builtin = pcall(require, "telescope.builtin")
if not builtin_is_ok then
	return
end

telescope.setup()

-- find files
vim.keymap.set("n", "<leader>f", builtin.find_files, {})

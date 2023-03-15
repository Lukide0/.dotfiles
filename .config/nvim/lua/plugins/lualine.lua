local lualine_is_ok, lualine = pcall(require, "lualine")
if not lualine_is_ok then
	print("lualine not found")
	return
end

lualine.setup({ options = { theme = "onedark" } })

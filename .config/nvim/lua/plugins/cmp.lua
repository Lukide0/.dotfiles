local cmp_is_ok, cmp = pcall(require, "cmp")
if not cmp_is_ok then
	print("Cmp not found")
	return
end

local snip_is_ok, luasnip = pcall(require, "luasnip")
if not snip_is_ok then
	print("Luasnip not found")
	return
end

local lspkind_is_ok, lspkind = pcall(require, "lspkind")
if not lspkind_is_ok then
	print("Lspkind not found")
	return
end

lspkind.init()

cmp.setup({
	mapping = {
		["<C-k>"] = cmp.mapping.select_prev_item(),
		["<C-j>"] = cmp.mapping.select_next_item(),

		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),

		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
			select = true,
		}),
		["<C-Space>"] = cmp.mapping.complete(),
	},
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer", keyword_length = 5, max_item_count = 3 },
		{ name = "path", keyword_length = 4 },
	},
	formatting = {
		format = lspkind.cmp_format({
			mode = "symbol",
			preset = "codicons",
			menu = {
				buffer = "[buff]",
				nvim_lsp = "[LSP]",
				path = "[path]",
				luasnip = "[snip]",
			},
		}),
	},
	window = { documentation = { border = "single" } },
	experimental = { ghost_text = true },
})

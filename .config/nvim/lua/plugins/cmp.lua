local cmp = require("cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")

lspkind.init()

cmp.setup({
    mapping = {
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping({
            i = function(fallback)
                if cmp.visible() and cmp.get_active_entry() then
                    cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = false })
                else
                    fallback()
                end
            end,
            s = cmp.mapping.confirm({ select = true }),
            c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
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
        { name = "buffer",  keyword_length = 5, max_item_count = 3 },
        { name = "path",    keyword_length = 4 },
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

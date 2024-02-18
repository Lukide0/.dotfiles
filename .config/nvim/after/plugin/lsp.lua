-- setup installer
local mason = require("mason")
local mason_lsp = require("mason-lspconfig")
local mason_dap = require("mason-nvim-dap")
local mason_null_ls = require("mason-null-ls")
local lsp_signature = require("lsp_signature")

vim.lsp.set_log_level("off")

-- functions signatures
lsp_signature.setup({
    bind = false,
    handler_opts = { border = "single" },
    hint_enable = false,
})

-- setup mason plugins in correct order
mason.setup()
mason_dap.setup({ automatic_setup = true })
mason_lsp.setup()
mason_null_ls.setup({ automatic_installation = false, handlers = {} })

-- setup null_ls
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.clang_format.with({
            extra_args = { "-style=file" },
        }),
    },
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({ bufnr = bufnr })
                end,
            })
        end
    end,
})

-- completion + icons
local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

local function lspSymbol(name, icon)
    local hl = "DiagnosticSign" .. name
    vim.fn.sign_define(hl, { text = icon, numhl = "", texthl = hl })
end

lspSymbol("Error", "")
lspSymbol("Warn", "")
lspSymbol("Info", "")
lspSymbol("Hint", "")

-- mapping
local keymap = vim.keymap.set
local lsp_on_attach = function()
    keymap("n", "gs", vim.lsp.buf.hover, { buffer = 0 })                              -- show info
    keymap("n", "gd", vim.lsp.buf.definition, { buffer = 0 })                         -- go to definition
    keymap("n", "gt", vim.lsp.buf.type_definition, { buffer = 0 })                    -- go to type definition
    keymap("n", "gi", vim.lsp.buf.implementation, { buffer = 0 })                     -- go to implementation
    keymap("n", "gr", vim.lsp.buf.references, { buffer = 0 })                         -- go to references

    keymap("n", "<leader>dj", vim.diagnostic.goto_next, { buffer = 0 })               -- go to next error
    keymap("n", "<leader>dk", vim.diagnostic.goto_prev, { buffer = 0 })               -- go to previous error
    keymap("n", "<leader>dl", ":Lspsaga show_workspace_diagnostics<CR>", { buffer = 0 }) -- list of errors
end

-- mason_lsp setup
mason_lsp.setup_handlers({
    function(server_name)
        -- temporary fix: https://github.com/jose-elias-alvarez/null-ls.nvim/issues/428
        if server_name == "clangd" then
            lspconfig[server_name].setup({
                on_attach = lsp_on_attach,
                capabilities = cmp_nvim_lsp.default_capabilities(),
                cmd = { "clangd", "--offset-encoding=utf-16", "--clang-tidy" },
            })
        else
            lspconfig[server_name].setup({ on_attach = lsp_on_attach })
        end
    end,
})

-- setup installer
local mason = require("mason")
local mason_lsp = require("mason-lspconfig")
local mason_dap = require("mason-nvim-dap")
local mason_null_ls = require("mason-null-ls")

mason.setup()

mason_dap.setup({ automatic_setup = true })

mason_lsp.setup()

mason_null_ls.setup({ automatic_installation = false, handlers = {} })

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

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local lspconfig = require("lspconfig")

local function lspSymbol(name, icon)
    local hl = "DiagnosticSign" .. name
    vim.fn.sign_define(hl, { text = icon, numhl = "", texthl = hl })
end

lspSymbol("Error", "")
lspSymbol("Warn", "")
lspSymbol("Info", "")
lspSymbol("Hint", "")

local keymap = vim.keymap.set
local lsp_on_attach = function()
    keymap("n", "gs", vim.lsp.buf.hover, { buffer = 0 })                 -- show info
    keymap("n", "gd", vim.lsp.buf.definition, { buffer = 0 })            -- go to definition
    keymap("n", "gt", vim.lsp.buf.type_definition, { buffer = 0 })       -- go to type definition
    keymap("n", "gi", vim.lsp.buf.implementation, { buffer = 0 })        -- go to implementation
    keymap("n", "gr", vim.lsp.buf.references, { buffer = 0 })            -- go to references

    keymap("n", "<leader>da", vim.lsp.buf.code_action, { buffer = 0 })   -- show code actions
    keymap("n", "<leader>dj", vim.diagnostic.goto_next, { buffer = 0 })  -- go to next error
    keymap("n", "<leader>dk", vim.diagnostic.goto_prev, { buffer = 0 })  -- go to previous error
    keymap("n", "<leader>dl", ":Telescope diagnostics<cr>", { buffer = 0 }) -- list of errors

    keymap("n", "<leader>r", vim.lsp.buf.rename, { buffer = 0 })
end

mason_lsp.setup_handlers({
    function(server_name)
        lspconfig[server_name].setup({ on_attach = lsp_on_attach })
    end,
})

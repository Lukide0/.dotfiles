-- setup installer
local mason_is_ok, mason = pcall(require, "mason")
if not mason_is_ok then
    print("Mason not found")
    return
end

local mason_lsp_is_ok, mason_lsp = pcall(require, "mason-lspconfig")
if not mason_lsp_is_ok then
    print("Mason-lspconfig not found")
    return
end

mason.setup()
mason_lsp.setup({
    -- automatically install
    ensure_installed = { "sumneko_lua" }
})

local mason_null_ls_is_ok, mason_null_ls = pcall(require, "mason-null-ls")
if not mason_null_ls_is_ok then
    print("mason-null-ls not found")
    return
end

mason_null_ls.setup({
    ensure_installed = { "stylua" },
    automatic_installation = false,
    automatic_setup = true
})

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local null_ls_is_ok, null_ls = pcall(require, "null-ls")
if not null_ls_is_ok then
    print("Null-ls not found")
    return
end

null_ls.setup({
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({ bufnr = bufnr })
                end
            })
        end
    end
})

mason_null_ls.setup_handlers()

local lspconfig_is_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_is_ok then
    print("Lspconfig not found")
    return
end

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
    keymap("n", "gs", vim.lsp.buf.hover, { buffer = 0 }) -- show info
    keymap("n", "gd", vim.lsp.buf.definition, { buffer = 0 }) -- go to definition
    keymap("n", "gt", vim.lsp.buf.type_definition, { buffer = 0 }) -- go to type definition
    keymap("n", "gi", vim.lsp.buf.implementation, { buffer = 0 }) -- go to implementation
    keymap("n", "gr", vim.lsp.buf.references, { buffer = 0 }) -- go to references

    keymap("n", "<leader>dj", vim.diagnostic.goto_next, { buffer = 0 }) -- go to next error
    keymap("n", "<leader>dk", vim.diagnostic.goto_prev, { buffer = 0 }) -- go to previous error
    keymap("n", "<leader>dl", ":Telescope diagnostics<cr>", { buffer = 0 }) -- list of errors

    keymap("n", "<leader>r", vim.lsp.buf.rename, { buffer = 0 })
end

mason_lsp.setup_handlers({
    function(server_name)
        lspconfig[server_name].setup({ on_attach = lsp_on_attach })
    end
})

-- setup installer
local mason = require("mason")
local mason_lsp = require("mason-lspconfig")
local mason_dap = require("mason-nvim-dap")
local lsp_signature = require("lsp_signature")
local neodev = require("neodev")

neodev.setup({})

vim.lsp.set_log_level("error")

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

-- completion + icons
local lspconfig = require("lspconfig")

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
keymap("n", "gs", vim.lsp.buf.hover, { buffer = 0 })                                 -- show info
keymap("n", "gd", vim.lsp.buf.definition, { buffer = 0 })                            -- go to definition
keymap("n", "gt", vim.lsp.buf.type_definition, { buffer = 0 })                       -- go to type definition
keymap("n", "gi", vim.lsp.buf.implementation, { buffer = 0 })                        -- go to implementation

keymap("n", "<leader>dl", ":Lspsaga show_workspace_diagnostics<CR>", { buffer = 0 }) -- list of errors

-- formatting on save
local formatters = {}
local formatters_by_ft = {}
local known_bin = {
    cmakelang = "cmake-format",
}
local formatter_config = {}

local mason_registry = require("mason-registry")
local conform = require("conform")

for _, pkg in pairs(mason_registry.get_installed_packages()) do
    for _, type in pairs(pkg.spec.categories) do
        if type ~= "Formatter" then
            goto continue
        end

        local config = conform.get_formatter_config(pkg.spec.name)

        -- not supported formatter
        if not config then
            local bin = known_bin[pkg.spec.name]

            if not bin then
                goto continue
            end

            config = {
                command = bin,
                args = { "$FILENAME" },
                stdin = true,
                require_cwd = false,
            }
        end

        local config_func = formatter_config[pkg.spec.name]

        formatters[pkg.spec.name] = config_func and config_func(config) or config

        for _, file_type in pairs(pkg.spec.languages) do
            local ft = string.lower(file_type)

            formatters_by_ft[ft] = formatters_by_ft[ft] or {}
            table.insert(formatters_by_ft[ft], pkg.spec.name)
        end

        ::continue::
    end
end

conform.setup({
    formatters_by_ft = formatters_by_ft,
    formatters = formatters,

    format_on_save = {
        timeout_ms = 500,
        lsp_format = "last",
    },
})

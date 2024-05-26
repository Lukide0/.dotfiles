local telescope = require("telescope")
local harpoon = require("harpoon")

local builtin = require("telescope.builtin")
local keymap = vim.keymap.set

telescope.setup({
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
        },
    },
})

harpoon.setup({})

local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
    local finder = function()
        local paths = {}
        for _, item in ipairs(harpoon_files.items) do
            table.insert(paths, item.value)
        end

        return require("telescope.finders").new_table({
            results = paths,
        })
    end

    require("telescope.pickers")
        .new({}, {
            prompt_title = "Harpoon",
            finder = finder(),
            previewer = conf.file_previewer({}),
            sorter = conf.generic_sorter({}),
            attach_mappings = function(prompt_bufnr, map)
                map("i", "<A-d>", function()
                    local state = require("telescope.actions.state")
                    local selected_entry = state.get_selected_entry()
                    local current_picker = state.get_current_picker(prompt_bufnr)

                    table.remove(harpoon_files.items, selected_entry.index)
                    current_picker:refresh(finder())
                end)

                return true
            end,
        })
        :find()
end

telescope.load_extension("file_browser")
telescope.load_extension("ui-select")

-- find files
keymap("n", "<leader>f", builtin.find_files, {})
-- harpoon
keymap("n", "<leader>ls", function()
    toggle_telescope(harpoon:list())
end, {})

keymap("n", "<leader>la", function()
    harpoon:list():add()
end, {})

-- file browser
keymap("n", "<leader>e", ":Telescope file_browser<CR>", {})

-- show code actions
keymap("n", "<leader>da", vim.lsp.buf.code_action)

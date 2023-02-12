local opts = { noremap = true, silent = true }

-- shorten function name
local keymap = vim.keymap.set

-- remap space as leader key
vim.g.mapleader = " "

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize +2<cr>", opts)
keymap("n", "<C-Down>", ":resize -2<cr>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<cr>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<cr>", opts)

-- Insert
-- fast escape
keymap("i", "jj", "<ESC>", opts)

-- Visual
-- better indentation
keymap("v", ">", ">gv", opts)
keymap("v", "<", "<gv", opts)

-- move text up and down
keymap("n", "<A-j>", ":m .+1<cr>", opts)
keymap("n", "<A-k>", ":m .-2<cr>", opts)

keymap("v", "<A-j>", ":m '>+1<cr>gv", opts)
keymap("v", "<A-k>", ":m '<-2<cr>gv", opts)

-- don't override yanked text in the register with deleted
keymap("v", "p", '"_dP', opts)

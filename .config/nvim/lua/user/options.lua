vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard

-- completion menu
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.cmdheight = 1

vim.opt.conceallevel = 0

-- file options
vim.opt.fileencoding = "utf-8"
vim.opt.swapfile = true
vim.opt.backup = false -- don't make a backup before overwriting a file
vim.opt.writebackup = false
vim.opt.updatetime = 5000

-- search options
vim.opt.hlsearch = true -- show all matches on previous search
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.incsearch = true

-- indentation
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

-- GUI options
vim.wo.fillchars = "eob: "
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.guifont = "monospace:h17"
vim.opt.signcolumn = "yes"
vim.opt.wrap = false

vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 8

vim.opt.laststatus = 2
vim.opt.splitbelow = true -- force all horizontal splits to go below current window
vim.opt.splitright = true -- force all vertical splits to go to the right of current window
vim.opt.mouse = "a" -- enable mouse support

vim.opt.timeoutlen = 750

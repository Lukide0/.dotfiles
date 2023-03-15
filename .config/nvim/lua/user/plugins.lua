-- Packer boostrap
local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({
			"git",
			"clone",
			"--depth",
			"1",
			"https://github.com/wbthomason/packer.nvim",
			install_path,
		})
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local PACKER_BOOSTRAP = ensure_packer()

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PackerCompile
    augroup end 
]])

-- check if packer is installed
local packer_is_ok, packer = pcall(require, "packer")
if not packer_is_ok then
	print("Packer not found")
	return
end

-- plugins
return packer.startup(function(use)
	use("wbthomason/packer.nvim")

	use({
		"goolord/alpha-nvim",
		requires = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("alpha").setup(require("alpha.themes.dashboard").config)
		end,
	})

	-- git
	use({
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	})

	-- treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			local ts_update = require("nvim-treesitter.install").update({
				with_sync = true,
			})
			ts_update()
		end,
	})
	use("nvim-treesitter/nvim-treesitter-context")

	-- colorscheme
	use("navarasu/onedark.nvim")

	-- telescope
	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/plenary.nvim" } },
	})
	-- sidebar
	use({ "nvim-tree/nvim-tree.lua", requires = { "nvim-tree/nvim-web-devicons" } })
	-- statusline
	use("nvim-lualine/lualine.nvim")

	-- completion
	use("hrsh7th/nvim-cmp") -- core
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-path") -- file paths
	use("saadparwaiz1/cmp_luasnip") -- snippet completions

	-- snippets
	use("L3MON4D3/LuaSnip")

	-- icons
	use("onsails/lspkind.nvim")

	-- LSP
	use("neovim/nvim-lspconfig") -- Configurations for Nvim LSP
	use("williamboman/mason.nvim") -- package manager
	use("williamboman/mason-lspconfig.nvim")
	use({
		"jose-elias-alvarez/null-ls.nvim",
		requires = { { "nvim-lua/plenary.nvim" } },
	})
	use("jay-babu/mason-null-ls.nvim")

	use({ "romgrk/barbar.nvim", wants = "nvim-web-devicons" })

	if PACKER_BOOSTRAP then
		require("packer").sync()
	end
end)

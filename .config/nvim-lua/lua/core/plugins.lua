local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

-- returns the require for use in `config` parameter of packer's use
-- expects the name of the config file
local function get_config(name)
  return string.format('require("config/%s")', name)
end

if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- Install your plugins here
return packer.startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- An implementation of the Popup API from vim in Neovim
  -- Useful lua function used ny lots of plugins
  use {
    "nvim-telescope/telescope.nvim",
    requires = { { "nvim-lua/popup.nvim" }, { "nvim-lua/plenary.nvim" } },
    config = get_config("telescope"),
  }

  use { "jvgrootveld/telescope-zoxide" }
  use { "crispgm/telescope-heading.nvim" }
  use { "nvim-telescope/telescope-symbols.nvim" }
  use { "nvim-telescope/telescope-file-browser.nvim" }
  use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }
  use { "nvim-telescope/telescope-packer.nvim" }
  use { "nvim-telescope/telescope-ui-select.nvim" }
  use { "rcarriga/nvim-notify", config = get_config("notify") }

  use { "kyazdani42/nvim-tree.lua", config = get_config("nvim-tree") }

  use { "numToStr/Navigator.nvim", config = get_config("navigator") }

  use {
    'akinsho/nvim-bufferline.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    event = 'BufRead',
    config = get_config("bufferline")
  }

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    event = 'VimEnter',
    config = get_config("lualine")
  }

  use { "windwp/nvim-autopairs", config = get_config("autopairs") }

  use {
    "goolord/alpha-nvim",
    requires = { "kyazdani42/nvim-web-devicons" },
    config = get_config("alpha"),
  }

  use {
    'lukas-reineke/indent-blankline.nvim',
    event = "BufRead",
    config = get_config("indent-blankline")
  }

  use{
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "f3fora/cmp-spell",
      "hrsh7th/cmp-calc",
      "lukas-reineke/cmp-rg",
      "hrsh7th/cmp-nvim-lsp-signature-help",
    },
    config = get_config("cmp"),
  }

  use{
    "nvim-treesitter/nvim-treesitter",
    config = get_config("treesitter"),
    run = ":TSUpdate",
  }

  use 'nvim-treesitter/nvim-treesitter-textobjects'

  use 'RRethy/nvim-treesitter-endwise'

  use { "ahmedkhalf/project.nvim", config = get_config("project") }

  use 'folke/zen-mode.nvim'

  -- Colorschemes
  use { 'folke/tokyonight.nvim', config = get_config("colorscheme") }
  -- use 'lunarvim/darkplus.nvim'

  -- which key
  use { 'folke/which-key.nvim', config = get_config("which-key") }

  -- Terminal Integration
  use { 'akinsho/nvim-toggleterm.lua', tag = 'v2.*', config = get_config("toggleterm") }

  -- requirement for Neogit
  use({
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
    },
    config = get_config("diffview"),
  })

  use({
    "TimUntersberger/neogit",
    requires = { "nvim-lua/plenary.nvim" },
    cmd = "Neogit",
    config = get_config("neogit"),
  })

  use({ "f-person/git-blame.nvim", config = get_config("git-blame") })

  use({ "tpope/vim-fugitive" }) -- yeah this is not lua but one of the best Vim plugins ever

  use("p00f/nvim-ts-rainbow")

  use {
    "lewis6991/gitsigns.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = get_config("gitsigns"),
  }

  -- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)


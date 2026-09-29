vim.pack.add({
-- Telescope
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-telescope/telescope.nvim",

  -- Git
  "https://github.com/kdheepak/lazygit.nvim",

  -- Treesitter
  "https://github.com/nvim-treesitter/nvim-treesitter",

  -- Mason
  "https://github.com/mason-org/mason.nvim.git",

  -- LSP
  "https://github.com/neovim/nvim-lspconfig",

  --Colorschemes
  "https://github.com/sainnhe/everforest.git",

  -- Code completion
  "https://github.com/saghen/blink.lib",
  "https://github.com/saghen/blink.cmp",
  "https://github.com/windwp/nvim-autopairs",

  -- Keymaps
  "https://github.com/folke/which-key.nvim",

  -- File system
 "https://github.com/stevearc/oil.nvim",

 -- UI
 "https://github.com/MunifTanjim/nui.nvim.git",
 "https://github.com/folke/noice.nvim.git",
 -- "https://github.com/folke/snacks.nvim",

 -- Navigation
 {
    src = "https://github.com/ThePrimeagen/harpoon",
    version = "harpoon2",
  },

  -- Terminal
  "https://github.com/akinsho/toggleterm.nvim.git",

    "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/SmiteshP/nvim-navic",
})

require("config.plugins.telescope")
require("config.plugins.lazygit")
require("config.plugins.treesitter")
require("config.plugins.mason")
require("config.plugins.lsp")
require("config.plugins.blink")
require("config.plugins.which-key")
require("config.plugins.oil")
require("config.plugins.nvim-autopairs")
require("config.plugins.colorscheme")
require("config.plugins.noice")
-- require("config.plugins.snacks")
require("config.plugins.harpoon")
require("config.plugins.toggleterm")
require("config.plugins.lualine")

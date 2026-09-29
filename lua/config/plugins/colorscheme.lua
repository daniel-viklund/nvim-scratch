vim.pack.add({
  "https://github.com/sainnhe/everforest.git",
  { src = "https://github.com/rose-pine/neovim", name = "rose-pine" },
  "https://github.com/ramojus/mellifluous.nvim.git",
  "https://github.com/slugbyte/lackluster.nvim.git",
  "https://github.com/rktjmp/lush.nvim.git",
  "https://github.com/zenbones-theme/zenbones.nvim.git",
  "https://github.com/morhetz/gruvbox.git",
})

require("rose-pine").setup()
vim.cmd("colorscheme rose-pine")

-- require("mellifluous").setup({}) -- optional, see configuration section.
-- vim.cmd("colorscheme mellifluous")

-- vim.cmd.colorscheme("gruvbox")

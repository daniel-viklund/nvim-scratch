vim.pack.add({
  "https://github.com/sainnhe/everforest.git",
  { src = "https://github.com/rose-pine/neovim", name = "rose-pine" },
})

require("rose-pine").setup()
vim.cmd("colorscheme rose-pine")

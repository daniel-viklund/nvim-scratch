vim.pack.add({
  "https://github.com/stevearc/oil.nvim",
})

require("oil").setup({
  keymaps = {
    ["q"] = "actions.close",
  },
})

vim.keymap.set("n", "-", "<cmd>Oil<CR>", {
  desc = "Open parent directory",
})

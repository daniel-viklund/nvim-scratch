require("oil").setup({
  keymaps = {
    ["q"] = "actions.close",
  },
})

vim.keymap.set("n", "-", "<cmd>Oil<CR>", {
  desc = "Open parent directory",
})

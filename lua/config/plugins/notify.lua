vim.pack.add({
  "https://github.com/rcarriga/nvim-notify",
})

local notify = require("notify")
notify.setup({
  timeout = 8000,
  stages = "static",
  render = "wrapped-default",
  max_width = function()
    return math.max(20, math.floor(vim.o.columns * 0.4))
  end,
  top_down = true,
})

vim.notify = notify

vim.keymap.set("n", "<leader>nh", "<cmd>Noice history<CR>", { desc = "Message history" })
vim.keymap.set("n", "<leader>nd", function()
  notify.dismiss({ silent = true, pending = true })
end, { desc = "Dismiss notifications" })

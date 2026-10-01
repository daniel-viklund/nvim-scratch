vim.pack.add({
  "https://github.com/akinsho/toggleterm.nvim.git",
})

require("toggleterm").setup({
  direction = "horizontal",
  size = 15,
  shade_terminals = false,

  start_in_insert = true,
  persist_size = true,
  persist_mode = true,

  close_on_exit = true,

  float_opts = {
    border = "rounded",
  },
})

-- Terminal mode mappings
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = { "term://*#toggleterm#*", "term://*::toggleterm::*" },
  callback = function()
    local opts = { buffer = 0 }

    vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)

    vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
  end,
})

-- Numbered terminals
vim.keymap.set("n", "<leader>t1", "<cmd>1ToggleTerm<CR>", {
  desc = "Terminal 1",
})

vim.keymap.set("n", "<leader>t2", "<cmd>2ToggleTerm<CR>", {
  desc = "Terminal 2",
})

vim.keymap.set("n", "<leader>t3", "<cmd>3ToggleTerm<CR>", {
  desc = "Terminal 3",
})

-- Terminal 4 is reserved for the project runner.
require("config.runner").setup()

-- Create a fresh terminal
vim.keymap.set("n", "<leader>tn", function()
  local terminals = require("toggleterm.terminal")
  local id = 1
  while id == 4 or terminals.get(id, true) do id = id + 1 end
  terminals.Terminal:new({ count = id }):toggle()
end, {
  desc = "New terminal",
})

-- Choose from existing terminals
vim.keymap.set("n", "<leader>ts", "<cmd>TermSelect<CR>", {
  desc = "Select terminal",
})

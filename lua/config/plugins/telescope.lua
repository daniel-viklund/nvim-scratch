vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-telescope/telescope.nvim",
})

local telescope = require("telescope")

telescope.setup({
  defaults = {
    layout_strategy = "vertical",
    layout_config = {
      vertical = {
        mirror = false,
        preview_cutoff = 10,
        preview_height = function(picker, _, height)
          -- Split the content 70/30 after reserving the prompt and borders/gaps.
          local spacing = picker.window.border == false and 2 or 6
          return math.max(1, math.floor((height - spacing - 1) * 0.7))
        end,
      },
    },
  },
})

local builtin = require("telescope.builtin")

vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'Telescope live grep' })

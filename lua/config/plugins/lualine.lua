vim.pack.add({
  "https://github.com/SmiteshP/nvim-navic",
  "https://github.com/nvim-lualine/lualine.nvim",
})

local navic = require("nvim-navic")

require("lualine").setup({
  options = {
    theme = "auto",
    globalstatus = false,

    disabled_filetypes = {
      winbar = {
        "toggleterm",
      },
    },
  },

  sections = {},
  inactive_sections = {},

  winbar = {
    lualine_x = { "branch", "diff", "diagnostics" },
    lualine_z = { "mode" },
    lualine_c = {
      {
        "filename",
        path = 1,
      },

      {
        function()
          if navic.is_available() then
            local location = navic.get_location()

            if location ~= "" then
              return "> " .. location
            end
          end

          return " "
        end,
      },
    },
  },

  inactive_winbar = {
    lualine_c = {
      {
        "filename",
        path = 1,
      },
    },
  },
})

-- Keep status information in the winbar without an empty bar at the bottom.
vim.opt.laststatus = 0

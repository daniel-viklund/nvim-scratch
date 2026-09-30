vim.pack.add({
  "https://github.com/rcarriga/nvim-notify",
})

local notify = require("notify")

local function match_editor_background()
  local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  for _, level in ipairs({ "ERROR", "WARN", "INFO", "DEBUG", "TRACE" }) do
    for _, part in ipairs({ "Body", "Border", "Icon", "Title" }) do
      local name = "Notify" .. level .. part
      local highlight = vim.api.nvim_get_hl(0, { name = name, link = false })
      highlight.bg = normal.bg or "NONE"
      vim.api.nvim_set_hl(0, name, highlight)
    end
  end
end

match_editor_background()
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("NotifyEditorBackground", { clear = true }),
  callback = match_editor_background,
})

notify.setup({
  background_colour = "Normal",
  timeout = 2500,
  stages = "static",
  render = "compact",
  minimum_width = 15,
  max_width = function()
    return math.min(42, math.max(15, math.floor(vim.o.columns * 0.3)))
  end,
  -- Keep popups brief; Noice history retains the full message.
  max_height = 2,
  on_open = function(win)
    vim.api.nvim_win_set_config(win, { border = "rounded" })
  end,
  top_down = true,
})

vim.notify = notify

vim.api.nvim_create_user_command("NotifyDemo", function(args)
  local examples = {
    info = { "Your changes were saved.", vim.log.levels.INFO },
    warn = { "Connection is slow.", vim.log.levels.WARN },
    error = { "Could not save the file.", vim.log.levels.ERROR },
  }
  local kinds = args.args == "" and { "info", "warn", "error" } or { args.args }
  if not examples[kinds[1]] then
    vim.notify("Use :NotifyDemo [info|warn|error]", vim.log.levels.WARN)
    return
  end
  for _, kind in ipairs(kinds) do
    local example = examples[kind]
    vim.notify(example[1], example[2], { title = "Demo", timeout = 5000 })
  end
end, {
  nargs = "?",
  desc = "Preview notification styles (sample messages)",
  complete = function()
    return { "info", "warn", "error" }
  end,
})

vim.keymap.set("n", "<leader>nh", "<cmd>Noice history<CR>", { desc = "Message history" })
vim.keymap.set("n", "<leader>nd", function()
  notify.dismiss({ silent = true, pending = true })
end, { desc = "Dismiss notifications" })

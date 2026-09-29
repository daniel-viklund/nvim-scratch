local treesitter = require("nvim-treesitter")

treesitter.setup()

treesitter.install({
  "lua",
  "bash",
  "json",
  "javascript",
  "typescript",
  "tsx",
  "html",
  "css",
  "markdown",
  "markdown_inline",
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local ok = pcall(vim.treesitter.start, args.buf)

    if not ok then
      return
    end

    -- Treesitter folding
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo.foldlevel = 99
  end,
})

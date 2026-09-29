local treesitter = require("nvim-treesitter")

treesitter.setup()

-- tree-sitter-cli otherwise defaults to MSVC on Windows.
if vim.fn.has("win32") == 1 and not vim.env.CC and vim.fn.executable("gcc") == 1 then
  vim.env.CC = "gcc"
end

local installation = treesitter.install({
  "lua",
  "rust",
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

return installation

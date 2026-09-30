vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason.nvim.git",
  "https://github.com/mason-org/mason-lspconfig.nvim",
})

require("mason").setup()

local opts = {
  -- Use LSPConfig names here; mason-lspconfig maps them to Mason packages.
  ensure_installed = { "lua_ls", "rust_analyzer", "jsonls" },
  -- Also enable mapped servers installed through the Mason UI.
  automatic_enable = true,
}

require("mason-lspconfig").setup(opts)

return opts

vim.opt.clipboard = "unnamedplus"
-- Use four spaces for Tab, automatic indentation, and existing tab characters.
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = -1 -- Follow shiftwidth when inserting/deleting indentation.
vim.opt.number = true
vim.opt.termguicolors = true
vim.opt.winborder = "rounded"
vim.opt.fillchars = {
  eob = " ",
}
vim.opt.signcolumn = "yes"
vim.opt.hlsearch = true
vim.opt.incsearch = true -- keep search matches highlighted afterward
vim.opt.guicursor = "n-v-i-c:block"

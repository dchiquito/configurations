-- show line numbers
vim.opt.number = true

-- enable mouse support
vim.opt.mouse = "a"

-- lines wrap
vim.opt.wrap = true
-- wrapped lines keep indentation
vim.opt.breakindent = true

-- newlines automatically match the previous level of indentation
vim.opt.autoindent = true
-- the tab key actually inserts spaces
vim.opt.expandtab = true
-- the tab key inserts two spaces
vim.opt.tabstop = 2
-- adjusting indentation increments by two spaces
vim.opt.shiftwidth = 2

-- use the system clipboard for the copy buffer
vim.cmd("set clipboard+=unnamedplus")

-- set the leader key
vim.g.mapleader = " "



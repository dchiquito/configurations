
-- save shortcut
vim.keymap.set('n', '<leader>w', '<cmd>write<cr>', {desc = 'Save'})
vim.keymap.set({'', 'i', 'c'}, '<C-s>', '<cmd>write<cr>', {desc = 'Save'})

-- toggle nvim-tree
vim.keymap.set('n', '<leader>a', '<cmd>NvimTreeToggle<cr>', {desc = 'Toggle nvim-tree'})

-- switch tabs
vim.keymap.set({'', 'i', 'c'}, '<C-H>', '<cmd>bp<cr>', {desc = 'Previous buffer'})
vim.keymap.set({'', 'i', 'c'}, '<C-L>', '<cmd>bn<cr>', {desc = 'Next buffer'})

-- switch windows
vim.keymap.set('n', '<S-H>', '<c-W>h', {desc = 'Left window'})
vim.keymap.set('n', '<S-J>', '<C-W>j', {desc = 'Down window'})
vim.keymap.set('n', '<S-K>', '<c-W>k', {desc = 'Up window'})
vim.keymap.set('n', '<S-L>', '<C-W>l', {desc = 'Right window'})
-- close window
vim.keymap.set('n', '<C-w>', ':Bdelete<cr>', {desc = 'Close buffer'})

-- Telescope
vim.keymap.set('n', '<C-P>', '<cmd>Telescope find_files<cr>', {desc = 'Search files'})





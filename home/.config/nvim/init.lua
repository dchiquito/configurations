-- Cribbing from https://vonheikemen.github.io/devlog/tools/build-your-first-lua-config-for-neovim/


--------------------------------------
-- Generic vim options and settings --
--------------------------------------


-- show line numbers
vim.opt.number = true

-- enable mouse support
vim.opt.mouse = 'a'

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
vim.cmd('set clipboard+=unnamedplus')

-- set the leader key
vim.g.mapleader = ' '

-- vertical splits for help
vim.cmd(':cabbrev h vert h')
vim.cmd(':cabbrev help vert help')


------------------------------------
-- Neovide specific configuration --
------------------------------------


if vim.fn.exists('g:neovide') then
  vim.opt.guifont = 'Cousine,Fira Mono:h8'
end


------------------------
-- Keyboard shortcuts --
------------------------


-- save shortcut
vim.keymap.set('n', '<leader>w', '<cmd>write<cr>', {desc = 'Save'})
vim.keymap.set({'', 'i', 'c'}, '<C-s>', '<cmd>write<cr>', {desc = 'Save'})

-- toggle nvim-tree
vim.keymap.set('n', '<leader>a', '<cmd>NvimTreeToggle<cr>', {desc = 'Toggle nvim-tree'})

-- switch tabs
vim.keymap.set({'', 'i', 'c'}, '<C-H>', '<cmd>bp<cr>', {desc = 'Previous buffer'})
vim.keymap.set({'', 'i', 'c'}, '<C-L>', '<cmd>bn<cr>', {desc = 'Next buffer'})

-- go fast
vim.keymap.set({'', 'i', 'c'}, '<C-J>', '<C-D>', {})
vim.keymap.set({'', 'i', 'c'}, '<C-K>', '<C-U>', {})

-- switch windows
vim.keymap.set('n', '<S-H>', '<c-W>h', {desc = 'Left window'})
vim.keymap.set('n', '<S-J>', '<C-W>j', {desc = 'Down window'})
vim.keymap.set('n', '<S-K>', '<c-W>k', {desc = 'Up window'})
vim.keymap.set('n', '<S-L>', '<C-W>l', {desc = 'Right window'})
-- close window
vim.keymap.set('n', '<C-w>', ':Bdelete<cr>', {desc = 'Close buffer'})

-- Telescope
vim.keymap.set('n', '<C-P>', '<cmd>Telescope find_files<cr>', {desc = 'Search files'})


--------------------------
-- Diagnostics settings --
--------------------------


-- LSP Diagnostics Options Setup 
local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = ''
  })
end

sign({name = 'DiagnosticSignError', text = ''})
sign({name = 'DiagnosticSignWarn', text = ''})
sign({name = 'DiagnosticSignHint', text = ''})
sign({name = 'DiagnosticSignInfo', text = ''})

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = true,
    underline = true,
    severity_sort = false,
    float = {
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})

-- automatically open diagnostic info on cursor hover
vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])
-- lower the cursor hover time from 4s to 1s
vim.opt.updatetime = 1000


--------------------
-- Packer Plugins --
--------------------


-- Install packer for plugin management
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  print('Installing packer...')
  local packer_url = 'https://github.com/wbthomason/packer.nvim'
  vim.fn.system({'git', 'clone', '--depth', '1', packer_url, install_path})
  print('Done.')

  vim.cmd('packadd packer.nvim')
end
packer = require('packer').startup(function(use)
  -- Packer manages itself
  use 'wbthomason/packer.nvim'


  -- .editorconfig file support
  use 'editorconfig/editorconfig-vim'
  

  -- Enhanced window closing ability
  use 'moll/vim-bbye'


  -- Show buffers as tabs along the top of the screen
  use {'akinsho/bufferline.nvim', requires = 'nvim-tree/nvim-web-devicons'}


  -- A color scheme like VSCodes
  use 'martinsione/darkplus.nvim'


  ---------------------
  -- Code completion --
  ---------------------

  -- Completion framework:
  use 'hrsh7th/nvim-cmp' 

  -- LSP completion source:
  use 'hrsh7th/cmp-nvim-lsp'

  -- Useful completion sources:
  use 'hrsh7th/cmp-nvim-lua'
  use 'hrsh7th/cmp-nvim-lsp-signature-help'
  use 'hrsh7th/cmp-path'                              
  use 'hrsh7th/cmp-buffer'                            
  -- I'm not using snippets right now, but I might want to later
  -- use 'hrsh7th/cmp-vsnip'                             
  -- use 'hrsh7th/vim-vsnip'


  -- Nicer bottom status bar
  use {'nvim-lualine/lualine.nvim', requires = 'nvim-tree/nvim-web-devicons'}


  -- Mason, manages Language Server Protocol provider installation
  -- See the various :MasonInstall commands
  use 'williamboman/mason.nvim'    
  use 'williamboman/mason-lspconfig.nvim'


  -- Nvim-tree, a file browser
  use 'nvim-tree/nvim-web-devicons'
  use 'nvim-tree/nvim-tree.lua'


  -- Rust tooling support
  -- Cribbed from https://rsdlt.github.io/posts/rust-nvim-ide-guide-walkthrough-development-debug/
  use 'simrat39/rust-tools.nvim'
  use 'neovim/nvim-lspconfig' 


  -- Telescope, a file/anything search utility
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

  
  -- Treesitter
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
end)

-- Attempt an installation during every launch
-- For a fresh setup, no plugins will be configured on the first launch, but packer will install everything for the second launch.
packer.install()


---------------------------------
-- Packer plugin configuration --
---------------------------------

-- All of this stuff will fail until the plugins are installed with :PackerInstall


-- bufferline tab rendering options
require('bufferline').setup({
  options = {
    offsets = { { filetype = "NvimTree", padding = 0, separator = true } },
    separator_style = "slant"
  },
  highlights = {
    buffer_selected = {
      italic = false,
    },
  },
})


-- darkplus: set the colorscheme
vim.cmd('colorscheme darkplus')


-- Lualine configuration
-- disable the default vim footer
vim.opt.showmode = false
require('lualine').setup({
  options = {
    theme = 'onedark',
    icons_enabled = true,
    component_separators = '|',
    section_separators = '',
  },
})


-- Mason setup
require('mason').setup()


-- Nvim-tree settings
require('nvim-tree').setup({
  hijack_cursor = true,
  sync_root_with_cwd = true,
  actions = {
    open_file = {
      quit_on_open = true,
    },
  },
  filters = {
    dotfiles = true,
  }
})



-- Rust-tools keybinds
local rt = require("rust-tools")
rt.setup({
  server = {
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<leader>h", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>j", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
})


-- Telescope
require('telescope').setup({
  extensions = {
    fzf = {
     fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  }
})
require('telescope').load_extension('fzf')








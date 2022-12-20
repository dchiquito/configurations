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

-- format on save
-- TODO figure out how avoid obnoxious "couldn't format" message on non-.rs files
vim.cmd([[autocmd BufWritePre *.rs lua vim.lsp.buf.format({ async = false })]])

------------------------------------
-- Neovide specific configuration --
------------------------------------


if vim.fn.exists('g:neovide') then
  vim.opt.guifont = 'Cousine,Fira Mono:h8'
  vim.g.neovide_hide_mouse_when_typing = true
  vim.opt.title = true
  vim.opt.titlestring = vim.env.PWD
end


--------------------------------
-- Keyboard shortcuts/hotkeys --
--------------------------------


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

-- hop
vim.keymap.set('', '<leader>n', '<cmd>HopWord<cr>', {desc = 'Hop to a word'})
vim.keymap.set('', '<leader>m', '<cmd>HopLineStart<cr>', {desc = 'Hop to a line'})
vim.keymap.set('', '<leader>l', '<cmd>HopWordCurrentLine<cr>', {desc = 'Hop to a word on the current line'})

-- comment/uncomment
-- linewise commenting
vim.keymap.set({'n', 'i', 'c'}, '<C-_>', function()
  require('Comment.api').toggle.linewise.current()
end, {desc = 'Toggle comments'})
vim.keymap.set('v', '<C-_>', function()
  local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
  vim.api.nvim_feedkeys(esc, 'nx', false)
  require('Comment.api').toggle.linewise(vim.fn.visualmode())
end, {desc = 'Toggle comments'})


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

--Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force to select one from the menu
-- shortness: avoid showing extra messages when using completion
-- updatetime: set updatetime for CursorHold
vim.opt.completeopt = {'menuone', 'noselect', 'noinsert', 'preview'}
vim.opt.shortmess = vim.opt.shortmess + { c = true}


--------------------
-- Packer Plugins --
--------------------

-- Important note:
-- You must run :PackerSync to pick up any changes made to the configurations.

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
  use {
    'akinsho/bufferline.nvim',
    requires = 'nvim-tree/nvim-web-devicons',
    config = function()
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
    end
  }


  -- A color scheme like VSCodes
  use {'martinsione/darkplus.nvim', config = [[ vim.cmd('colorscheme darkplus') ]]}


  -- Comment/uncomment commands
  -- hotkeys are defined in the hotkeys section
  use {'numToStr/Comment.nvim', config = function()
    require('Comment').setup({
      mappings = false
    })
  end}
  

  ---------------------
  -- Code completion --
  ---------------------

  -- Completion framework:
  use {'hrsh7th/nvim-cmp', config = function()
    local cmp = require'cmp'
    cmp.setup({
      -- Enable LSP snippets
      snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
      },
      mapping = {
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        ['<C-j>'] = cmp.mapping.select_next_item(),
        -- Add tab support
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<C-S-f>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        })
      },
      -- Installed sources:
      sources = {
        { name = 'path' },                              -- file paths
        { name = 'nvim_lsp', keyword_length = 3 },      -- from language server
        { name = 'nvim_lsp_signature_help'},            -- display function signatures with current parameter emphasized
        { name = 'nvim_lua', keyword_length = 2},       -- complete neovim's Lua runtime API such vim.lsp.*
        { name = 'buffer', keyword_length = 2 },        -- source current buffer
        { name = 'vsnip', keyword_length = 2 },         -- nvim-cmp source for vim-vsnip 
        { name = 'calc'},                               -- source for math calculation
      },
      window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
      },
      formatting = {
          fields = {'menu', 'abbr', 'kind'},
          format = function(entry, item)
              local menu_icon ={
                  nvim_lsp = 'λ',
                  vsnip = '⋗',
                  buffer = 'Ω',
                  path = '🖫',
              }
              item.menu = menu_icon[entry.source.name]
              return item
          end,
      },
    })
  end}

  -- LSP completion source:
  use 'hrsh7th/cmp-nvim-lsp'

  -- Useful completion sources:
  use 'hrsh7th/cmp-nvim-lua'
  use 'hrsh7th/cmp-nvim-lsp-signature-help'
  use 'hrsh7th/cmp-path'                              
  use 'hrsh7th/cmp-buffer'                            
  use 'hrsh7th/cmp-vsnip'                             
  use 'hrsh7th/vim-vsnip'

  
  -- Git indicators
  use {'lewis6991/gitsigns.nvim', config = [[ require('gitsigns').setup() ]]}


  -- Hop
  use {
    'phaazon/hop.nvim',
    branch = 'v2', -- optional but strongly recommended
    config = function()
      require('hop').setup({ keys = 'etovxqpdygfblzhckisuran' })
    end
  }

  -- Nicer bottom status bar
  use {
    'nvim-lualine/lualine.nvim',
    requires = 'nvim-tree/nvim-web-devicons',
    config = function()
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
    end,
  }


  -- Mason, manages Language Server Protocol provider installation
  -- See the various :MasonInstall commands
  use {'williamboman/mason.nvim', config = [[ require('mason').setup() ]]}
  use 'williamboman/mason-lspconfig.nvim'


  -- Nvim-tree, a file browser
  use 'nvim-tree/nvim-web-devicons'
  use {'nvim-tree/nvim-tree.lua', config = function()
    require('nvim-tree').setup({
      hijack_cursor = true,
      sync_root_with_cwd = true,
      actions = {
        open_file = {
          quit_on_open = true,
        },
      },
      filters = {
        dotfiles = false,
      },
      git = {
        ignore = false,
      },
    })
  end}


  -- Rust tooling support
  -- Cribbed from https://rsdlt.github.io/posts/rust-nvim-ide-guide-walkthrough-development-debug/
  use {'simrat39/rust-tools.nvim', config = function()
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
  end}
  use 'neovim/nvim-lspconfig' 


  -- Telescope, a file/anything search utility
  use {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.0',
    requires = { {'nvim-lua/plenary.nvim'} },
    config = function()
      require('telescope').setup({
        extensions = {
          fzf = {
           fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true,  -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                             -- the default case_mode is "smart_case"
          }
        },
        -- sadly there is some kind of race condition where treesitter tries to do cleanup on the preview buffer after it has been partially cleaned up which throws errors whenever the file picker is closed.
        -- For now, preview must be disabled.
        defaults = {
          preview = false,
        },
      })
    end
  }
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make',
    config = [[ require('telescope').load_extension('fzf') ]],
  }

  
  -- Treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = { "javascript", "json", "lua", "markdown", "python", "rust", "toml", "typescript" },
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting=false,
        },
        ident = { enable = true }, 
        rainbow = {
          enable = true,
          extended_mode = true,
          max_file_lines = nil,
        }
      }
    end
  }

  -- TODO find a way to run this silently so that a manual :PackerSync isn't required after every configuration change
  -- require('packer').sync()
end)

-- Attempt an installation during every launch
-- For a fresh setup, no plugins will be configured on the first launch, but packer will install everything for the second launch.
packer.install()



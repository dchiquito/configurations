
-- Install packer for plugin management
-- Set INSTALL_PLUGINS when starting nvim to reload plugins
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local install_plugins = vim.env.INSTALL_PLUGINS or false

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  print('Installing packer...')
  local packer_url = 'https://github.com/wbthomason/packer.nvim'
  vim.fn.system({'git', 'clone', '--depth', '1', packer_url, install_path})
  print('Done.')

  vim.cmd('packadd packer.nvim')
  install_plugins = true
end

-- Invoke packer
require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'
	use 'martinsione/darkplus.nvim'
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  use 'editorconfig/editorconfig-vim'
	use 'nvim-tree/nvim-web-devicons'
	use 'kyazdani42/nvim-tree.lua'
	use {'nvim-lualine/lualine.nvim', requires = 'nvim-tree/nvim-web-devicons'}
  use {'akinsho/bufferline.nvim', requires = 'nvim-tree/nvim-web-devicons'}
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use 'moll/vim-bbye'

  if install_plugins then
    require('packer').sync()
  end
end)

-- If there are new plugins to install, stop here to avoid attempting to configure them while they install in the background.
if install_plugins then
  return
end

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

require('bufferline').setup({
  options = {
    offsets = { { filetype = "NvimTree", padding = 0, separator = true } }
  }
})

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



vim.cmd('colorscheme darkplus')

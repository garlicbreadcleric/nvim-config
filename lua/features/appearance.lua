local pkg = require('lib.pkg')
local env = require('lib.env')

local plugins = {}

pkg.add(plugins, {
  'scottmckendry/cyberdream.nvim',
  lazy = false,
  cond = not env.is_vscode,
  priority = 1000,
  config = function()
    -- vim.cmd.colorscheme('cyberdream')
  end,
})

pkg.add(plugins, {
  'rebelot/kanagawa.nvim',
  lazy = false,
  cond = not env.is_vscode,
  priority = 1000,
  config = function(_, opts)
    -- vim.cmd.colorscheme('kanagawa')
  end,
})

pkg.add(plugins, {
  'neanias/everforest-nvim',
  lazy = false,
  cond = not env.is_vscode,
  priority = 1000,
  opts = {
    background = 'hard',
  },
  config = function(_, opts)
    -- require('everforest').setup(opts)
    -- vim.cmd('colorscheme everforest')
  end,
})

pkg.add(plugins, {
  'ellisonleao/gruvbox.nvim',
  lazy = false,
  cond = not env.is_vscode,
  priority = 1000,
  config = function(_, opts)
    -- vim.o.background = 'light'
    -- vim.cmd('colorscheme gruvbox')
  end,
})

pkg.add(plugins, {
  'maxmx03/solarized.nvim',
  lazy = false,
  cond = not env.is_vscode,
  priority = 1000,
  ---@type solarized.config
  opts = {},
  config = function(_, opts)
    -- require('solarized').setup(opts)
    -- vim.cmd.colorscheme('solarized')
  end,
})

pkg.add(plugins, {
  'rose-pine/neovim',
  lazy = false,
  cond = not env.is_vscode,
  priority = 1000,
  name = 'rose-pine',
  config = function()
    -- vim.cmd('colorscheme rose-pine-dawn')
  end,
})

pkg.add(plugins, {
  'projekt0n/github-nvim-theme',
  name = 'github-theme',
  lazy = false,
  priority = 1000,
  config = function(_, opts)
    require('github-theme').setup(opts)
    vim.cmd('colorscheme github_light')
  end,
})

pkg.add(plugins, {
  'EdenEast/nightfox.nvim',
  lazy = false,
  priority = 1000,
  config = function(_, opts)
    -- vim.cmd('colorscheme nightfox')
  end,
})

pkg.add(plugins, {
  'folke/noice.nvim',
  event = 'VeryLazy',
  opts = {},
  dependencies = {
    'MunifTanjim/nui.nvim',
    'rcarriga/nvim-notify',
  },
})

if env.is_neovide then
  vim.o.guifont = 'JetBrainsMonoNL Nerd Font:h10'
  vim.g.neovide_padding_top = 10
  vim.g.neovide_padding_bottom = 10
  vim.g.neovide_padding_right = 10
  vim.g.neovide_padding_left = 10
  vim.g.neovide_floating_shadow = false
  vim.g.neovide_cursor_animate_in_insert_mode = false
end

return plugins

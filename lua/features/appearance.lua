local pkg = require('lib.pkg')
local env = require('lib.env')

local plugins = {}

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
  priority = 1001,
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

-- pkg.add(plugins, {
--   'stevearc/dressing.nvim',
--   lazy = false,
--   opts = {},
-- })

pkg.add(plugins, {
  'folke/noice.nvim',
  event = 'VeryLazy',
  opts = {
    -- add any options here
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    'MunifTanjim/nui.nvim',
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    'rcarriga/nvim-notify',
  },
})

if not env.is_vscode then
  vim.api.nvim_create_autocmd('FileType', {
    pattern = '*',
    callback = function()
      if vim.bo.filetype == 'markdown' and vim.bo.buftype ~= 'nofile' then
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.breakindent = true
        vim.opt_local.number = false
        vim.opt_local.signcolumn = 'no'
        vim.opt_local.textwidth = 80

        vim.api.nvim_buf_del_keymap(0, 'n', '[[')
        vim.api.nvim_buf_del_keymap(0, 'n', ']]')
      end
    end,
    group = vim.api.nvim_create_augroup('MarkdownSettings', { clear = true }),
  })
end

if env.is_neovide then
  vim.o.guifont = 'JetBrainsMonoNL Nerd Font:h10'
  vim.g.neovide_padding_top = 10
  vim.g.neovide_padding_bottom = 10
  vim.g.neovide_padding_right = 10
  vim.g.neovide_padding_left = 10
  vim.g.neovide_floating_shadow = false
end

return plugins

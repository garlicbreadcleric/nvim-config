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
    require('solarized').setup(opts)
    vim.cmd.colorscheme('solarized')
    -- vim.cmd('hi Normal guibg=NONE ctermbg=NONE')
  end,
})

pkg.add(plugins, {
  'stevearc/dressing.nvim',
  lazy = false,
  opts = {},
})

pkg.add(plugins, {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = function()
    local auto = require('lualine.themes.auto')
    local solarized_light = require('lualine.themes.solarized_light')
    auto.normal.b.fg = solarized_light.normal.c.fg
    auto.normal.b.bg = solarized_light.normal.c.bg
    return {
      options = {
        theme = auto,
        component_separators = '',
        section_separators = '',
      },
    }
  end,
  config = function(_, opts)
    require('lualine').setup(opts)
  end,
})

if env.is_vanilla then
  vim.api.nvim_create_autocmd('FileType', {
    pattern = '*',
    callback = function()
      if vim.bo.filetype == 'markdown' and vim.bo.buftype ~= 'nofile' then
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.breakindent = true
        vim.opt_local.number = false
        vim.opt_local.signcolumn = 'no'
      end
    end,
    group = vim.api.nvim_create_augroup('MarkdownSettings', { clear = true }),
  })
end

return plugins

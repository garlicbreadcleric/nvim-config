local pkg = require('lib.pkg')
local env = require('lib.env')

local plugins = {}

pkg.add(plugins, {
  'zk-org/zk-nvim',
  cond = not env.is_vscode and not env.is_windows,
  lazy = false,
  opts = {
    picker = 'snacks_picker',
  },
  config = function(_, opts)
    require('zk').setup(opts)
  end,
})

pkg.add(plugins, {
  'MeanderingProgrammer/render-markdown.nvim',
  cond = not env.is_vscode,
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' },
  opts = {},
})

pkg.add(plugins, {
  'roodolv/markdown-toggle.nvim',
  main = 'markdown-toggle',
  config = true,
  opts = {
    enable_autolist = true,
    box_table = { 'x' },
  },
  keys = {
    {
      '<cr>',
      function()
        require('markdown-toggle').autolist_cr()
      end,
      mode = { 'i' },
      ft = 'markdown',
    },
    {
      'o',
      function()
        require('markdown-toggle').autolist_down()
      end,
      mode = { 'n' },
      ft = 'markdown',
    },
    {
      'O',
      function()
        require('markdown-toggle').autolist_up()
      end,
      mode = { 'n' },
      ft = 'markdown',
    },
    {
      '<c-cr>',
      function()
        require('markdown-toggle').checkbox_cycle()
      end,
      mode = { 'n', 'v' },
      ft = 'markdown',
    },
  },
})

return plugins

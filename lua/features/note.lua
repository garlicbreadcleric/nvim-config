local pkg = require('lib.pkg')
local env = require('lib.env')

local plugins = {}

pkg.add(plugins, {
  'zk-org/zk-nvim',
  cond = not env.is_windows,
  lazy = false,
  opts = {
    picker = 'fzf_lua',
  },
  config = function(_, opts)
    require('zk').setup(opts)
  end,
})

pkg.add(plugins, {
  'MeanderingProgrammer/render-markdown.nvim',
  cond = env.is_vanilla,
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' },
  opts = {},
})

-- pkg.add(plugins, {
--   'oflisback/obsidian-bridge.nvim',
--   opts = {
--     obsidian_server_address = 'http://localhost:27123',
--     scroll_sync = true,
--     cert_path = nil,
--   },
--   main = 'obsidian-bridge',
--   config = true,
--   event = {
--     'BufReadPre *.md',
--     'BufNewFile *.md',
--   },
--   lazy = true,
--   dependencies = {
--     'nvim-lua/plenary.nvim',
--     'nvim-telescope/telescope.nvim',
--   },
-- })

return plugins

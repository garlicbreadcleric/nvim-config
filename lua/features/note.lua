local env = require('lib.env')

return {
  {
    'zk-org/zk-nvim',
    cond = not env.is_windows,
    lazy = false,
    opts = {
      picker = 'fzf_lua',
    },
    config = function(_, opts)
      require('zk').setup(opts)
    end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    cond = env.is_vanilla,
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' },
    opts = {},
  },
}

return {
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    cond = is_vanilla,
    opts = {},
    keys = {
      {
        '<leader>?',
        function()
          require('which-key').show({ global = false })
        end,
        desc = 'Buffer local keymaps (which-key)',
      },
    },
    config = function(_, opts)
      local wk = require('which-key')
      wk.setup(opts)
      wk.add({
        { '<leader>f', group = 'File' },
        { '<leader>c', group = 'Code' },
        { '<leader>b', group = 'Buffer' },
        { '<leader>g', group = 'Git' },
        { '<leader>w', group = 'Window' },
        -- { '<leader>n', group = 'Note' },
        { '<leader>j', group = 'Jump' },
        { '<ledaer>m', group = 'Mark' },
      })
    end,
  },
}

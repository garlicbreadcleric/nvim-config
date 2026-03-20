local env = require('lib.env')

return {
  {
    'klen/nvim-config-local',
    opts = {
      config_files = { '.nvim.lua' },
      hashfile = vim.fn.stdpath('data') .. '/config-local',
      autocommands_create = true,
      commands_create = true,
      silent = false,
      lookup_parents = true,
    },
  },

  {
    'stevearc/stickybuf.nvim',
    cond = not env.is_vscode,
    lazy = false,
    keys = {
      { '<leader>wp', '<cmd>PinBuffer<cr>', { noremap = true, silent = true, desc = 'Pin buffer to window' } },
    },
    opts = {
      get_auto_pin = function(buf)
        local path = vim.api.nvim_buf_get_name(buf)
        local name = vim.fn.fnamemodify(path, ':t')
        if name == 'todo.md' or name == 'done.md' then
          return 'bufnr'
        end
      end,
    },
  },

  {
    'folke/edgy.nvim',
    event = 'VeryLazy',
    opts = {
      animate = { enabled = false },
      bottom = {
        {
          ft = 'qf',
          title = 'QuickFix',
          size = { height = 0.3 },
        },
      },
      left = {
        -- {
        --   title = 'Explorer',
        --   ft = 'neo-tree',
        --   size = { width = 0.2 },
        -- },
        {
          title = 'Explorer',
          ft = 'NvimTree',
          size = { width = 0.2 },
        },
        {
          title = 'Explorer',
          ft = 'snacks_layout_box',
          filter = function(buf, win)
            return vim.api.nvim_win_get_config(win).relative == ''
          end,
          size = { width = 0.2 },
        },
        {
          ft = 'Outline',
          title = 'Outline',
          size = { width = 0.2 },
        },
      },
    },
  },

  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = {},
    keys = {
      {
        '<leader>sf',
        function()
          require('persistence').select()
        end,
        { noremap = true, silent = true, desc = 'Session find' },
      },
    },
  },
}

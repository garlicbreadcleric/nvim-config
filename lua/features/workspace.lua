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

  -- WARN: With quicker.nvim, leaving quickfix window open before closing Neovim
  -- caused it to freeze on restart when session was restored by resession.nvim.

  -- {
  --   'stevearc/resession.nvim',
  --   cond = env.is_vanilla and not env.disable_resession,
  --   lazy = false,
  --   opts = {
  --     autosave = {
  --       enabled = true,
  --       interval = 60,
  --       notify = true,
  --     },
  --   },
  --   config = function(_, opts)
  --     local resession = require('resession')
  --     resession.setup(opts)
  --     vim.api.nvim_create_autocmd('VimEnter', {
  --       callback = function()
  --         if env.disable_resession or vim.fn.argc(-1) > 0 then
  --           return
  --         end
  --         resession.load(vim.fn.getcwd(), { dir = 'dirsession', silence_errors = true })
  --       end,
  --       nested = true,
  --     })
  --     vim.api.nvim_create_autocmd('VimLeavePre', {
  --       callback = function()
  --         if env.disable_resession then
  --           return
  --         end
  --         resession.save(vim.fn.getcwd(), { dir = 'dirsession', notify = false })
  --       end,
  --     })
  --   end,
  -- },
  {
    'stevearc/stickybuf.nvim',
    cond = env.is_vanilla,
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
        {
          ft = 'neo-tree',
          title = 'Files',
          size = { width = 0.2 },
        },
        {
          ft = 'Outline',
          title = 'Outline',
          size = { width = 0.2 },
        },
        {
          ft = 'aerial',
          title = 'Outline',
          size = { width = 0.2 },
        },
      },
    },
  },
}

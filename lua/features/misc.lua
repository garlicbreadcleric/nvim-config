local pkg = require('lib.pkg')
local env = require('lib.env')

local plugins = {}

pkg.add(plugins, {
  'luafun/luafun',
})

pkg.add(plugins, {
  'lunarmodules/Penlight',
})

pkg.add(plugins, {
  'echasnovski/mini.nvim',
  version = '*',
  config = function()
    require('mini.move').setup({})
    require('mini.surround').setup({})
    require('mini.comment').setup({
      mappings = {
        comment = '',
        comment_line = '<C-_>',
        comment_visual = '<C-_>',
        textobject = '',
      },
    })

    if env.is_vanilla then
      require('mini.pairs').setup({})

      local function mini_files_reveal()
        local path = vim.bo.buftype ~= 'nofile' and vim.api.nvim_buf_get_name(0) or nil
        MiniFiles.open(path)
      end
      require('mini.files').setup({
        mappings = {
          go_in = 'L',
          go_in_plus = '<cr>',
          go_out = 'H',
          go_out_plus = '',
        },
      })
      vim.keymap.set(
        'n',
        '<leader>fE',
        '<cmd>:lua MiniFiles.open()<cr>',
        { noremap = true, silent = true, desc = 'File explorer' }
      )
      vim.keymap.set(
        'n',
        '<leader>fe',
        mini_files_reveal,
        { noremap = true, silent = true, desc = 'File explorer (reveal current)' }
      )
    end
  end,
})
pkg.add(plugins, {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    words = { enabled = not env.is_vscode },
    notifier = { enabled = not env.is_vscode },
    rename = { enabled = not env.is_vscode },
    lazygit = { enabled = not env.is_vscode },
  },
  config = function(_, opts)
    require('snacks').setup(opts)
    if env.is_vanilla then
      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesActionRename',
        callback = function(event)
          require('snacks').rename.on_rename_file(event.data.from, event.data.to)
        end,
      })
    end
  end,
  keys = {
    {
      '<leader>gg',
      function()
        require('snacks').lazygit()
      end,
      desc = 'Lazygit',
    },
    -- {
    --   '<leader>z',
    --   function()
    --     require('snacks').zen()
    --   end,
    --   desc = 'Lazygit',
    -- },
  },
})

return plugins

local env = require('lib.env')

return {
  {
    'echasnovski/mini.nvim',
    version = '*',
    config = function()
      require('mini.move').setup({
        -- mappings = {
        --   left = '<m-s-h>',
        --   right = '<m-s-l>',
        --   down = '<m-s-j>',
        --   up = '<m-s-k>',
        --   line_left = '<m-s-h>',
        --   line_right = '<m-s-l>',
        --   line_down = '<m-s-j>',
        --   line_up = '<m-s-k>',
        -- },
      })
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
  },
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      words = { enabled = env.is_vanilla },
      notifier = { enabled = env.is_vanilla },
      rename = { enabled = env.is_vanilla },
      lazygit = { enabled = env.is_vanilla },
    },
    config = function(_, opts)
      require('snacks').setup(opts)
      if env.is_vanilla then
        vim.api.nvim_create_autocmd('User', {
          pattern = 'MiniFilesActionRename',
          callback = function(event)
            Snacks.rename.on_rename_file(event.data.from, event.data.to)
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
    },
  },
}

local env = require('lib.env')

return {
  {
    'stevearc/conform.nvim',
    cond = not env.is_vscode,
    opts = {
      formatters_by_ft = {
        javascript = { 'prettierd' },
        typescript = { 'prettierd' },
        typescriptreact = { 'prettierd' },
        json = { 'prettierd' },
        yaml = { 'prettierd' },
        lua = { 'stylua' },
        fish = { 'fish_indent' },
      },
    },
    keys = {
      {
        '<leader>cf',
        function()
          require('conform').format()
        end,
        desc = 'Format code',
      },
    },
  },
}

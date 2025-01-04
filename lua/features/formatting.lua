return {
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        javascript = { 'prettierd' },
        typescript = { 'prettierd' },
        typescriptreact = { 'prettierd' },
        json = { 'prettierd' },
        yaml = { 'prettierd' },
        lua = { 'stylua' },
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

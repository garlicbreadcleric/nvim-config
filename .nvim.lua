local env = require('lib.env')

if not env.is_vscode then
  require('conform').setup({
    formatters_by_ft = {
      lua = { 'stylua' },
    },
    format_on_save = function(bufnr)
      if vim.bo[bufnr].ft == 'lua' then
        return {}
      end
      return nil
    end,
  })
end

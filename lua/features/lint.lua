local pkg = require('lib.pkg')
local env = require('lib.env')

local plugins = {}

pkg.add(plugins, {
  'mfussenegger/nvim-lint',
  cond = not env.is_vscode,
  config = function()
    local lint = require('lint')

    lint.linters_by_ft = {}

    vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost' }, {
      callback = function()
        lint.try_lint()
      end,
    })
  end,
})

return plugins

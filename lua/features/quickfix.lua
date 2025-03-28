local env = require('lib.env')
local pkg = require('lib.pkg')

local plugins = {}

-- WARN: With quicker.nvim, leaving quickfix window open before closing Neovim
-- caused it to freeze on restart when session was restored by resession.nvim.

pkg.add(plugins, {
  'stevearc/quicker.nvim',
  event = 'FileType qf',
  opts = function()
    local quicker = require('quicker')
    return {
      keys = {
        {
          '<tab>',
          function()
            quicker.toggle_expand()
          end,
        },
      },
    }
  end,
  config = true,
})

if not env.is_vscode then
  vim.keymap.set('n', '<leader>qf', function()
    Snacks.picker.qflist()
  end, { noremap = true, silent = true, desc = 'QuickFix list' })

  vim.keymap.set('n', '<leader>qt', function()
    require('quicker').toggle({ focus = true })
  end, { desc = 'Toggle QuickFix' })
end

return plugins

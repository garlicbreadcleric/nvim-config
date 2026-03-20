local pkg = require('lib.pkg')
local env = require('lib.env')

local plugins = {}

pkg.add(plugins, {
  'zbirenbaum/copilot.lua',
  cond = not env.is_vscode,
  main = 'copilot',
  opts = function()
    local opts = {
      -- TODO: Pass node.js path from env variable.
      copilot_node_command = 'node20',
      panel = { enabled = false },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = false,
        debounce = 75,
        keymap = {
          accept = '<C-a>',
          accept_word = '<M-a>',
          accept_line = false,
          next = '<M-]>',
          prev = '<M-[>',
          dismiss = false,
        },
      },
    }
    return opts
  end,
  config = true,
})

return plugins

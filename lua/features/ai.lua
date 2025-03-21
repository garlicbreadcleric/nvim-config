local pkg = require('lib.pkg')
local env = require('lib.env')

local plugins = {}

-- pkg.add(plugins, {
--   'zbirenbaum/copilot.lua',
--   cond = not env.is_vscode,
--   main = 'copilot',
--   opts = {
--     panel = { enabled = false },
--     suggestion = {
--       enabled = true,
--       auto_trigger = true,
--       hide_during_completion = false,
--       debounce = 75,
--       keymap = {
--         accept = '<C-a>',
--         accept_word = '<M-a>',
--         accept_line = false,
--         next = '<M-]>',
--         prev = '<M-[>',
--         dismiss = false,
--       },
--     },
--   },
--   config = true,
-- })

pkg.add(plugins, {
  'codota/tabnine-nvim',
  build = './dl_binaries.sh',
  opts = {
    accept_keymap = '<c-a>',
  },
  config = true,
  main = 'tabnine',
})

return plugins

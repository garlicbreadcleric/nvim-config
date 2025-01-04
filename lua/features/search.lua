local env = require('lib.env')
local vscode = require('lib.vscode')

local plugins = {}

vim.keymap.set('n', '<esc>', ':nohlsearch<CR>', { noremap = true, silent = true, desc = 'Reset search highlight' })

if env.is_vscode then
  vim.keymap.set(
    'n',
    '<leader>fs',
    vscode.action('workbench.action.findInFiles'),
    { noremap = true, silent = true, desc = 'Find in files' }
  )
else
  vim.keymap.set(
    'n',
    '<leader>fs',
    '<cmd>FzfLua live_grep<cr>',
    { noremap = true, silent = true, desc = 'Find in files' }
  )
end

return plugins

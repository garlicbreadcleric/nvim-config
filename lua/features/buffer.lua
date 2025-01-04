local env = require('lib.env')
local vscode = require('lib.vscode')

local plugins = {}

if env.is_vscode then
  vim.keymap.set(
    'n',
    '<leader>bn',
    vscode.action('workbench.action.files.newUntitledFile'),
    { noremap = true, silent = true }
  )
  vim.keymap.set(
    'n',
    '<leader>bd',
    vscode.action('workbench.action.closeActiveEditor'),
    { noremap = true, silent = true }
  )
else
  vim.keymap.set('n', '<leader>bn', '<cmd>enew<cr>', { noremap = true, silent = true, desc = 'New buffer' })
  vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<cr>', { noremap = true, silent = true, desc = 'Delete buffer' })
  vim.keymap.set(
    'n',
    '<leader>bD',
    '<cmd>bdelete!<cr>',
    { noremap = true, silent = true, desc = 'Delete buffer (forced)' }
  )
end

return plugins

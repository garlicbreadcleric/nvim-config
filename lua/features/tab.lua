local env = require('lib.env')

local plugins = {}

if not env.is_vscode then
  vim.keymap.set('n', '<leader>tn', '<cmd>tabnew<cr>', { noremap = true, silent = true, desc = 'Delete tab' })
  vim.keymap.set('n', '<leader>td', '<cmd>tabclose<cr>', { noremap = true, silent = true, desc = 'Delete tab' })
  vim.keymap.set('n', '<leader>t1', '1gt', { noremap = true, silent = true, desc = 'Go to tab 1' })
  vim.keymap.set('n', '<leader>t2', '2gt', { noremap = true, silent = true, desc = 'Go to tab 2' })
  vim.keymap.set('n', '<leader>t3', '3gt', { noremap = true, silent = true, desc = 'Go to tab 3' })
  vim.keymap.set('n', '<leader>t4', '4gt', { noremap = true, silent = true, desc = 'Go to tab 4' })
  vim.keymap.set('n', '<leader>t5', '5gt', { noremap = true, silent = true, desc = 'Go to tab 5' })
  vim.keymap.set('n', '<leader>t6', '6gt', { noremap = true, silent = true, desc = 'Go to tab 6' })
  vim.keymap.set('n', '<leader>t7', '7gt', { noremap = true, silent = true, desc = 'Go to tab 7' })
  vim.keymap.set('n', '<leader>t8', '8gt', { noremap = true, silent = true, desc = 'Go to tab 8' })
  vim.keymap.set('n', '<leader>t9', '9gt', { noremap = true, silent = true, desc = 'Go to tab 9' })
  vim.keymap.set('n', '[t', '<cmd>tabp<cr>', { noremap = true, silent = true, desc = 'Previous tab' })
  vim.keymap.set('n', ']t', '<cmd>tabn<cr>', { noremap = true, silent = true, desc = 'Next tab' })
end

return plugins

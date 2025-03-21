local env = require('lib.env')

local plugins = {}

if not env.is_vscode then
  function CustomFoldText()
    local line = vim.fn.getline(vim.v.foldstart)
    local lines_count = vim.v.foldend - vim.v.foldstart + 1
    return line .. ' ... ' .. lines_count .. ' lines '
  end

  vim.keymap.set({ 'n', 'v' }, '<m-[>', 'zc', { noremap = true, silent = true, desc = 'Close fold under cursor' })
  -- vim.keymap.set('i', '<m-[>', '<c-o>zc', { noremap = true, silent = true, desc = 'Close fold under cursor' })
  vim.keymap.set({ 'n', 'v' }, '<m-]>', 'zo', { noremap = true, silent = true, desc = 'Open fold under cursor' })
  -- vim.keymap.set('i', '<m-]>', '<c-o>zo', { noremap = true, silent = true, desc = 'Open fold under cursor' })
end

return plugins

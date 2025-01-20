local env = require('lib.env')
local vscode = require('lib.vscode')

local plugins = {}

vim.keymap.set('n', '<esc>', ':nohlsearch<CR>', { noremap = true, silent = true, desc = 'Reset search highlight' })

local function file_search()
  if env.is_vscode then
    vscode.action('workbench.action.findInFiles')()
  else
    require('fzf-lua').live_grep()
  end
end

vim.keymap.set('n', '<leader>fs', file_search, { silent = true, desc = 'Find in files' })

return plugins

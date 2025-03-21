local env = require('lib.env')
local pkg = require('lib.pkg')
local vscode = require('lib.vscode')

local plugins = {}

pkg.add(plugins, {
  'nvim-neo-tree/neo-tree.nvim',
  cond = not env.is_vscode,
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  keys = {
    { '<leader>ft', '<cmd>Neotree toggle<cr>', desc = 'Toggle file tree' },
  },
})

local function file_find()
  if env.is_vscode then
    vscode.action('workbench.action.quickOpen')()
  else
    Snacks.picker.files()
  end
end

vim.keymap.set('n', '<leader>ff', file_find, { noremap = true, silent = true, desc = 'Find file' })

if env.is_vscode then
  vim.keymap.set(
    'n',
    '<leader>fo',
    vscode.action('workbench.action.files.openFile'),
    { noremap = true, silent = true, desc = 'Open file' }
  )
  vim.keymap.set(
    'n',
    '<leader>fr',
    vscode.action('workbench.action.openRecent'),
    { noremap = true, silent = true, desc = 'Open recent' }
  )
  vim.keymap.set(
    'n',
    '<leader>Fo',
    vscode.action('workbench.action.files.openFolder'),
    { noremap = true, silent = true, desc = 'Open folder' }
  )
  vim.keymap.set(
    'n',
    '<leader>bf',
    vscode.action('workbench.action.quickOpenPreviousRecentlyUsedEditorInGroup'),
    { noremap = true, silent = true, desc = 'Find file' }
  )
else
  vim.keymap.set('n', '[[', '<c-o>', { noremap = true, silent = true, desc = 'Jump back' })
  vim.keymap.set('n', ']]', '<c-i>', { noremap = true, silent = true, desc = 'Jump forward' })

  vim.keymap.set('n', '<leader>bf', function()
    Snacks.picker.buffers({ current = false })
  end, { noremap = true, silent = true, desc = 'Find file' })

  vim.keymap.set('n', '<leader>jf', function()
    Snacks.picker.jumps()
  end, { noremap = true, silent = true, desc = 'Find jump' })

  vim.keymap.set('n', '<leader>mf', function()
    Snacks.picker.marks()
  end, { noremap = true, silent = true, desc = 'Find mark' })
end

return plugins

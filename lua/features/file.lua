local env = require('lib.env')
local pkg = require('lib.pkg')
local vscode = require('lib.vscode')

local plugins = {}

pkg.add(plugins, {
  'junegunn/fzf',
  cond = env.is_vanilla,
})

local function grep_replace(selected, opts)
  -- TODO: Open new fzf-lua preview for search & replace.

  -- vim.api.nvim_put({ opts.last_query }, 'c', true, true)
end

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

pkg.add(plugins, {
  'ibhagwan/fzf-lua',
  cond = env.is_vanilla,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = function()
    local actions = require('fzf-lua.actions')
    return {
      fzf_colors = true,
      winopts = { backdrop = 100 },
      keymap = {
        fzf = {
          true,
          ['tab'] = 'toggle',
          ['ctrl-a'] = 'select-all',
          ['ctrl-x'] = 'deselect-all',
        },
      },
      grep = {
        actions = {
          ['ctrl-r'] = grep_replace,
        },
      },
    }
  end,
  config = function(_, opts)
    require('fzf-lua').setup(opts)
  end,
})

if env.is_vscode then
  vim.keymap.set(
    'n',
    '<leader>ff',
    vscode.action('workbench.action.quickOpen'),
    { noremap = true, silent = true, desc = 'Find file' }
  )
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

  vim.keymap.set('n', '<leader>ff', function()
    require('fzf-lua').files()
  end, { noremap = true, silent = true, desc = 'Find file' })

  vim.keymap.set('n', '<leader>bf', function()
    require('fzf-lua').buffers()
  end, { noremap = true, silent = true, desc = 'Find file' })

  vim.keymap.set('n', '<leader>jf', function()
    require('fzf-lua').jumps()
  end, { noremap = true, silent = true, desc = 'Find jump' })

  vim.keymap.set('n', '<leader>mf', function()
    require('fzf-lua').marks()
  end, { noremap = true, silent = true, desc = 'Find mark' })
end

return plugins

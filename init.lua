local env = require('lib.env')
local vscode = require('lib.vscode')

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require('options')

require('lazy').setup({
  spec = {
    { import = 'features' },
  },
  install = { colorscheme = { 'solarized' } },
  checker = { enabled = true },
})

vim.keymap.set('n', ';', ':', { noremap = true, silent = false })
vim.keymap.set('v', ';', ':', { noremap = true, silent = false })

if env.is_vscode then
  vim.keymap.set(
    'n',
    '<leader><leader>',
    vscode.action('workbench.action.showCommands'),
    { noremap = true, silent = true, desc = 'Command palette' }
  )
else
  vim.keymap.set(
    'n',
    '<leader><leader>',
    '<cmd>FzfLua commands<cr>',
    { noremap = true, silent = true, desc = 'Command palette' }
  )
  vim.keymap.set('n', '<leader>h', '<cmd>FzfLua helptags<cr>', { noremap = true, silent = true, desc = 'Help' })
end

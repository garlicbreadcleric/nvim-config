local env = require('lib.env')
local const = require('lib.const')

vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true

vim.opt.scrollback = const.TERMINAL_SCROLLBACK

vim.g.no_python_maps = true

if env.is_vscode then
  vim.cmd('syntax off')
  vim.opt.relativenumber = false
  vim.opt.number = false
else
  vim.o.termguicolors = true
  vim.o.background = 'light'

  vim.opt.number = true
  vim.opt.signcolumn = 'yes'
  vim.opt.wrap = false
  vim.opt.linebreak = false
  vim.opt.scrolloff = 2

  vim.opt.foldlevelstart = 99
  vim.opt.foldtext = 'v:lua.CustomFoldText()'
  vim.opt.fillchars = { fold = ' ' }
  vim.opt.foldmethod = 'expr'
  vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

  vim.opt.tabstop = 4
  vim.opt.shiftwidth = 4
  vim.opt.expandtab = true
  vim.opt.smartindent = true
  vim.opt.autoindent = true

  vim.opt.laststatus = 3
  vim.opt.splitkeep = 'screen'
end

return {}

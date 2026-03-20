-- #######################################
-- ### USAGE: nvim --clean -u mini.lua ###
-- #######################################

local root = vim.fn.stdpath('run') .. '/nvim/diffview.nvim'
local plugin_dir = root .. '/plugins'
vim.fn.mkdir(plugin_dir, 'p')

for _, name in ipairs({ 'config', 'data', 'state', 'cache' }) do
  vim.env[('XDG_%s_HOME'):format(name:upper())] = root .. '/' .. name
end

local plugins = {
  { 'nvim-web-devicons', url = 'https://github.com/nvim-tree/nvim-web-devicons.git' },
  { 'diffview.nvim', url = 'https://github.com/sindrets/diffview.nvim.git' },
  { 'folke/which-key.nvim', url = 'https://github.com/folke/which-key.nvim.git' },
}

for _, spec in ipairs(plugins) do
  local install_path = plugin_dir .. '/' .. spec[1]
  if vim.fn.isdirectory(install_path) ~= 1 then
    if spec.url then
      print(string.format("Installing '%s'...", spec[1]))
      vim.fn.system({ 'git', 'clone', '--depth=1', spec.url, install_path })
    end
  end
  vim.opt.runtimepath:append(spec.path or install_path)
end

local actions = require('diffview.actions')
require('diffview').setup({
  keymaps = {
    view = {
      { 'n', '<tab>', actions.select_next_entry, { desc = 'Next file diff' } },
      { 'n', '<s-tab>', actions.select_prev_entry, { desc = 'Previous file diff' } },
      { 'n', '[x', actions.prev_conflict, { desc = 'Previous conflict' } },
      { 'n', ']x', actions.next_conflict, { desc = 'Next conflict' } },
      { 'n', '<localleader>xo', actions.conflict_choose('ours'), { desc = 'Accept ours' } },
      { 'n', '<localleader>xt', actions.conflict_choose('theirs'), { desc = 'Accept theirs' } },
      { 'n', '<localleader>xb', actions.conflict_choose('base'), { desc = 'Accept base' } },
      { 'n', '<localleader>xa', actions.conflict_choose('all'), { desc = 'Accept all' } },
      { 'n', '<localleader>Xo', actions.conflict_choose_all('ours'), { desc = 'Accept ours (whole file)' } },
      { 'n', '<localleader>Xt', actions.conflict_choose_all('theirs'), { desc = 'Accept theirs (whole file)' } },
      { 'n', '<localleader>Xb', actions.conflict_choose_all('base'), { desc = 'Accept base (whole file)' } },
      { 'n', '<localleader>Xa', actions.conflict_choose_all('all'), { desc = 'Accept all (whole file)' } },
    },
  },
})

vim.g.mapleader = ' '
vim.g.maplocalleader = ','
vim.opt.termguicolors = true
vim.cmd('colorscheme ' .. (vim.fn.has('nvim-0.8') == 1 and 'habamax' or 'slate'))

print('Ready!')

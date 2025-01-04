local pkg = require('lib.pkg')
local const = require('lib.const')

local plugins = {}

pkg.add(plugins, {
  'akinsho/toggleterm.nvim',
  version = '*',
  opts = {
    open_mapping = [[<c-\>]],
    shade_terminals = false,
  },
})

local scrollback = const.TERMINAL_SCROLLBACK

vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>', { noremap = true, silent = true, desc = 'Exit terminal mode' })

local function clear_terminal()
  vim.bo.scrollback = 1
  vim.fn.feedkeys('', 'n')
  vim.bo.scrollback = scrollback
end

vim.keymap.set('t', '<c-l>', clear_terminal, { silent = true, desc = 'Clear terminal ' })

vim.cmd('autocmd TermOpen * startinsert')
vim.cmd('autocmd TermOpen * setlocal nonumber')
vim.cmd('autocmd TermEnter * setlocal signcolumn=no')

return plugins

local pkg = require('lib.pkg')
local env = require('lib.env')

local plugins = {}

pkg.add(plugins, {
  'rhysd/clever-f.vim',
  init = function()
    vim.g.clever_f_timeout_ms = 3000
    vim.g.clever_f_highlight_timeout_ms = 3000
    vim.g.clever_f_smart_case = true
  end,
})

pkg.add(plugins, {
  'jake-stewart/multicursor.nvim',
  branch = '1.0',
  config = function()
    local mc = require('multicursor-nvim')
  end,
})

vim.keymap.set({ 'n', 'v' }, 'j', 'gj', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, 'k', 'gk', { noremap = true, silent = true })

vim.keymap.set('n', '<C-h>', 'b', { noremap = true, silent = true, desc = 'Previous word' })
vim.keymap.set('i', '<C-h>', '<C-o>b', { noremap = true, silent = true, desc = 'Previous word' })
vim.keymap.set('v', '<C-h>', 'b', { noremap = true, silent = true, desc = 'Previous word' })

vim.keymap.set('n', '<C-l>', 'w', { noremap = true, silent = true, desc = 'Next word' })
vim.keymap.set('i', '<C-l>', '<C-o>w', { noremap = true, silent = true, desc = 'Next word' })
vim.keymap.set('v', '<C-l>', 'w', { noremap = true, silent = true, desc = 'Next word' })

vim.keymap.set('n', '<C-j>', '5gj', { noremap = true, silent = true, desc = 'Previous word' })
vim.keymap.set('i', '<C-j>', '<C-o>5gj', { noremap = true, silent = true, desc = 'Previous word' })
vim.keymap.set('v', '<C-j>', '5gj', { noremap = true, silent = true, desc = 'Previous word' })

vim.keymap.set('n', '<C-k>', '5gk', { noremap = true, silent = true, desc = 'Next word' })
vim.keymap.set('i', '<C-k>', '<C-o>5gk', { noremap = true, silent = true, desc = 'Next word' })
vim.keymap.set('v', '<C-k>', '5gk', { noremap = true, silent = true, desc = 'Next word' })

local function shift_h()
  local pos, new_pos
  pos = vim.fn.getpos('.')
  vim.cmd('normal! g^')
  new_pos = vim.fn.getpos('.')
  if pos[2] ~= new_pos[2] or pos[3] ~= new_pos[3] then
    return
  end
  pos = new_pos
  vim.cmd('normal! ^')
  new_pos = vim.fn.getpos('.')
  if pos[2] ~= new_pos[2] or pos[3] ~= new_pos[3] then
    return
  end
  vim.cmd('normal! 0')
end

local function shift_l()
  local pos, new_pos
  pos = vim.fn.getpos('.')
  vim.cmd('normal! g$')
  new_pos = vim.fn.getpos('.')
  if pos[2] ~= new_pos[2] or pos[3] ~= new_pos[3] then
    return
  end
  pos = new_pos
  vim.cmd('normal! $')
end

vim.keymap.set('n', 'H', shift_h, { noremap = true, desc = 'Start of line' })
vim.keymap.set('v', 'H', shift_h, { noremap = true, desc = 'Start of line' })

vim.keymap.set('n', 'L', shift_l, { noremap = true, silent = true, desc = 'End of line' })
vim.keymap.set('v', 'L', shift_l, { noremap = true, silent = true, desc = 'End of line' })

vim.keymap.set('n', 'K', 'gg', { noremap = true, silent = true, desc = 'Start of buffer' })
vim.keymap.set('v', 'K', 'gg', { noremap = true, silent = true, desc = 'Start of buffer' })

vim.keymap.set('n', 'J', 'G', { noremap = true, silent = true, desc = 'End of buffer' })
vim.keymap.set('v', 'J', 'G', { noremap = true, silent = true, desc = 'End of buffer' })

local function object_start_end(object)
  local esc = vim.api.nvim_replace_termcodes('<esc>', true, false, true)

  -- Save current cursor position and selection.
  local init_cursor = vim.fn.getpos('.')
  local init_start = nil
  local init_end = nil
  if vim.fn.mode() == 'v' or vim.fn.mode() == 'V' or vim.fn.mode() == 'CTRL-V' then
    vim.api.nvim_feedkeys(esc, 'x', false)
    init_start = vim.fn.getpos("'<")
    init_end = vim.fn.getpos("'>")
  end

  -- Determine positions of textobject edges.
  vim.cmd('normal! v' .. object)
  vim.api.nvim_feedkeys(esc, 'x', false)
  local object_start = vim.fn.getpos("'<")
  local object_end = vim.fn.getpos("'>")

  -- Restore original position.
  if init_start and init_end then
    if init_start[2] == init_cursor[2] and init_start[3] == init_cursor[3] then
      vim.fn.setpos('.', init_end)
      vim.cmd('normal! v')
      vim.fn.setpos('.', init_start)
    else
      vim.fn.setpos('.', init_start)
      vim.cmd('normal! v')
      vim.fn.setpos('.', init_end)
    end
  else
    vim.fn.setpos('.', init_cursor)
  end

  -- Jump to textobject start/end.
  if init_cursor[2] == object_start[2] and init_cursor[3] == object_start[3] then
    vim.fn.setpos('.', object_end)
  else
    vim.fn.setpos('.', object_start)
  end
end

local function word_start_end()
  object_start_end('iw')
end

vim.keymap.set('n', 'w', word_start_end, { noremap = true, desc = 'Toggle between start/end of word' })
vim.keymap.set('v', 'w', word_start_end, { noremap = true, desc = 'Toggle between start/end of word' })

vim.keymap.set('n', 'U', '<C-r>', { noremap = true, silent = true })
vim.keymap.set('n', 'M', 'J', { noremap = true, silent = true, desc = 'Merge lines' })
vim.keymap.set('v', 'M', 'J', { noremap = true, silent = true, desc = 'Merge lines' })

if not env.is_vscode then
  vim.keymap.set('v', '<C-c>', '"+y', { noremap = true, silent = true })
  vim.keymap.set('i', '<C-v>', '<C-r>+', { noremap = true, silent = true })

  vim.keymap.set('i', '<S-Tab>', '<C-d>', { noremap = true, silent = true })
end

return plugins

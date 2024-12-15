require("config.lazy")
local is_vanilla = not vim.g.vscode
local is_vscode = not not vim.g.vscode

local map = vim.api.nvim_set_keymap

map('n', ';', ':', { noremap = true, silent = false })
map('v', ';', ':', { noremap = true, silent = false })

local function vscode_action(action)
  return function()
    require('vscode').action(action)
  end
end

if is_vscode then
  vim.keymap.set('n', '<leader><leader>', vscode_action('workbench.action.showCommands'), { noremap = true, silent = true, desc = 'Command palette' })
else
  vim.keymap.set('n', '<leader><leader>', '<cmd>Telescope commands<cr>', { noremap = true, silent = true, desc = 'Command palette' })
end


-- Appearance.

if is_vscode then
  vim.cmd("syntax off")
  vim.opt.relativenumber = false
  vim.opt.number = false
else
  vim.opt.relativenumber = false
  vim.opt.number = true
  vim.opt.signcolumn = 'yes'
end


-- Search.

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true

map('n', '<leader>h', ':nohlsearch<CR>', { noremap = true, silent = true, desc = 'Reset search highlight' })

if is_vscode then
  vim.keymap.set('n', '<leader>fs', vscode_action('workbench.action.findInFiles'), { noremap = true, silent = true, desc = 'Find in files' })
else
  vim.keymap.set('n', '<leader>fs', '<cmd>Telescope live_grep<cr>', { noremap = true, silent = true, desc = 'Find in files' })
end


-- File navigation.

if is_vscode then
  vim.keymap.set('n', '<leader>ff', vscode_action('workbench.action.quickOpen'), { noremap = true, silent = true, desc = 'Find file' })
  vim.keymap.set('n', '<leader>fo', vscode_action('workbench.action.files.openFile'), { noremap = true, silent = true, desc = 'Open file' })
  vim.keymap.set('n', '<leader>fr', vscode_action('workbench.action.openRecent'), { noremap = true, silent = true, desc = 'Open recent' })
  vim.keymap.set('n', '<leader>Fo', vscode_action('workbench.action.files.openFolder'), { noremap = true, silent = true, desc = 'Open folder' })
  vim.keymap.set('n', '<leader>bf', vscode_action('workbench.action.quickOpenPreviousRecentlyUsedEditorInGroup'), { noremap = true, silent = true, desc = 'Find file' })
else
  vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { noremap = true, silent = true, desc = 'Find file' })
  vim.keymap.set('n', '<leader>bf', '<cmd>Telescope buffers<cr>', { noremap = true, silent = true, desc = 'Find file' })
end


-- Buffer navigation.

if is_vanilla then
  map('n', '<leader>bn', '<cmd>enew<cr>', { noremap = true, silent = true, desc = 'New buffer' })
  map('n', '<leader>bd', '<cmd>bdelete<cr>', { noremap = true, silent = true, desc = 'Delete buffer' })
  map('n', '<leader>bD', '<cmd>bdelete!<cr>', { noremap = true, silent = true, desc = 'Delete buffer (forced)' })
end

if is_vscode then
  vim.keymap.set('n', '<leader>bn', vscode_action('workbench.action.files.newUntitledFile'), { noremap = true, silent = true })
  vim.keymap.set('n', '<leader>bd', vscode_action('workbench.action.closeActiveEditor'), { noremap = true, silent = true })
end


-- Text navigation.

vim.o.number = true
vim.opt.number = true
vim.opt.wrap = false
vim.opt.breakindent = true
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})

vim.keymap.set({ 'n', 'v' }, 'j', 'gj', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, 'k', 'gk', { noremap = true, silent = true })

map('n', '<C-h>', 'b', { noremap = true, silent = true, desc = 'Previous word' })
map('i', '<C-h>', '<C-o>b', { noremap = true, silent = true, desc = 'Previous word' })
map('v', '<C-h>', 'b', { noremap = true, silent = true, desc = 'Previous word' })

map('n', '<C-l>', 'w', { noremap = true, silent = true, desc = 'Next word' })
map('i', '<C-l>', '<C-o>w', { noremap = true, silent = true, desc = 'Next word' })
map('v', '<C-l>', 'w', { noremap = true, silent = true, desc = 'Next word' })

map('n', '<C-j>', '8gj', { noremap = true, silent = true, desc = 'Previous word' })
map('i', '<C-j>', '<C-o>8gj', { noremap = true, silent = true, desc = 'Previous word' })
map('v', '<C-j>', '8gj', { noremap = true, silent = true, desc = 'Previous word' })

map('n', '<C-k>', '8gk', { noremap = true, silent = true, desc = 'Next word' })
map('i', '<C-k>', '<C-o>8gk', { noremap = true, silent = true, desc = 'Next word' })
map('v', '<C-k>', '8gk', { noremap = true, silent = true, desc = 'Next word' })

local function jump_to_line_start()
  local col = vim.fn.col('.')
  local first_non_blank = vim.fn.indent(vim.fn.line('.')) + 1
  if col == first_non_blank then
    vim.cmd("normal! 0")
  else
    vim.cmd("normal! ^")
  end
end

vim.keymap.set('n', 'H', jump_to_line_start, { noremap = true, desc = 'Start of line' })
vim.keymap.set('v', 'H', jump_to_line_start, { noremap = true, desc = 'Start of line' })
-- map('n', 'H', '^', { noremap = true, silent = true, desc = 'Start of line' })
-- map('v', 'H', '^', { noremap = true, silent = true, desc = 'Start of line' })

map('n', 'L', '$', { noremap = true, silent = true, desc = 'End of line' })
map('v', 'L', '$', { noremap = true, silent = true, desc = 'End of line' })

map('n', 'K', 'gg', { noremap = true, silent = true, desc = 'Start of buffer' })
map('v', 'K', 'gg', { noremap = true, silent = true, desc = 'Start of buffer' })

map('n', 'J', 'G', { noremap = true, silent = true, desc = 'End of buffer' })
map('v', 'J', 'G', { noremap = true, silent = true, desc = 'End of buffer' })

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


-- Text editing.

map('n', 'U', '<C-r>', { noremap = true, silent = true })

if is_vanilla then
  map('n', '<C-c>', '"+y', { noremap = true, silent = true })
  map('v', '<C-c>', '"+y', { noremap = true, silent = true })
  map('i', '<C-v>', '<C-r>+', { noremap = true, silent = true })

  map('i', '<S-Tab>', '<C-d>', { noremap = true, silent = true })
end


-- Intellisense.

if is_vanilla then
  vim.keymap.set('n', 'gd', '<cmd>Telescope lsp_definitions<cr>', { noremap = true, silent = true, desc = 'Go to definition' })
  vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', { noremap = true, silent = true, desc = 'Show references' })
  vim.keymap.set('n', 'gi', '<cmd>Telescope lsp_implementations<cr>', { noremap = true, silent = true, desc = 'Go to implementation'})
  vim.keymap.set('n', '<leader>cs', '<cmd>Telescope lsp_document_symbols<cr>', { noremap = true, silent = true, desc = 'Document symbols' })
  vim.keymap.set('n', '<leader>cS', '<cmd>Telescope lsp_workspace_symbols<cr>', { noremap = true, silent = true, desc = 'Workspace symbols' })
  vim.keymap.set('n', '<leader>cd', '<cmd>Telescope diagnostics buffer=0<cr>', { noremap = true, silent = true, desc = 'Show diagnostics' })
else
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { noremap = true, silent = true, desc = 'Go to definition' })
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, { noremap = true, silent = true, desc = 'Show references' })
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { noremap = true, silent = true, desc = 'Go to implementation' })
  vim.keymap.set('n', '<leader>cs', vim.lsp.buf.document_symbol, { noremap = true, silent = true, desc = 'Document symbols' })
  vim.keymap.set('n', '<leader>cS', vim.lsp.buf.workspace_symbol, { noremap = true, silent = true, desc = 'Workspace symbols' })
end
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { noremap = true, silent = true, desc = 'Code actions' })
vim.keymap.set('n', '<leader>ch', vim.lsp.buf.hover, { noremap = true, silent = true, desc = 'Hover' })

-- vim.opt.foldenable = false
vim.opt.foldlevelstart = 99
if is_vanilla then
  vim.opt.foldmethod = 'expr'
  vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'

  function CustomFoldText()
    local line = vim.fn.getline(vim.v.foldstart)
    local lines_count = vim.v.foldend - vim.v.foldstart + 1
    return line .. ' ... ' .. lines_count .. ' lines '
  end
  vim.opt.foldtext = 'v:lua.CustomFoldText()'
  vim.opt.fillchars = { fold = ' ' }

  vim.keymap.set({ 'n', 'v' }, '<m-[>', 'zc', { noremap = true, silent = true, desc = 'Close fold under cursor' })
  vim.keymap.set('i', '<m-[>', '<c-o>zc', { noremap = true, silent = true, desc = 'Close fold under cursor' })
  vim.keymap.set({ 'n', 'v' }, '<m-]>', 'zo', { noremap = true, silent = true, desc = 'Open fold under cursor' })
  vim.keymap.set('i', '<m-]>', '<c-o>zo', { noremap = true, silent = true, desc = 'Open fold under cursor' })
end


-- Terminal.

vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>', { noremap = true, silent = true, desc = 'Exit terminal mode' })


-- Version control.

if is_vanilla then
  vim.keymap.set('n', '<leader>gc', '<cmd>Telescope git_bcommits<cr>', { noremap = true, silent = true, desc = 'Find Git commit' })
  vim.keymap.set('n', '<leader>gb', '<cmd>Telescope git_branches<cr>', { noremap = true, silent = true, desc = 'Find Git branch' })
  vim.keymap.set('n', '<leader>gs', '<cmd>Telescope git_status<cr>', { noremap = true, silent = true, desc = 'Git status' })
end


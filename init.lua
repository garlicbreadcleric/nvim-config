require('config.lazy')
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
  vim.keymap.set(
    'n',
    '<leader><leader>',
    vscode_action('workbench.action.showCommands'),
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

-- Appearance.

if is_vscode then
  vim.cmd('syntax off')
  vim.opt.relativenumber = false
  vim.opt.number = false
else
  vim.opt.number = true
  vim.opt.signcolumn = 'yes'
  vim.opt.wrap = false
  vim.opt.linebreak = false
  vim.opt.scrolloff = 2
end

if is_vanilla then
  vim.api.nvim_create_autocmd('FileType', {
    pattern = '*',
    callback = function()
      if vim.bo.filetype == 'markdown' and vim.bo.buftype ~= 'nofile' then
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.breakindent = true
        vim.opt_local.number = false
        vim.opt_local.signcolumn = 'no'
      end
    end,
    group = vim.api.nvim_create_augroup('MarkdownSettings', { clear = true }),
  })
end

-- Search.

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true

map('n', '<esc>', ':nohlsearch<CR>', { noremap = true, silent = true, desc = 'Reset search highlight' })

if is_vscode then
  vim.keymap.set(
    'n',
    '<leader>fs',
    vscode_action('workbench.action.findInFiles'),
    { noremap = true, silent = true, desc = 'Find in files' }
  )
else
  vim.keymap.set(
    'n',
    '<leader>fs',
    '<cmd>FzfLua live_grep<cr>',
    { noremap = true, silent = true, desc = 'Find in files' }
  )
end

-- File navigation.

if is_vscode then
  vim.keymap.set(
    'n',
    '<leader>ff',
    vscode_action('workbench.action.quickOpen'),
    { noremap = true, silent = true, desc = 'Find file' }
  )
  vim.keymap.set(
    'n',
    '<leader>fo',
    vscode_action('workbench.action.files.openFile'),
    { noremap = true, silent = true, desc = 'Open file' }
  )
  vim.keymap.set(
    'n',
    '<leader>fr',
    vscode_action('workbench.action.openRecent'),
    { noremap = true, silent = true, desc = 'Open recent' }
  )
  vim.keymap.set(
    'n',
    '<leader>Fo',
    vscode_action('workbench.action.files.openFolder'),
    { noremap = true, silent = true, desc = 'Open folder' }
  )
  vim.keymap.set(
    'n',
    '<leader>bf',
    vscode_action('workbench.action.quickOpenPreviousRecentlyUsedEditorInGroup'),
    { noremap = true, silent = true, desc = 'Find file' }
  )
else
  vim.keymap.set('n', '[[', '<c-o>', { noremap = true, silent = true, desc = 'Jump back' })
  vim.keymap.set('n', ']]', '<c-i>', { noremap = true, silent = true, desc = 'Jump forward' })

  vim.keymap.set('n', '<leader>ff', '<cmd>FzfLua files<cr>', { noremap = true, silent = true, desc = 'Find file' })
  vim.keymap.set('n', '<leader>bf', '<cmd>FzfLua buffers<cr>', { noremap = true, silent = true, desc = 'Find file' })
  vim.keymap.set('n', '<leader>jf', '<cmd>FzfLua jumps<cr>', { noremap = true, silent = true, desc = 'Find jump' })
  vim.keymap.set('n', '<leader>mf', '<cmd>FzfLua marks<cr>', { noremap = true, silent = true, desc = 'Find mark' })
end

-- Tab navigation.

if is_vanilla then
  map('n', '<leader>td', '<cmd>tabclose<cr>', { noremap = true, silent = true, desc = 'Delete tab' })
  map('n', '<leader>t1', '1gt', { noremap = true, silent = true, desc = 'Go to tab 1' })
  map('n', '<leader>t2', '2gt', { noremap = true, silent = true, desc = 'Go to tab 2' })
  map('n', '<leader>t3', '3gt', { noremap = true, silent = true, desc = 'Go to tab 3' })
  map('n', '<leader>t4', '4gt', { noremap = true, silent = true, desc = 'Go to tab 4' })
  map('n', '<leader>t5', '5gt', { noremap = true, silent = true, desc = 'Go to tab 5' })
  map('n', '<leader>t6', '6gt', { noremap = true, silent = true, desc = 'Go to tab 6' })
  map('n', '<leader>t7', '7gt', { noremap = true, silent = true, desc = 'Go to tab 7' })
  map('n', '<leader>t8', '8gt', { noremap = true, silent = true, desc = 'Go to tab 8' })
  map('n', '<leader>t9', '9gt', { noremap = true, silent = true, desc = 'Go to tab 9' })
  map('n', '[t', '<cmd>tabp<cr>', { noremap = true, silent = true, desc = 'Previous tab' })
  map('n', ']t', '<cmd>tabn<cr>', { noremap = true, silent = true, desc = 'Next tab' })
end

-- Buffer navigation.

if is_vanilla then
  map('n', '<leader>bn', '<cmd>enew<cr>', { noremap = true, silent = true, desc = 'New buffer' })
  map('n', '<leader>bd', '<cmd>bdelete<cr>', { noremap = true, silent = true, desc = 'Delete buffer' })
  map('n', '<leader>bD', '<cmd>bdelete!<cr>', { noremap = true, silent = true, desc = 'Delete buffer (forced)' })
end

if is_vscode then
  vim.keymap.set(
    'n',
    '<leader>bn',
    vscode_action('workbench.action.files.newUntitledFile'),
    { noremap = true, silent = true }
  )
  vim.keymap.set(
    'n',
    '<leader>bd',
    vscode_action('workbench.action.closeActiveEditor'),
    { noremap = true, silent = true }
  )
end

-- Text navigation.

vim.keymap.set({ 'n', 'v' }, 'j', 'gj', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, 'k', 'gk', { noremap = true, silent = true })

map('n', '<C-h>', 'b', { noremap = true, silent = true, desc = 'Previous word' })
map('i', '<C-h>', '<C-o>b', { noremap = true, silent = true, desc = 'Previous word' })
map('v', '<C-h>', 'b', { noremap = true, silent = true, desc = 'Previous word' })

map('n', '<C-l>', 'w', { noremap = true, silent = true, desc = 'Next word' })
map('i', '<C-l>', '<C-o>w', { noremap = true, silent = true, desc = 'Next word' })
map('v', '<C-l>', 'w', { noremap = true, silent = true, desc = 'Next word' })

map('n', '<C-j>', '5gj', { noremap = true, silent = true, desc = 'Previous word' })
map('i', '<C-j>', '<C-o>5gj', { noremap = true, silent = true, desc = 'Previous word' })
map('v', '<C-j>', '5gj', { noremap = true, silent = true, desc = 'Previous word' })

map('n', '<C-k>', '5gk', { noremap = true, silent = true, desc = 'Next word' })
map('i', '<C-k>', '<C-o>5gk', { noremap = true, silent = true, desc = 'Next word' })
map('v', '<C-k>', '5gk', { noremap = true, silent = true, desc = 'Next word' })

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
map('n', 'M', 'J', { noremap = true, silent = true, desc = 'Merge lines' })
map('v', 'M', 'J', { noremap = true, silent = true, desc = 'Merge lines' })

if is_vanilla then
  map('v', '<C-c>', '"+y', { noremap = true, silent = true })
  map('i', '<C-v>', '<C-r>+', { noremap = true, silent = true })

  map('i', '<S-Tab>', '<C-d>', { noremap = true, silent = true })
end

if is_vanilla then
  vim.opt.tabstop = 4
  vim.opt.shiftwidth = 4
  vim.opt.expandtab = true
  vim.opt.smartindent = true
  vim.opt.autoindent = true
end

-- Intellisense.

local function show_hover()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local line = cursor_pos[1] - 1

  local diagnostics = vim.diagnostic.get(bufnr, { lnum = line })
  -- local has_diagnostics = diagnostics and #diagnostics > 0

  vim.lsp.buf_request(bufnr, 'textDocument/hover', vim.lsp.util.make_position_params(), function(_, result)
    local contents = {}

    -- Add hover information if available
    if result and result.contents then
      local hover_content = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
      for _, line in ipairs(hover_content) do
        table.insert(contents, line)
      end
    end

    if diagnostics and #diagnostics > 0 then
      if #contents > 0 then
        table.insert(contents, '---')
      end
      for _, diag in ipairs(diagnostics) do
        table.insert(contents, diag.message)
      end
    end

    if #contents > 0 then
      vim.lsp.util.open_floating_preview(contents, 'markdown', {
        focusable = false,
        -- border = 'rounded',
        -- pad_left = 0,
        -- pad_right = 0,
        -- pad_top = 0,
        -- pad_bottom = 0,
      })
    end
  end)
end

if is_vanilla then
  vim.keymap.set(
    'n',
    'gd',
    '<cmd>FzfLua lsp_definitions jump_to_single_result=true<cr>',
    { noremap = true, silent = true, desc = 'Go to definition' }
  )
  vim.keymap.set(
    'n',
    'gr',
    '<cmd>FzfLua lsp_references jump_to_single_result=true<cr>',
    { noremap = true, silent = true, desc = 'Show references' }
  )
  vim.keymap.set(
    'n',
    'gi',
    '<cmd>FzfLua lsp_implementations jump_to_single_result=true<cr>',
    { noremap = true, silent = true, desc = 'Go to implementation' }
  )
  vim.keymap.set(
    'n',
    'gt',
    '<cmd>FzfLua lsp_type_definitions jump_to_single_result=true<cr>',
    { noremap = true, silent = true, desc = 'Go to type definition' }
  )
  vim.keymap.set(
    'n',
    '<leader>cs',
    '<cmd>FzfLua lsp_document_symbols<cr>',
    { noremap = true, silent = true, desc = 'Document symbols' }
  )
  vim.keymap.set(
    'n',
    '<leader>cS',
    '<cmd>FzfLua lsp_workspace_symbols<cr>',
    { noremap = true, silent = true, desc = 'Workspace symbols' }
  )
  vim.keymap.set(
    'n',
    '<leader>cd',
    '<cmd>FzfLua diagnostics_document<cr>',
    { noremap = true, silent = true, desc = 'Find diagnostic' }
  )
  vim.keymap.set('n', '<leader>ch', show_hover, { noremap = true, silent = true, desc = 'Hover' })
else
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { noremap = true, silent = true, desc = 'Go to definition' })
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, { noremap = true, silent = true, desc = 'Show references' })
  vim.keymap.set(
    'n',
    'gi',
    vim.lsp.buf.implementation,
    { noremap = true, silent = true, desc = 'Go to implementation' }
  )
  vim.keymap.set(
    'n',
    'gt',
    vim.lsp.buf.type_definition,
    { noremap = true, silent = true, desc = 'Go to type definition' }
  )
  vim.keymap.set(
    'n',
    '<leader>cs',
    vim.lsp.buf.document_symbol,
    { noremap = true, silent = true, desc = 'Document symbols' }
  )
  vim.keymap.set(
    'n',
    '<leader>cS',
    vim.lsp.buf.workspace_symbol,
    { noremap = true, silent = true, desc = 'Workspace symbols' }
  )
  vim.keymap.set('n', '<leader>ch', vim.lsp.buf.hover, { noremap = true, silent = true, desc = 'Hover' })
end

vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { noremap = true, silent = true, desc = 'Code actions' })
vim.keymap.set('v', '<leader>ca', vim.lsp.buf.code_action, { noremap = true, silent = true, desc = 'Code actions' })
vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { noremap = true, silent = true, desc = 'Rename' })

vim.opt.foldlevelstart = 99
if is_vanilla then
  vim.opt.foldmethod = 'expr'
  vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'

  vim.cmd('TSEnable highlight')

  function CustomFoldText()
    local line = vim.fn.getline(vim.v.foldstart)
    local lines_count = vim.v.foldend - vim.v.foldstart + 1
    return line .. ' ... ' .. lines_count .. ' lines '
  end
  vim.opt.foldtext = 'v:lua.CustomFoldText()'
  vim.opt.fillchars = { fold = ' ' }

  vim.keymap.set({ 'n', 'v' }, '<m-[>', 'zc', { noremap = true, silent = true, desc = 'Close fold under cursor' })
  -- vim.keymap.set('i', '<m-[>', '<c-o>zc', { noremap = true, silent = true, desc = 'Close fold under cursor' })
  vim.keymap.set({ 'n', 'v' }, '<m-]>', 'zo', { noremap = true, silent = true, desc = 'Open fold under cursor' })
  -- vim.keymap.set('i', '<m-]>', '<c-o>zo', { noremap = true, silent = true, desc = 'Open fold under cursor' })
end

-- Terminal.

local scrollback = 100000

vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>', { noremap = true, silent = true, desc = 'Exit terminal mode' })
vim.opt.scrollback = scrollback

local function clear_terminal()
  vim.bo.scrollback = 1
  vim.fn.feedkeys('', 'n')
  vim.bo.scrollback = scrollback
end

vim.keymap.set('t', '<c-l>', clear_terminal, { silent = true, desc = 'Clear terminal ' })

vim.cmd('autocmd TermOpen * startinsert')
vim.cmd('autocmd TermOpen * setlocal nonumber')
vim.cmd('autocmd TermEnter * setlocal signcolumn=no')

-- Version control.

if is_vanilla then
  vim.keymap.set(
    'n',
    '<leader>gc',
    '<cmd>FzfLua git_bcommits<cr>',
    { noremap = true, silent = true, desc = 'Find Git commit' }
  )
  vim.keymap.set(
    'n',
    '<leader>gb',
    '<cmd>FzfLua git_branches<cr>',
    { noremap = true, silent = true, desc = 'Find Git branch' }
  )
end

-- Misc.

vim.opt.laststatus = 3
vim.opt.splitkeep = 'screen'

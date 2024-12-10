require("config.lazy")

local is_vanilla = not vim.g.vscode
local is_vscode = not not vim.g.vscode

local map = vim.api.nvim_set_keymap

map('n', ';', ':', { noremap = true, silent = false })
map('v', ';', ':', { noremap = true, silent = false })

if is_vscode then
  local vscode = require('vscode')

  function vscode_action(action)
    return function()
      require('vscode').action(action)
    end
  end

  vim.keymap.set('n', '<leader><leader>', vscode_action('workbench.action.showCommands'), { noremap = true, silent = true, desc = 'Command palette' })
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
end


-- File navigation.

if is_vscode then
  vim.keymap.set('n', '<leader>ff', vscode_action('workbench.action.quickOpen'), { noremap = true, silent = true, desc = 'Find file' })
  vim.keymap.set('n', '<leader>bf', vscode_action('workbench.action.quickOpenPreviousRecentlyUsedEditorInGroup'), { noremap = true, silent = true, desc = 'Find file' })
  vim.keymap.set('n', '<leader>fo', vscode_action('workbench.action.files.openFile'), { noremap = true, silent = true, desc = 'Open file' })
  vim.keymap.set('n', '<leader>fO', vscode_action('workbench.action.files.openFolder'), { noremap = true, silent = true, desc = 'Open folder' })
  vim.keymap.set('n', '<leader>fr', vscode_action('workbench.action.openRecent'), { noremap = true, silent = true, desc = 'Open recent' })
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

map('n', 'j', 'gj', { noremap = true, silent = true })
map('n', 'k', 'gk', { noremap = true, silent = true })

map('n', '<C-h>', 'b', { noremap = true, silent = true, desc = 'Previous word' })
map('i', '<C-h>', '<C-o>b', { noremap = true, silent = true, desc = 'Previous word' })
map('v', '<C-h>', 'b', { noremap = true, silent = true, desc = 'Previous word' })

map('n', '<C-l>', 'w', { noremap = true, silent = true, desc = 'Next word' })
map('i', '<C-l>', '<C-o>w', { noremap = true, silent = true, desc = 'Next word' })
map('v', '<C-l>', 'w', { noremap = true, silent = true, desc = 'Next word' })

map('n', '<C-j>', '8j', { noremap = true, silent = true, desc = 'Previous word' })
map('i', '<C-j>', '<C-o>8j', { noremap = true, silent = true, desc = 'Previous word' })
map('v', '<C-j>', '8j', { noremap = true, silent = true, desc = 'Previous word' })

map('n', '<C-k>', '8k', { noremap = true, silent = true, desc = 'Next word' })
map('i', '<C-k>', '<C-o>8k', { noremap = true, silent = true, desc = 'Next word' })
map('v', '<C-k>', '8k', { noremap = true, silent = true, desc = 'Next word' })

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


-- Text editing.

map('n', 'U', '<C-r>', { noremap = true, silent = true })

if is_vanilla then
  map('n', '<C-c>', '"+y', { noremap = true, silent = true })
  map('v', '<C-c>', '"+y', { noremap = true, silent = true })
  map('i', '<C-v>', '<C-r>+', { noremap = true, silent = true })

  map('i', '<S-Tab>', '<C-d>', { noremap = true, silent = true })
end


-- LSP.

if is_vanilla then
  local cmp = require('cmp')
  cmp.setup({
    mapping = cmp.mapping.preset.insert({
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
    }),
  })

  local capabilities = require('cmp_nvim_lsp').default_capabilities()

  require('mason').setup()
  require('mason-lspconfig').setup({
    ensure_installed = { 'ts_ls' }
  })
  require('lspconfig')['ts_ls'].setup({ capabilities = capabilities })
  require('lspconfig')['marksman'].setup({ capabilities = capabilities })
end

vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { noremap = true, silent = true, desc = 'Go to definition' })
-- vim.keymap.set('n', '<leader>ch', '<cmd>Lspsaga hover_doc<cr>', { noremap = true, silent = true })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { noremap = true, silent = true, desc = 'Show references' })
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { noremap = true, silent = true, desc = 'Go to implementation' })

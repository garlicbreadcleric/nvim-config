local pkg = require('lib.pkg')
local env = require('lib.env')

local plugins = {}

pkg.add(plugins, {
  'folke/lazydev.nvim',
  ft = 'lua',
  cond = not env.is_vscode,
  opts = {
    library = { '~/.config/nvim' },
  },
})

pkg.add(plugins, {
  'neovim/nvim-lspconfig',
  cond = not env.is_vscode,
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    'Saghen/blink.cmp',
  },
  config = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)

    local servers = {
      vtsls = {
        settings = {
          ['typescript.format.enable'] = false,
          ['javascript.format.enable'] = false,
        },
      },
      lua_ls = {},
      eslint = {},
      ['js-debug-adapter'] = {},
    }
    local ensure_installed = vim.tbl_keys(servers or {})

    require('mason').setup()
    require('mason-tool-installer').setup({ ensure_installed = ensure_installed })
    require('mason-lspconfig').setup({
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    })
  end,
})

pkg.add(plugins, {
  'ray-x/lsp_signature.nvim',
  opts = {
    hint_prefix = '',
  },
  config = function(_, opts)
    require('lsp_signature').setup(opts)
  end,
})

local function show_hover()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local lnum = cursor_pos[1] - 1

  local diagnostics = vim.diagnostic.get(bufnr, { lnum = lnum })
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
        border = 'rounded',
        pad_left = 0,
        pad_right = 0,
        pad_top = 0,
        pad_bottom = 0,
      })
    end
  end)
end

local function lsp_definitions()
  if env.is_vscode then
    vim.lsp.buf.definition()
  else
    require('fzf-lua').lsp_definitions({ jump_to_single_result = true })
  end
end

local function lsp_references()
  if env.is_vscode then
    vim.lsp.buf.references()
  else
    require('fzf-lua').lsp_references({ jump_to_single_result = true })
  end
end

local function lsp_implementations()
  if env.is_vscode then
    vim.lsp.buf.implementation()
  else
    require('fzf-lua').lsp_implementations({ jump_to_single_result = true })
  end
end

local function lsp_type_definitions()
  if env.is_vscode then
    vim.lsp.buf.type_definition()
  else
    require('fzf-lua').lsp_type_definitions({ jump_to_single_result = true })
  end
end

local function lsp_document_symbols()
  if env.is_vscode then
    vim.lsp.buf.document_symbol()
  else
    require('fzf-lua').lsp_document_symbols({ jump_to_single_result = true })
  end
end

local function lsp_workspace_symbols()
  if env.is_vscode then
    vim.lsp.buf.workspace_symbol()
  else
    require('fzf-lua').lsp_workspace_symbols({ jump_to_single_result = true })
  end
end

vim.keymap.set('n', 'gd', lsp_definitions, { silent = true, desc = 'Go to definition' })
vim.keymap.set('n', 'gr', lsp_references, { silent = true, desc = 'Show references' })
vim.keymap.set('n', 'gi', lsp_implementations, { silent = true, desc = 'Go to implementation' })
vim.keymap.set('n', 'gt', lsp_type_definitions, { silent = true, desc = 'Go to type definition' })
vim.keymap.set('n', '<leader>cs', lsp_document_symbols, { silent = true, desc = 'Document symbols' })
vim.keymap.set('n', '<leader>cS', lsp_workspace_symbols, { noremap = true, silent = true, desc = 'Workspace symbols' })

if not env.is_vscode then
  vim.keymap.set('n', '<leader>cd', function()
    require('fzf-lua').diagnostics_document({ jump_to_single_result = true })
  end, { noremap = true, silent = true, desc = 'Find diagnostic' })
  vim.keymap.set('n', '<leader>ch', show_hover, { silent = true, desc = 'Hover' })
end

vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { noremap = true, silent = true, desc = 'Code actions' })
vim.keymap.set('v', '<leader>ca', vim.lsp.buf.code_action, { noremap = true, silent = true, desc = 'Code actions' })
vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { noremap = true, silent = true, desc = 'Rename' })

return plugins

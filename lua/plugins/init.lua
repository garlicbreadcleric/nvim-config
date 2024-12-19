local is_vanilla = not vim.g.vscode
local is_vscode = not not vim.g.vscode

return {
  -- Appearance.
  {
    'maxmx03/solarized.nvim',
    lazy = false,
    priority = 1000,
    ---@type solarized.config
    opts = {},
    config = function(_, opts)
      vim.o.termguicolors = true
      vim.o.background = 'light'
      require('solarized').setup(opts)
      vim.cmd.colorscheme('solarized')
    end,
  },
  {
    'stevearc/dressing.nvim',
    lazy = false,
    opts = {},
  },

  -- Help.
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    cond = is_vanilla,
    opts = {},
    keys = {
      {
        '<leader>?',
        function()
          require('which-key').show({ global = false })
        end,
        desc = 'Buffer local keymaps (which-key)',
      },
    },
  },

  -- Project management.
  {
    'klen/nvim-config-local',
    opts = {
      config_files = { '.nvim.lua' },
      hashfile = vim.fn.stdpath('data') .. '/config-local',
      autocommands_create = true,
      commands_create = true,
      silent = false,
      lookup_parents = true,
    },
  },

  -- File navigation.
  {
    'junegunn/fzf',
    cond = is_vanilla,
  },
  {
    "ibhagwan/fzf-lua",
    cond = is_vanilla,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("fzf-lua").setup({ 'borderless_full', fzf_colors = true })
    end,
  },

  -- Text navigation.
  {
    'rhysd/clever-f.vim',
    init = function()
      vim.g.clever_f_timeout_ms = 3000
      vim.g.clever_f_highlight_timeout_ms = 3000
      vim.g.clever_f_smart_case = true
    end,
  },

  -- Text editing.
  {
    'AndrewRadev/switch.vim',
    keys = {
      { ',s', '<cmd>Switch<cr>', desc = 'Switch' },
    },
    init = function()
      vim.g.switch_mapping = ''
    end,
  },

  -- Intellisense.
  { 'nvim-treesitter/nvim-treesitter-textobjects' },
  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      if is_vscode then
        vim.cmd('TSDisable highlight')
      end

      local configs = require('nvim-treesitter.configs')
      configs.setup({
        fold = { enable = true },
        ensure_installed = {
          'markdown',
          'javascript',
          'typescript',
          'lua',
          'python'
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ib'] = '@block.inner',
              ['ab'] = '@block.outer',
              ['ic'] = '@class.inner',
              ['ac'] = '@class.outer',
              ['i/'] = '@comment.outer',  -- comment.inner doesn't work for me, so set this as just an alias.
              ['a/'] = '@comment.outer',
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              [']f'] = '@function.outer',
              [']b'] = '@block.outer',
              [']c'] = '@class.outer',
              [']/'] = '@comment.outer',
            },
            goto_previous_start = {
              ['[f'] = '@function.outer',
              ['[b'] = '@block.outer',
              ['[c'] = '@class.outer',
              ['[/'] = '@comment.outer',
            },
            goto_next = {
              [']F'] = '@function.outer',
              [']B'] = '@block.outer',
              [']C'] = '@class.outer',
            },
            goto_previous = {
              ['[F'] = '@function.outer',
              ['[B'] = '@block.outer',
              ['[C'] = '@class.outer',
            },
          },
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '{',
            node_incremental = '}',
            node_decremental = '{',
          },
        },
      })
      vim.api.nvim_set_keymap('n', '}', ':lua require"nvim-treesitter.incremental_selection".init_selection()<CR>', { noremap = true, silent = true })
    end,
  },
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    cond = is_vanilla,
    opts = {
      library = { '~/.config/nvim' },
    },
  },
  {
    'neovim/nvim-lspconfig',
    cond = is_vanilla,
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'Saghen/blink.cmp',
    },
    config = function ()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)

      local servers = {
        ts_ls = {},
        lua_ls = {},
        eslint = {},
      }
      local ensure_installed = vim.tbl_keys(servers or {})

      require('mason').setup()
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }
      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
  {
    'Saghen/blink.cmp',
    -- version = 'v0.*',
    build = 'cargo build --release',
    cond = is_vanilla,
    lazy = false,
    dependencies = { 'L3MON4D3/LuaSnip' },
    opts = {
      keymap = {
        ['<c-x>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<c-e>'] = { 'cancel', 'fallback' },
        ['<tab>'] = {
          'snippet_forward',
          'accept',
          'fallback',
        },
        ['<c-y>'] = { 'select_and_accept', 'fallback' },
        ['<c-k>'] = { 'select_prev', 'fallback' },
        ['<up>'] = { 'select_prev', 'fallback' },
        ['<c-j>'] = { 'select_next', 'fallback' },
        ['<down>'] = { 'select_next', 'fallback' },
      },
      snippets = {
        expand = function(snippet) require('luasnip').lsp_expand(snippet) end,
        active = function(filter)
          if filter and filter.direction then
            return require('luasnip').jumpable(filter.direction)
          end
        end,
        jump = function(direction) require('luasnip').jump(direction) end,
      },
      sources = {
        default = { 'luasnip', 'lsp', 'path', 'buffer', 'lazydev' },
        providers = {
          lsp = {},
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            fallbacks = { 'lsp' },
          },
          luasnip = {
            name = 'luasnip',
            module = 'blink.cmp.sources.luasnip',

            score_offset = -1,
          },
        },
      },
    },
  },
  {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    config = function ()
      require('luasnip.loaders.from_snipmate').lazy_load()
    end,
  },

  -- Formatting.
  {
    'editorconfig/editorconfig-vim'
  },

  -- Notes
  {
    'zk-org/zk-nvim',
    config = function()
      require('zk').setup({
        picker = 'fzf_lua',
      })
    end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    cond = is_vanilla,
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' },
    opts = {},
  },

  -- Misc.
  {
    'echasnovski/mini.nvim',
    version = '*',
    config = function()
      require('mini.move').setup({})
      require('mini.surround').setup({})
      require('mini.comment').setup({
        mappings = {
          comment = '',
          comment_line = '<C-_>',
          comment_visual = '<C-_>',
          textobject = '',
        }
      })

      if is_vanilla then
        require('mini.pairs').setup({})

        local function mini_files_reveal()
          local path = vim.bo.buftype ~= 'nofile' and vim.api.nvim_buf_get_name(0) or nil
          MiniFiles.open(path)
        end
        require('mini.files').setup({})
        vim.keymap.set('n', '<leader>fE', '<cmd>:lua MiniFiles.open()<cr>', { noremap = true, silent = true, desc = 'File explorer' })
        vim.keymap.set('n', '<leader>fe', mini_files_reveal, { noremap = true, silent = true, desc = 'File explorer' })
      end
    end
  },
  {
    'folke/snacks.nvim',
    opts = {
      words = { enabled = is_vanilla },
      notifier = { enabled = is_vanilla },
      rename = { enabled = is_vanilla },
    },
    config = function(_, opts)
      require('snacks').setup(opts)
      if is_vanilla then
        vim.api.nvim_create_autocmd('User', {
          pattern = 'MiniFilesActionRename',
          callback = function(event)
            Snacks.rename.on_rename_file(event.data.from, event.data.to)
          end,
        })
      end
    end,
  }
}

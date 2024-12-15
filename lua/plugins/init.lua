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

  -- File navigation.
  {
    'nvim-telescope/telescope.nvim',
    cond = is_vanilla,
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-ui-select.nvim' },
    opts = {
      defaults = {
        mappings = {
          i = {
            ['<C-j>'] = 'move_selection_next',
            ['<C-k>'] = 'move_selection_previous',
          },
        },
      },
    },
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
        vim.cmd("TSDisable highlight")
      end

      local configs = require('nvim-treesitter.configs')
      configs.setup({
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
      library = { "~/.config/nvim" },
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

      vim.keymap.set('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', { silent = true })
      vim.keymap.set('v', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', { silent = true })
    end,
  },
  {
    'saghen/blink.cmp',
    version = 'v0.*',
    cond = is_vanilla,
    lazy = false,
    dependencies = { 'L3MON4D3/LuaSnip', version = 'v2.*' },
    opts = {
      keymap = {
        preset = 'super-tab',
        ['<c-k>'] = { 'select_prev', 'fallback' },
        ['<c-j>'] = { 'select_next', 'fallback' },
      },
      snippets = {
        expand = function(snippet) require('luasnip').lsp_expand(snippet) end,
        active = function(filter)
          if filter and filter.direction then
            return require('luasnip').jumpable(filter.direction)
          end
          return require('luasnip').in_snippet()
        end,
        jump = function(direction) require('luasnip').jump(direction) end,
      },
      sources = {
        completion = {
          enabled_providers = { 'lsp', 'path', 'luasnip', 'buffer', 'lazydev' },
        },
        providers = {
          lsp = { fallback_for = { 'lazydev' } },
          lazydev = { name = 'LazyDev', module = 'lazydev.integrations.blink' },
        },
      },
    },
  },

  -- Formatting.
  {
    'editorconfig/editorconfig-vim'
  },

  -- Notes
  {
    "zk-org/zk-nvim",
    config = function()
      require("zk").setup({
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
      -- require('mini.bracketed').setup({})
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
      require('mini.ai').setup({
        mappings = {
          goto_left = 'g[',
          goto_right = 'g]',
        },
      })

      if is_vanilla then
        require('mini.pairs').setup({})
        require('mini.files').setup({})
        vim.keymap.set('n', '<leader>fe', '<cmd>:lua MiniFiles.open()<cr>', { noremap = true, silent = true, desc = 'File explorer' })
      end
    end
  },
  {
    "folke/snacks.nvim",
    opts = {
    }
  }
}

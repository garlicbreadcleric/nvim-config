local is_vanilla = not vim.g.vscode
local is_vscode = not not vim.g.vscode

return {
  -- Appearance.
  -- {
  --   'projekt0n/github-nvim-theme',
  --   name = 'github-theme',
  --   cond = is_vanilla,
  --   lazy = false, -- make sure we load this during startup if it is your main colorscheme
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   config = function()
  --     require('github-theme').setup({})
  --     vim.cmd('colorscheme github_light')
  --   end,
  -- },
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
  -- {
  --   "nvim-tree/nvim-tree.lua",
  --   version = "*",
  --   lazy = false,
  --   cond = is_vanilla,
  --   dependencies = {
  --     "nvim-tree/nvim-web-devicons",
  --   },
  --   config = function()
  --     require("nvim-tree").setup {}
  --   end,
  -- },
  
  -- Text navigation.
  {
    'junegunn/fzf',
    cond = is_vanilla,
  },
  {
    "ibhagwan/fzf-lua",
    cond = is_vanilla,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("fzf-lua").setup({ fzf_colors = true })
    end,
    keys = {
      { '<leader><leader>', '<cmd>FzfLua commands resume=true<cr>', desc = 'Command palette' },
      { '<leader>ff', '<cmd>FzfLua files resume=true<cr>', desc = 'Find file' },
      { '<leader>fs', '<cmd>FzfLua live_grep resume=true<cr>', desc = 'Search in files' },
      { '<leader>bf', '<cmd>FzfLua buffers resume=true<cr>', desc = 'Find buffer' },
      { '<leader>ca', '<cmd>FzfLua lsp_code_actions resume=true<cr>', desc = 'Code actions' },
      { '<leader>cd', '<cmd>FzfLua lsp_definitions resume=true<cr>', desc = 'Code definitions' },
      { '<leader>cs', '<cmd>FzfLua lsp_document_symbols resume=true<cr>', desc = 'Code symbols (document)' },
      { '<leader>cS', '<cmd>FzfLua lsp_live_workspace_symbols resume=true<cr>', desc = 'Code symbols (workspace)' },
      { '<leader>cr', '<cmd>FzfLua lsp_references resume=true<cr>', desc = 'Code references' },
      { '<leader>ci', '<cmd>FzfLua lsp_implementations resume=true<cr>', desc = 'Code implementations' },
      { '<leader>cw', '<cmd>FzfLua lsp_document_diagnostics resume=true<cr>', desc = 'Code warnings (document)' },
      { '<leader>cW', '<cmd>FzfLua lsp_workspace_diagnostics resume=true<cr>', desc = 'Code warnings (workspace)' },
    },
  },
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
      'hrsh7th/nvim-cmp',
    },
    config = function ()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

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
  -- { 'hrsh7th/cmp-nvim-lsp', cond = is_vanilla },
  {
    'hrsh7th/nvim-cmp',
    cond = is_vanilla,
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
      },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function ()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      luasnip.config.setup({})

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<tab>'] = cmp.mapping.confirm({ select = true }),
          ['<c-j>'] = cmp.mapping.select_next_item(),
          ['<c-k>'] = cmp.mapping.select_prev_item(),
          ['<c-l>'] = cmp.mapping(function ()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<c-h>'] = cmp.mapping(function ()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          {
            name = 'lazydev',
            group_index = 0,
          },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        }),
      })
    end,
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

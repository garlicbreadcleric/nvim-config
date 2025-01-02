local is_vanilla = not vim.g.vscode
local is_vscode = not not vim.g.vscode
local is_windows = vim.loop.os_uname().sysname:find('Windows') and true or false

local disable_resession = os.getenv('NVIM_DISABLE_RESESSION')

return {
  -- Appearance.
  {
    'maxmx03/solarized.nvim',
    lazy = false,
    cond = is_vanilla,
    priority = 1000,
    ---@type solarized.config
    opts = {},
    config = function(_, opts)
      vim.o.termguicolors = true
      vim.o.background = 'light'
      require('solarized').setup(opts)
      vim.cmd.colorscheme('solarized')
      -- vim.cmd('hi Normal guibg=NONE ctermbg=NONE')
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
    config = function(_, opts)
      local wk = require('which-key')
      wk.setup(opts)
      wk.add({
        { '<leader>f', group = 'File' },
        { '<leader>c', group = 'Code' },
        { '<leader>b', group = 'Buffer' },
        { '<leader>g', group = 'Git' },
        { '<leader>w', group = 'Window' },
        -- { '<leader>n', group = 'Note' },
        { '<leader>j', group = 'Jump' },
        { '<ledaer>m', group = 'Mark' },
      })
    end,
  },

  -- Workspaces.
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
  {
    'stevearc/resession.nvim',
    cond = is_vanilla and not disable_resession,
    lazy = false,
    opts = {
      autosave = {
        enabled = true,
        interval = 60,
        notify = true,
      },
    },
    config = function(_, opts)
      local resession = require('resession')
      resession.setup(opts)
      vim.api.nvim_create_autocmd('VimEnter', {
        callback = function()
          if disable_resession or vim.fn.argc(-1) > 0 then
            return
          end
          resession.load(vim.fn.getcwd(), { dir = 'dirsession', silence_errors = true })
        end,
        nested = true,
      })
      vim.api.nvim_create_autocmd('VimLeavePre', {
        callback = function()
          if disable_resession then
            return
          end
          resession.save(vim.fn.getcwd(), { dir = 'dirsession', notify = false })
        end,
      })
    end,
  },
  {
    'stevearc/stickybuf.nvim',
    cond = is_vanilla,
    lazy = false,
    keys = {
      { '<leader>wp', '<cmd>PinBuffer<cr>', { noremap = true, silent = true, desc = 'Pin buffer to window' } },
    },
    opts = {
      get_auto_pin = function(buf)
        local path = vim.api.nvim_buf_get_name(buf)
        local name = vim.fn.fnamemodify(path, ':t')
        if name == 'todo.md' or name == 'done.md' then
          return 'bufnr'
        end
      end,
    },
  },

  -- File navigation.
  {
    'junegunn/fzf',
    cond = is_vanilla,
  },
  {
    'ibhagwan/fzf-lua',
    cond = is_vanilla,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('fzf-lua').setup({ 'borderless_full', fzf_colors = true })
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
  -- {
  --   'AndrewRadev/switch.vim',
  --   keys = {
  --     { ',s', '<cmd>Switch<cr>', desc = 'Switch' },
  --   },
  --   init = function()
  --     vim.g.switch_mapping = ''
  --   end,
  -- },

  -- Intellisense.
  { 'nvim-treesitter/nvim-treesitter-textobjects' },
  {
    'nvim-treesitter/nvim-treesitter',
    main = 'nvim-treesitter.configs',
    lazy = false,
    opts = {
      fold = { enable = true },
      highlights = { enable = is_vanilla },
      indent = { enable = true },
      ensure_installed = {
        'javascript',
        'json',
        'lua',
        'markdown',
        'python',
        'tsx',
        'typescript',
        'yaml',
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
            ['i/'] = '@comment.outer', -- comment.inner doesn't work for me, so set this as just an alias.
            ['a/'] = '@comment.outer',
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            [']f'] = '@function.outer',
            -- [']b'] = '@block.outer',
            -- [']c'] = '@class.outer',
            [']/'] = '@comment.outer',
          },
          goto_previous_start = {
            ['[f'] = '@function.outer',
            -- ['[b'] = '@block.outer',
            -- ['[c'] = '@class.outer',
            ['[/'] = '@comment.outer',
          },
          -- goto_next = {
          --   [']F'] = '@function.outer',
          --   [']B'] = '@block.outer',
          --   [']C'] = '@class.outer',
          -- },
          -- goto_previous = {
          --   ['[F'] = '@function.outer',
          --   ['[B'] = '@block.outer',
          --   ['[C'] = '@class.outer',
          -- },
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
    },
    config = function(_, opts)
      local configs = require('nvim-treesitter.configs')
      configs.setup(opts)
      vim.api.nvim_set_keymap(
        'n',
        '}',
        ':lua require"nvim-treesitter.incremental_selection".init_selection()<CR>',
        { noremap = true, silent = true }
      )
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
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)

      local servers = {
        -- ts_ls = {},
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
  },

  -- Completion.
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
        ['<tab>'] = { 'snippet_forward', 'accept', 'fallback' },
        ['<c-y>'] = { 'select_and_accept', 'fallback' },
        ['<c-k>'] = { 'select_prev', 'fallback' },
        ['<up>'] = { 'select_prev', 'fallback' },
        ['<c-j>'] = { 'select_next', 'fallback' },
        ['<down>'] = { 'select_next', 'fallback' },
      },
      snippets = {
        expand = function(snippet)
          require('luasnip').lsp_expand(snippet)
        end,
        active = function(filter)
          if filter and filter.direction then
            return require('luasnip').jumpable(filter.direction)
          end
        end,
        jump = function(direction)
          require('luasnip').jump(direction)
        end,
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
            score_offset = -3,
          },
        },
      },
    },
  },

  -- Snippets.
  {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    config = function()
      require('luasnip.loaders.from_snipmate').lazy_load()
    end,
  },

  -- Formatting.
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        javascript = { 'prettierd' },
        typescript = { 'prettierd' },
        typescriptreact = { 'prettierd' },
        json = { 'prettierd' },
        yaml = { 'prettierd' },
        lua = { 'stylua' },
      },
    },
    keys = {
      {
        '<leader>cf',
        function()
          require('conform').format()
        end,
        desc = 'Format code',
      },
    },
  },

  -- Comments/documentation.
  {
    'folke/todo-comments.nvim',
    cond = is_vanilla,
    lazy = false,
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      signs = false,
    },
    keys = {
      { '<leader>ct', '<cmd>TodoFzfLua<cr>', desc = 'Find TODO comments' },
    },
  },

  -- Terminal.
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    opts = {
      open_mapping = [[<c-\>]],
      shade_terminals = false,
    },
  },

  -- Notes
  {
    'zk-org/zk-nvim',
    cond = not is_windows,
    lazy = false,
    opts = {
      picker = 'fzf_lua',
    },
    config = function(_, opts)
      require('zk').setup(opts)
    end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    cond = is_vanilla,
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' },
    opts = {},
  },

  -- Version control.
  {
    'sindrets/diffview.nvim',
    cond = is_vanilla,
    keys = {
      { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = 'Git diff' },
      { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = 'Git history (current file)' },
      { '<leader>gH', '<cmd>DiffviewFileHistory<cr>', desc = 'Git history' },
    },
    opts = function()
      local actions = require('diffview.actions')
      return {
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
      }
    end,
    setup = function(_, opts)
      require('diffview').setup(opts)
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    cond = is_vanilla,
    lazy = false,
    opts = {
      current_line_blame = true,
    },
    config = function(_, opts)
      local gitsigns = require('gitsigns')
      gitsigns.setup(opts)
    end,
    keys = {
      {
        '[c',
        function()
          local gitsigns = require('gitsigns')
          if vim.wo.diff then
            vim.cmd.normal({ '[c', bang = true })
          else
            gitsigns.nav_hunk('prev')
          end
        end,
        desc = 'Previous change',
      },
      {
        ']c',
        function()
          local gitsigns = require('gitsigns')
          if vim.wo.diff then
            vim.cmd.normal({ ']c', bang = true })
          else
            gitsigns.nav_hunk('next')
          end
        end,
        desc = 'Next change',
      },
    },
  },
  {
    'NeogitOrg/neogit',
    cond = is_vanilla,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
      'ibhagwan/fzf-lua',
    },
    opts = {
      kind = 'floating',
    },
    config = true,
    keys = {
      { '<leader>gs', '<cmd>Neogit<cr>', desc = 'Git status' },
    },
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
        },
      })

      if is_vanilla then
        require('mini.pairs').setup({})

        local function mini_files_reveal()
          local path = vim.bo.buftype ~= 'nofile' and vim.api.nvim_buf_get_name(0) or nil
          MiniFiles.open(path)
        end
        require('mini.files').setup({})
        vim.keymap.set(
          'n',
          '<leader>fE',
          '<cmd>:lua MiniFiles.open()<cr>',
          { noremap = true, silent = true, desc = 'File explorer' }
        )
        vim.keymap.set(
          'n',
          '<leader>fe',
          mini_files_reveal,
          { noremap = true, silent = true, desc = 'File explorer (reveal current)' }
        )
      end
    end,
  },
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      words = { enabled = is_vanilla },
      notifier = { enabled = is_vanilla },
      rename = { enabled = is_vanilla },
      lazygit = { enabled = is_vanilla },
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
    keys = {
      {
        '<leader>gg',
        function()
          require('snacks').lazygit()
        end,
        desc = 'Lazygit',
      },
    },
  },
}

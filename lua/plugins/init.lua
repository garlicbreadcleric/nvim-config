local is_vanilla = not vim.g.vscode
local is_vscode = not not vim.g.vscode

return {
  -- Appearance.
  {
    'projekt0n/github-nvim-theme',
    name = 'github-theme',
    cond = is_vanilla,
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require('github-theme').setup({})
      vim.cmd('colorscheme github_light')
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
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    cond = is_vanilla,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup {}
    end,
  },
  
  -- Text navigation.
  {
    'junegunn/fzf',
    cond = is_vanilla,
  },
  {
    'junegunn/fzf.vim',
    cond = is_vanilla,
    keys = {
      { '<leader><leader>', '<cmd>Commands<cr>', desc = 'Command palette' },
      { '<leader>ff', '<cmd>Files<cr>', desc = 'Find file' },
      { '<leader>bf', '<cmd>Buffers<cr>', desc = 'Find buffer' },
      { '<leader>fs', '<cmd>Rg<cr>', desc = 'Find in files' }
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
        ensure_installed = { 'markdown', 'javascript', 'typescript', 'lua', 'python' },

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
  -- {
  --   "sustech-data/wildfire.nvim",
  --   event = "VeryLazy",
  --   dependencies = { "nvim-treesitter/nvim-treesitter" },
  --   config = function()
  --     require("wildfire").setup()
  --   end,
  -- },
  { 'williamboman/mason.nvim', cond = is_vanilla },
  { 'williamboman/mason-lspconfig.nvim', cond = is_vanilla },
  { 'neovim/nvim-lspconfig', cond = is_vanilla },
  { 'hrsh7th/cmp-nvim-lsp', cond = is_vanilla },
  { 'hrsh7th/nvim-cmp', cond = is_vanilla },
  -- {
  --   'nvimdev/lspsaga.nvim',
  --   cond = is_vanilla,
  --   config = function()
  --     require('lspsaga').setup({})
  --   end,
  --   dependencies = {
  --     'nvim-treesitter/nvim-treesitter', -- optional
  --     'nvim-tree/nvim-web-devicons',     -- optional
  --   }
  -- },

  -- Formatting.
  {
    'editorconfig/editorconfig-vim'
  },

  -- Notes.
  -- {
  --   "epwalsh/obsidian.nvim",
  --   version = "*",  -- recommended, use latest release instead of latest commit
  --   lazy = true,
  --   ft = "markdown",
  --   dependencies = {
  --     -- Required.
  --     "nvim-lua/plenary.nvim",
  --
  --     -- see below for full list of optional dependencies 👇
  --   },
  --   opts = {
  --     workspaces = {
  --       {
  --         name = "notes",
  --         path = "~/Dropbox/Documents/Notes2",
  --       },
  --     },
  --
  --     -- see below for full list of options 👇
  --   },
  -- },

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

      if is_vanilla then
        require('mini.pairs').setup({})
      end
    end
  },
}

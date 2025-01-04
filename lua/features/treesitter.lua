local env = require('lib.env')

return {
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  {
    'aaronik/treewalker.nvim',
    keys = {
      { '<c-s-h>', '<cmd>Treewalker Left<cr>', { modes = { 'n', 'v' }, silent = true, desc = 'Treewalker left' } },
      { '<c-s-j>', '<cmd>Treewalker Down<cr>', { modes = { 'n', 'v' }, silent = true, desc = 'Treewalker down' } },
      { '<c-s-k>', '<cmd>Treewalker Up<cr>', { modes = { 'n', 'v' }, silent = true, desc = 'Treewalker up' } },
      { '<c-s-l>', '<cmd>Treewalker Right<cr>', { modes = { 'n', 'v' }, silent = true, desc = 'Treewalker right' } },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter',
    main = 'nvim-treesitter.configs',
    lazy = false,
    opts = {
      fold = { enable = true },
      highlights = { enable = env.is_vanilla },
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
      vim.keymap.set(
        'n',
        '}',
        ':lua require"nvim-treesitter.incremental_selection".init_selection()<CR>',
        { noremap = true, silent = true }
      )
      vim.cmd('TSEnable highlight')
    end,
  },
}

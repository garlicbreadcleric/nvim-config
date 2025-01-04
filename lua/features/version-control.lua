local pkg = require('lib.pkg')
local env = require('lib.env')

local plugins = {}

pkg.add(plugins, {
  'sindrets/diffview.nvim',
  cond = env.is_vanilla,
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
})

pkg.add(plugins, {
  'lewis6991/gitsigns.nvim',
  cond = env.is_vanilla,
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
    { '<leader>g!', '<cmd>Gitsigns blame<cr>', desc = 'Git blame' },
  },
})

pkg.add(plugins, {
  'NeogitOrg/neogit',
  cond = env.is_vanilla,
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
})

if env.is_vanilla then
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

return plugins

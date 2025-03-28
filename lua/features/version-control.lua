local pkg = require('lib.pkg')
local env = require('lib.env')

local plugins = {}

pkg.add(plugins, {
  'sindrets/diffview.nvim',
  cond = not env.is_vscode,
  lazy = false,
  keys = {
    { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = 'Git diff' },
    { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = 'Git history (current file)' },
    { '<leader>gH', '<cmd>DiffviewFileHistory<cr>', desc = 'Git history' },
  }, --
  opts = function()
    local actions = require('diffview.actions')
    return {
      view = {
        merge_tool = {
          layout = 'diff1_plain',
        },
      },
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
  main = 'diffview',
  setup = true,
})

pkg.add(plugins, {
  'lewis6991/gitsigns.nvim',
  cond = not env.is_vscode,
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

pkg.add(plugins, { 'akinsho/git-conflict.nvim', version = '*', config = true })

if not env.is_vscode then
  vim.keymap.set('n', '<leader>gl', function()
    Snacks.picker.git_log()
  end, { noremap = true, silent = true, desc = 'Git log' })
  vim.keymap.set('n', '<leader>gb', function()
    Snacks.picker.git_branches()
  end, { noremap = true, silent = true, desc = 'Find Git branch' })
  vim.keymap.set('n', '<leader>gs', function()
    Snacks.picker.git_status()
  end)
end

return plugins

local env = require('lib.env')

return {
  {
    'folke/todo-comments.nvim',
    cond = env.is_vanilla,
    lazy = false,
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      signs = false,
    },
    keys = {
      { '<leader>ct', '<cmd>TodoFzfLua<cr>', desc = 'Find TODO comments' },
    },
  },
}

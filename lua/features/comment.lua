local env = require('lib.env')

vim.keymap.set('n', '<leader>ct', function()
  Snacks.picker.todo_comments()
end, { noremap = true, silent = true, desc = 'Find TODO comments' })

return {
  {
    'folke/todo-comments.nvim',
    cond = not env.is_vscode,
    lazy = false,
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      signs = false,
    },
  },
}

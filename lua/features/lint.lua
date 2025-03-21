local pkg = require('lib.pkg')
local env = require('lib.env')

local plugins = {}

-- pkg.add(plugins, {
--   'mfussenegger/nvim-lint',
--   cond = not env.is_vscode,
--   config = function()
--     vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
--       callback = function()
--         require('lint').try_lint()
--       end,
--     })
--   end,
-- })

return plugins

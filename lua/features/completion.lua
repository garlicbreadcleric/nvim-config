local env = require('lib.env')

return {
  {
    'Saghen/blink.cmp',
    version = 'v0.*',
    build = 'cargo build --release',
    cond = env.is_vanilla,
    lazy = false,
    dependencies = { 'L3MON4D3/LuaSnip' },
    opts = {
      keymap = {
        ['<c-x>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<c-e>'] = { 'cancel', 'fallback' },
        ['<tab>'] = { 'accept', 'fallback' },
        ['<c-l>'] = { 'snippet_forward', 'fallback' },
        ['<c-h>'] = { 'snippet_backward', 'fallback' },
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
}

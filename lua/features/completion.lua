local env = require('lib.env')

local blink_keymap = {
  ['<c-x>'] = { 'show', 'show_documentation', 'hide_documentation' },
  ['<c-e>'] = { 'cancel', 'fallback' },
  ['<tab>'] = { 'accept', 'fallback' },
  ['<c-l>'] = { 'snippet_forward', 'fallback' },
  ['<c-h>'] = { 'snippet_backward', 'fallback' },
  ['<c-k>'] = { 'select_prev', 'fallback' },
  ['<up>'] = { 'select_prev', 'fallback' },
  ['<c-j>'] = { 'select_next', 'fallback' },
  ['<down>'] = { 'select_next', 'fallback' },
}

local blink_cmdline_keymap = require('pl.tablex').copy(blink_keymap)
blink_cmdline_keymap['<c-k>'] = { 'show', 'select_prev', 'fallback' }
blink_cmdline_keymap['<c-j>'] = { 'show', 'select_next', 'fallback' }

return {
  {
    'Saghen/blink.cmp',
    version = 'v0.*',
    build = 'cargo build --release',
    cond = not env.is_vscode,
    lazy = false,
    dependencies = { 'L3MON4D3/LuaSnip' },
    opts = {
      keymap = blink_keymap,
      cmdline = {
        keymap = blink_cmdline_keymap,
        completion = { menu = { auto_show = true } },
      },
      sources = {
        default = { 'snippets', 'lsp', 'path', 'buffer', 'lazydev' },
        providers = {
          lsp = {},
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            fallbacks = { 'lsp' },
          },
        },
      },
    },
  },
}

local ls = require('luasnip')
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require('luasnip.extras.fmt').fmt
local fmta = require('luasnip.extras.fmt').fmta
local rep = require('luasnip.extras').rep

local date_format = '%a, %b %-d, %Y'

return {
  s('today', {
    f(function()
      return os.date(date_format)
    end, {}),
  }),
  s('yesterday', {
    f(function()
      local t = os.time() - 86400 -- Subtract 24 hours (86400 seconds)
      return os.date(date_format, t)
    end, {}),
  }),
  s('tomorrow', {
    f(function()
      local t = os.time() + 86400 -- Subtract 24 hours (86400 seconds)
      return os.date(date_format, t)
    end, {}),
  }),
}

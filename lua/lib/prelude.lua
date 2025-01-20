local prelude = {}

function prelude.contains(t, val)
  return require('pl.tablex').find(t, val) ~= nil
end

return prelude

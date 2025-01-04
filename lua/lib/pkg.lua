local pkg = {}

---@param spec LazyPluginSpec
function pkg.add(plugins, spec)
  table.insert(plugins, spec)
end

return pkg

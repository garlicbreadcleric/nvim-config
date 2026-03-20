if not vim.g.vscode and not vim.b.editorconfig then
  vim.opt_local.tabstop = 2
  vim.opt_local.shiftwidth = 2
  vim.opt_local.expandtab = true
  vim.opt_local.smartindent = true
  vim.opt_local.autoindent = true
end

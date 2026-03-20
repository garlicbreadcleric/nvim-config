if not vim.g.vscode then
  vim.keymap.set({ 'i' }, '<tab>', '<c-t>', { buffer = true, noremap = true, silent = true })
  vim.keymap.set({ 'i' }, '<s-tab>', '<c-d>', { buffer = true, noremap = true, silent = true })

  vim.opt_local.wrap = true
  vim.opt_local.linebreak = true
  vim.opt_local.breakindent = true
  vim.opt_local.number = false
  vim.opt_local.signcolumn = 'no'

  if vim.bo.buftype ~= 'nofile' then
    vim.api.nvim_buf_del_keymap(0, 'n', '[[')
    vim.api.nvim_buf_del_keymap(0, 'n', ']]')
  end
end

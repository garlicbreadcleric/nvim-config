local is_vanilla = not vim.g.vscode
local is_vscode = not not vim.g.vscode

local function contains(list, str)
  for _, value in ipairs(list) do
    if value == str then
      return true
    end
  end
  return false
end

if is_vanilla then
  vim.api.nvim_create_autocmd('BufWritePre', {
    callback = function()
      local mode = vim.api.nvim_get_mode().mode
      local filetype = vim.bo.filetype
      if vim.bo.modified == true and mode == 'n' and contains({ 'lua' }, filetype) then
        require('conform').format()
      end
    end,
  })
end

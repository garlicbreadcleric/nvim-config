local tag = {}

function tag.get_tag_under_cursor()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1
  local tag = line:match('|([^|]+)|', col - #line)
  return tag or vim.fn.expand('<cword>')
end

return tag

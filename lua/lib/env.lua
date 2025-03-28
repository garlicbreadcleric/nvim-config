local env = {}

local function get_env(name, default)
  local env_var = os.getenv(name)
  if env_var == nil then
    return default
  end
  env_var = env_var:lower()
  env_var = env_var:match('^%s*(.-)%s*$')
  return env_var == '1' or env_var == 'true'
end --

env.is_vscode = not not vim.g.vscode
env.is_neovide = vim.g.neovide
env.is_vanilla = not env.is_vscode
env.is_windows = vim.loop.os_uname().sysname:find('Windows') and true or false

env.enable_copilot = get_env('NVIM_ENABLE_COPILOT', true)

return env

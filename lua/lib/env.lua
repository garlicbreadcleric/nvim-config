local env = {}

env.is_vscode = not not vim.g.vscode
env.is_vanilla = not env.is_vscode
env.is_windows = vim.loop.os_uname().sysname:find('Windows') and true or false

env.disable_resession = os.getenv('NVIM_DISABLE_RESESSION')

return env

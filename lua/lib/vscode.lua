local vscode = {}

function vscode.action(action)
  return function()
    require('vscode').action(action)
  end
end

return vscode

local pick = {}

---@param picker snacks.Picker
---@param item snacks.picker.Item
function pick.confirm(picker, item)
  picker:close()
  local selected = picker:selected()
  if #selected > 1 then
    Snacks.picker.actions.qflist(picker)
  else
    Snacks.picker.actions.jump(picker, item, { action = 'confirm' })
  end
end

return pick

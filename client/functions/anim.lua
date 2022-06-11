ATL.PlayAnim = function(data)
  if type(data) ~= 'table' or not data.dict or not data.anim then
    return
  end

  ATL.RequestDict(data.dict)
  TaskPlayAnim(
    data.player or PlayerPedId(),
    data.dict,
    data.anim,
    data.blendInSpeed or 8.0,
    data.blendOutSpeed or 8.0,
    data.duration or -1,
    data.flag or 0,
    data.time or 0.0,
    data.stopOnLastFrame or false,
    data.lockX or false,
    data.lockY or false,
    data.lockZ or true
  )
  RemoveAnimDict(data.dict)
end

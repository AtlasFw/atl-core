exports('get', function()
  local resourceName = GetInvokingResource()
  if not ATL.Resources[resourceName] then
    ATL.Resources[resourceName] = resourceName
  end
  return ATL
end)

exports('test', function(playerId)
  local player = ATL.Players[playerId]
  return setmetatable(player, {
    __index = function(player, ...)
      return player.__index[...]
    end,
  })
end)
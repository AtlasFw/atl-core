-- Don't use these export. Use the import.
-- If you need further help read the documentation.
-- https://atlasfw.live/documentation

exports('get', function()
  local resourceName = GetInvokingResource()
  if not ATL.Resources[resourceName] then
    ATL.Resources[resourceName] = resourceName
  end
  return ATL
end)

exports('GetPlayer', function(playerId)
  return ATL.Players[playerId]
end)

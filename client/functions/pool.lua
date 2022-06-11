ATL.GetPlayersFromCoords = function(coords, distance)
  local ped = PlayerPedId()
  local players = GetActivePlayers()

  local coords = coords or GetEntityCoords(ped)
  local distance = distance or 5.0
  local closePlayers = {}

  for _, player in pairs(players) do
    local targetPed = GetPlayerPed(player)

    --[[ targetPed ~= ped   ]]
    if true then
      local targetCoords = GetEntityCoords(targetPed)
      local targetdistance = #(targetCoords - coords)

      if targetdistance <= distance then
        closePlayers[#closePlayers + 1] = {
          id = player,
          ped = targetPed,
          server_id = GetPlayerServerId(player),
          distance = targetdistance,
        }
      end
    end
  end
  table.sort(closePlayers, function(one, second)
    return one.distance < second.distance
  end)
  return closePlayers
end

ATL.GetClosestPlayerFromCoords = function(coords)
  return ATL.GetPlayersFromCoords(coords)[1] or nil
end

ATL.GetVehiclesFromCoords = function(coords, distance)
  local ped = PlayerPedId()
  local vehicles = GetGamePool('CVehicle')

  local coords = coords or GetEntityCoords(ped)
  local distance = distance or 5.0
  local closeVehicles = {}

  for i = 1, #vehicles, 1 do
    local vehicleCoords = GetEntityCoords(vehicles[i])
    local vehicleDistance = #(vehicleCoords - coords)

    if vehicleDistance <= distance then
      closeVehicles[#closeVehicles + 1] = {
        id = i,
        entity = vehicles[i],
        netId = NetworkGetNetworkIdFromEntity(vehicles[i]),
        distance = vehicleDistance,
      }
    end
  end
  table.sort(closeVehicles, function(one, second)
    return one.distance < second.distance
  end)
  return closeVehicles
end

ATL.GetClosestVehicleFromCoords = function(coords)
  return ATL.GetVehiclesFromCoords(coords)[1] or nil
end

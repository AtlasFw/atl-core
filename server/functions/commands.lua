ATL.RegisterCommand('setgroup', 'Set player group', 'guillewashere', function(args)
    local playerId = tonumber(args[1])
    local group = args[2]
    if not playerId or not group then error('Missing an id to set the group (Use setgroup + id + group)') end

    local player = Players[playerId]
    if not player then error('Player not found') end

    local newGroup = player:setGroup(group)
    if not newGroup then error('Group does not exist!') end
end, { }, true)

ATL.RegisterCommand({'car', 'veh'}, 'Spawn a vehicle', 'admin', function(playerId, args)
    local hashModel = GetHashKey(args[1])
    local ped = GetPlayerPed(playerId)
    local currentVehicle = GetVehiclePedIsIn(ped)
    local seats = ATL.GetPassengers(ped, currentVehicle)
    ATL.SpawnVehicle(playerId, hashModel, _, function(_, netVehicle)
        if netVehicle then
            local peds = {}
            for _, id in pairs(GetPlayers()) do
              local pedId = GetPlayerPed(id)
              peds[pedId] = id
            end

            for k, v in pairs(seats) do
                local targetSrc = peds[v]
                TriggerClientEvent('atl:client:setPedSeat', targetSrc, netVehicle, k)
            end
        end
    end)
end, { }, false)

ATL.RegisterCommand({'dv', 'deletevehicle'}, 'Delete a vehicle', 'admin', function(playerId, args)
    local coords = GetEntityCoords(GetPlayerPed(playerId))
    local dist = tonumber(args[1]) or 1.0
    local vehicles = ATL.GetVehicles(coords, dist)
    for i = 1, #vehicles, 1 do
        DeleteEntity(vehicles[i])
    end
end)

ATL.RegisterCommand('clear', 'Clear chat', 'user', function(playerId)
    TriggerClientEvent('chat:clear', playerId)
end, { }, false)

ATL.RegisterCommand('clearall', 'Clear chat for everyone', 'admin', function()
    TriggerClientEvent('chat:clear', -1)
end, { }, false)
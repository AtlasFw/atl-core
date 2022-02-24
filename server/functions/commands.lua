ATL.RegisterCommand('setgroup', 'Set player group', 'admin', function(args)
    local playerId = tonumber(args[1])
    local group = args[2]
    if not playerId or not group then error('Missing an id to set the group (Use setgroup + id + group)') end

    local player = Players[playerId]
    if not player then error('Player not found') end

    local newGroup = player:setGroup(group)
    if not newGroup then error('Group does not exist!') end
end, { }, true)

ATL.RegisterCommand('giveaccount', 'Give account money to player', 'admin', function(_, args)
    local playerId = tonumber(args[1])
    local account = args[2]
    local quantity = tonumber(args[3])

    if not playerId or not account or not quantity then error('Missing an id or account or quantity (Use giveaccount + id + account + quantity)') end

    local player = Players[playerId]
    if not player then error('Player not found') end

    player:addAccountMoney(account, quantity)
end, {}, false)

ATL.RegisterCommand({'car', 'veh'}, 'Spawn a vehicle', 'admin', function(playerId, args)
    local vehicle = args[1]
    if not vehicle then error('Missing a vehicle name (Use car + vehicle name)') end

    local hashModel = GetHashKey(vehicle)
    local ped = GetPlayerPed(playerId)
    if not ped or ped <= 0 then return end

    local coords, heading = GetEntityCoords(ped), GetEntityHeading(ped)
    local seats = ATL.GetPassengers(ped, GetVehiclePedIsIn(ped))
    ATL.CreateVehicle(hashModel, vector4(coords.x, coords.y, coords.z, heading), function(_, netVehicle)
        if netVehicle then
            local peds = {}
            for _, id in pairs(GetPlayers()) do
              peds[GetPlayerPed(id)] = id
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

ATL.RegisterCommand('info', 'My character info', 'admin', function(playerId)
    local player = Players[playerId]

    print('[ATL]: License: ' ..player:getIdentifier().. ' | Name: ' ..GetPlayerName(playerId).. ' | Character ID: ' ..player:getCharacterId().. ' | Character Name: ' ..player:getCharacterName().. ' | Group: ' ..player:getGroup().. ' | Money: ' ..player:getAccount('cash').. '$ | Bank: ' ..player:getAccount('bank').. '$')
end, {}, false)

ATL.RegisterCommand('clear', 'Clear chat', 'user', function(playerId)
    TriggerClientEvent('chat:clear', playerId)
end, { }, false)

ATL.RegisterCommand('clearall', 'Clear chat for everyone', 'admin', function()
    TriggerClientEvent('chat:clear', -1)
end, { }, false)

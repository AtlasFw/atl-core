ATL.RegisterCommand('setgroup', 'Set player group', 'admin', function(player, args)
    local playerId = tonumber(args[1])
    local group = args[2]
    if not playerId or not group then error('Missing an id to set the group (Use setgroup + id + group)') end

    local targetPlayer = Players[playerId]
    local newGroup = targetPlayer:setGroup(group)
    if not newGroup then error('Group does not exist!') end
end, { }, true)

ATL.RegisterCommand('setjob', 'Set player job', 'admin', function(player, args)
    local playerId = tonumber(args[1])
    local jobName = args[2]
    local jobRank = tonumber(args[3])

    if not playerId or not jobName or not jobRank then error('Missing an id or jobName or jobRank (Use setjob + id + jobName + jobRank)') end

    local targetPlayer = Players[playerId]
    targetPlayer:setJob(jobName, jobRank)
end)

ATL.RegisterCommand('giveaccount', 'Give account money to player', 'admin', function(player, args)
    local playerId = tonumber(args[1])
    local account = args[2]
    local quantity = tonumber(args[3])
    if not playerId or not account or not quantity then error('Missing an id or account or quantity (Use giveaccount + id + account + quantity)') end

    Players[playerId]:addAccountMoney(account, quantity)
end, {}, false)

ATL.RegisterCommand('removeaccount', 'Remove account money to player', 'admin', function(player, args)
    local playerId = tonumber(args[1])
    local account = args[2]
    local quantity = tonumber(args[3])
    if not playerId or not account or not quantity then error('Missing an id or account or quantity (Use removeaccount + id + account + quantity)') end

    Players[playerId]:removeAccountMoney(account, quantity)
end, {}, false)

ATL.RegisterCommand({'car', 'veh'}, 'Spawn a vehicle', 'admin', function(player, args)
    local vehicle = args[1]
    if not vehicle then error('Missing a vehicle name (Use car + vehicle name)') end

    local hashModel = GetHashKey(vehicle)
    local ped = GetPlayerPed(player.source)
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

ATL.RegisterCommand({'dv', 'deletevehicle'}, 'Delete a vehicle', 'admin', function(player, args)
    local coords = GetEntityCoords(GetPlayerPed(player.source))
    local dist = tonumber(args[1]) or 1.0
    local vehicles = ATL.GetVehicles(coords, dist)
    for i = 1, #vehicles, 1 do
        DeleteEntity(vehicles[i])
    end
end)

ATL.RegisterCommand('setcoords', 'Set to coords', 'admin', function(player, args)
    local coords = {
        x = tonumber(args[1]),
        y = tonumber(args[2]),
        z = tonumber(args[3])
    }

    if not coords then error('Missing an coords, use (setcoords + x + y + z)') end
    
    SetEntityCoords(GetPlayerPed(player.source), coords.x, coords.y, coords.z)
end)

ATL.RegisterCommand('info', 'My character info', 'user', function(player, args)
    print(("[ATL]: License: %s | Name: %s | Character ID: %s | Character Name: %s | Group: %s | Money: %s$ | Bank: %s$"):format(player:getIdentifier(), GetPlayerName(player.source), player:getCharacterId(), player:getCharacterName(), player:getGroup(), player:getAccount('cash'), player:getAccount('bank')))
end, {}, false)

ATL.RegisterCommand('coords', 'Get coords', 'admin', function(player)
    print(player:getCoords())
end, {}, false)

ATL.RegisterCommand('clear', 'Clear chat', 'user', function(player, args)
    TriggerClientEvent('chat:clear', player.source)
end, { }, false)

ATL.RegisterCommand('clearall', 'Clear chat for everyone', 'admin', function()
    TriggerClientEvent('chat:clear', -1)
end, { }, false)

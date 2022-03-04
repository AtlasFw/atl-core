ATL.RegisterCommand('setgroup', 'Set player group', 'admin', function(player, args)
    local playerId = tonumber(args[1])
    local group = args[2]

    if not playerId or not group then error('Missing an id to set the group (Use setgroup + id + group)') end

    local targetPlayer = Players[playerId]
    local newGroup = targetPlayer:setGroup(group)
    if not newGroup then error('Group does not exist!') end
end,  { 
    { name="playerId", help="Player id" },
    { name="group", help="Group to set" }
}, true)

ATL.RegisterCommand('setjob', 'Set player job', 'admin', function(player, args)
    local playerId = tonumber(args[1])
    local jobName = args[2]
    local jobRank = tonumber(args[3])

    if not playerId or not jobName or not jobRank then error('Missing an id or jobName or jobRank (Use setjob + id + jobName + jobRank)') end
    Players[playerId]:setJob(jobName, jobRank)
end,  { 
    { name="Target id", help="Player id to set job" },
    { name="Job", help="Player job" }
}, false)

ATL.RegisterCommand('setduty', 'Set player duty', 'admin', function(player, args)
    local playerId = tonumber(args[1])
    local bool = args[2]

    if not playerId or not bool then error('Missing an id or bool (Use setduty + id + true or false)') end
    Players[playerId]:setDuty(bool)
end, {
    { name = 'playerId', 'Player id'},
    { name = 'bool', 'Set true or false'}
}, false)

ATL.RegisterCommand('giveaccount', 'Give account money to player', 'admin', function(player, args)
    local playerId = tonumber(args[1])
    local account = args[2]
    local quantity = tonumber(args[3])
    if not playerId or not account or not quantity then error('Missing an id or account or quantity (Use giveaccount + id + account + quantity)') end

    Players[playerId]:addAccountMoney(account, quantity)
end,  { 
    { name="playerId", help="Player id" },
    { name="account", help="Account to add (cash, bank, tebex)" },
    { name="money", help="Quantity to add" }
}, false)

ATL.RegisterCommand('removeaccount', 'Remove account money to player', 'admin', function(player, args)
    local playerId = tonumber(args[1])
    local account = args[2]
    local quantity = tonumber(args[3])
    if not playerId or not account or not quantity then error('Missing an id or account or quantity (Use removeaccount + id + account + quantity)') end

    Players[playerId]:removeAccountMoney(account, quantity)
end,  { 
    { name="playerId", help="Player id" },
    { name="account", help="Account to remove (cash, bank, tebex)" },
    { name="money", help="Quantity to remove" }
}, false)

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
end,  { 
    { name="hash", help="Vehicle name" }
}, false)

ATL.RegisterCommand({'dv', 'deletevehicle'}, 'Delete a vehicle', 'admin', function(player, args)
    local coords = GetEntityCoords(GetPlayerPed(player.source))
    local dist = tonumber(args[1]) or 1.0
    local vehicles = ATL.GetVehicles(coords, dist)
    for i = 1, #vehicles, 1 do
        DeleteEntity(vehicles[i])
    end
end,  { 
    { name="dist", help="Distance to remove (default: 1)" }
}, false)

ATL.RegisterCommand('setcoords', 'Set to coords', 'admin', function(player, args)
    local coords = {
        x = tonumber(args[1]),
        y = tonumber(args[2]),
        z = tonumber(args[3])
    }

    if not coords then error('Missing an coords, use (setcoords + x + y + z)') end
    
    SetEntityCoords(GetPlayerPed(player.source), coords.x, coords.y, coords.z)
end,  { 
    { name="x", help="Coords x" },
    { name="y", help="Coords y" },
    { name="z", help="Coords z" }
}, false)

ATL.RegisterCommand('addslots', 'Add slots to player', 'admin', function(player, args)
    local playerId = tonumber(args[1])
    local slots = tonumber(args[2])

    if not playerId or not slots then error('Missing an id or slots (Use addslots + id + slots)') end

    Players[playerId]:addSlots(slots)
end,  { 
    { name="playerId", help="Player id" },
    { name="slots", help="Slots" }
}, false)

ATL.RegisterCommand('removeslots', 'Remove slots to player', 'admin', function(player, args)
    local playerId = tonumber(args[1])
    local slots = tonumber(args[2])

    if not playerId or not slots then error('Missing an id or slots (Use removeslots + id + slots)') end

    Players[playerId]:removeSlots(slots)
end,  { 
    { name="playerId", help="Player id" },
    { name="slots", help="Slots" }
}, false)

ATL.RegisterCommand("startmulti", "Open the identity/multichar again", 'user', function(player, args)
    if player then
        player:savePlayer()
        Wait(100)
        Players[player.source] = nil
        playerJoined(player.source)
    end
end, {}, false)

ATL.RegisterCommand('info', 'My character info', 'user', function(player, args)
    print(("Name: %s | Character ID: %s | Character Name: %s | Group: %s | Money: %s$ | Bank: %s$ | Job: %s - %s | On Duty: %s"):format(GetPlayerName(player.source), player:getCharacterId(), player:getCharacterName(), player:getGroup(), player:getAccount('cash'), player:getAccount('bank'), player:getJob().joblabel, player:getJob().ranklabel, player:isOnDuty()))
end, {}, false)

ATL.RegisterCommand('coords', 'Get coords', 'admin', function(player)
    local coords, heading = GetEntityCoords(GetPlayerPed(player.source)), GetEntityHeading(GetPlayerPed(player.source))
    print(vec(coords.x, coords.y, coords.z, heading))
end, {}, false)

ATL.RegisterCommand('clear', 'Clear chat', 'user', function(player, args)
    TriggerClientEvent('chat:clear', player.source)
end, { }, false)

ATL.RegisterCommand('clearall', 'Clear chat for everyone', 'admin', function()
    TriggerClientEvent('chat:clear', -1)
end, { }, false)

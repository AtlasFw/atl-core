local CREATE_AUTOMOBILE = GetHashKey('CREATE_AUTOMOBILE')
local encode, decode = json.encode, json.decode

ATL.GetLicense = function (playerId, cb)
    local identifiers = GetPlayerIdentifiers(playerId)
    local matchingIdentifier = 'license:'
    for i=1, #identifiers do
        if identifiers[i]:match(matchingIdentifier) then
            if not cb then
                return identifiers[i]
            end
            return cb(identifiers[i])
        end
    end
    if not cb then
        return false
    end
    return cb(false)
end

---Create a player with a different method depending if the player exists or not
---@param playerId number
---@param license string
---@param exists boolean
ATL.CreatePlayer = function (playerId, license)
    MySQL.Async.execute('INSERT INTO users (license, accounts, appearance, `group`, status, inventory, identity, phone_data, job_data, char_data) VALUES (@license, @accounts, @appearance, @group, @status, @inventory, @identity, @phone_data, @job_data, @char_data)', {
        ['@license']    = license,
        ['@accounts']   = encode(Config.Accounts),
        ['@appearance'] = encode({}),
        ['@group']      = Config.Groups[1] or "user",
        ['@status']     = encode(Config.Status),
        ['@inventory']  = encode({}),
        ['@identity']   = encode({}),
        ['@phone_data'] = encode({}),
        ['@job_data']   = encode({}),
        ['@char_data']  = encode({ coords = Config.Others.Coords }),
    }, function (row)
        if row then
            MySQL.Async.fetchScalar('SELECT LAST_INSERT_ID()', {}, function (charId)
                Players[playerId] = ATL.SetData(playerId, license, charId, {}, Config.Groups[1] or "user", Config.Accounts, {}, Config.Status, {}, { coords = Config.Others.Coords }, {})
                TriggerClientEvent('atl:client:spawnPlayer', playerId, Config.Others.Coords)
            end)
        else
            print('[ATL] Error while creating player')
            DropPlayer(playerId, '[ATL] Error while creating player')
        end
    end)
end

---Set group to player
---@param playerId number
---@param group string
ATL.SetGroup = function (playerId, group)
    if type(player) ~= 'number' then return end
    local player = Players[playerId]

    if not player then return end
    return player:setGroup(group)
end

---Get a player object
---@param id number
---@return table
ATL.GetPlayer = function (id)
    local data = { }
    data.src = id
    data.group = Players[id].group

    data.setGroup = function (group)
        ATL.SetGroup(data.src, group)
    end

    return data
end

---Register a command with the core's permissions
---@param name table - Can be a string or a table of strings with command names
---@param description string - Description of the command
---@param group string - Group that can use the command
---@param cb function - Callback function
---@param suggestions table - Table of suggestions
---@param rcon boolean - Can be used by rcon
ATL.RegisterCommand = function (name, description, group, cb, suggestions, rcon)
    if type(name) == 'table' then
        for i=1, #name do
            ATL.RegisterCommand(name[i], description, group, cb, suggestions, rcon)
        end
        return
    end
    RegisterCommand(name, function (source, args)
        local playerId <const> = source
        if rcon then
            if playerId == 0 then
                cb(args)
            end
        else
            local player = Players[playerId]
            if player.group == group then
                cb(playerId, args, player)
            end
        end
    end)
end


---Spawn a vehicle for a player
---@param playerId number - Player id
---@param model number - Has to be a valid hash or using ``
---@param spawnCoords table - {x, y, z, w}
---@param cb function - Callback function
---@return function
ATL.SpawnVehicle = function(playerId, model, spawnCoords, cb)
    local ped = GetPlayerPed(playerId)
    if ped <= 0 and not spawnCoords then return end

    local coords, heading = type(spawnCoords) == 'table' and spawnCoords or GetEntityCoords(ped), spawnCoords and spawnCoords.w or GetEntityHeading(ped)
    local vehicle = Citizen.InvokeNative(CREATE_AUTOMOBILE, model, coords.x, coords.y, coords.z, heading)

    local timeout = false
    SetTimeout(250, function() timeout = true end)
    repeat
        Wait(0)
        if timeout then return cb(false) end
    until DoesEntityExist(vehicle)

    return cb(vehicle, NetworkGetNetworkIdFromEntity(vehicle))
end

ATL.GetPassengers = function(ped, vehicle)
    local passengers = { }
    if vehicle and vehicle > 0 then
        for i = 6, -1, -1 do
            local seatPed = GetPedInVehicleSeat(vehicle, i)
            if seatPed > 0 then
                passengers[i] = seatPed
            end
        end
    else
        passengers[-1] = ped
    end
    return passengers
end

exports('get', function ()
    return ATL
end)
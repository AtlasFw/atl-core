local CREATE_AUTOMOBILE = GetHashKey('CREATE_AUTOMOBILE')
local encode, decode = json.encode, json.decode

ATL.GetLicense = function(playerId, cb)
    local identifiers = GetPlayerIdentifiers(playerId)
    local found = false
    for i=1, #identifiers do
        if identifiers[i]:match('license:') then
            found = identifiers[i]
        end
    end
    if not cb then return found end
    return cb(found)
end

---Create a player with a different method depending if the player exists or not
---@param playerId number
---@param license string
---@param exists table
ATL.CreatePlayer = function(playerId, license, exists, identity)
    if not exists or not next(exists) then
        MySQL.insert('INSERT INTO users (license, accounts, appearance, `group`, status, inventory, identity, job_data, char_data) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)', {
            license,
            encode(Config.Accounts),
            encode({}),
            Config.Groups[1] or "user",
            encode(Config.Status),
            encode({}),
            next(identity) and encode(identity) or encode({}),
            encode({}),
            encode({ coords = Config.Others.Coords }),
        }, function(charId)
            if charId then
                Players[playerId] = ATL.SetData(playerId, license, charId, {}, Config.Groups[1] or "user", Config.Accounts, {}, Config.Status, {}, { coords = Config.Others.Coords })
                TriggerClientEvent('atl:client:spawnPlayer', playerId, Config.Others.Coords)
            else
                print('[ATL] Error while creating player')
                DropPlayer(playerId, '[ATL] Error while creating player')
            end
        end)
    else
        local player = exists[1]
        Players[playerId] = ATL.SetData(playerId, license, player.character_id, decode(player.job_data), player.group, decode(player.accounts), decode(player.inventory), decode(player.status), decode(player.appearance), decode(player.char_data))
        TriggerClientEvent('atl:client:spawnPlayer', playerId, decode(player.char_data).coords)
    end
end

ATL.CheckIdentity = function(identity, cb)
    if not identity or not next(identity) then return cb(false) end
    if not identity.firstname or not identity.lastname or not identity.dob or not identity.sex then return cb(false) end
    if #identity.firstname > Config.Identity.MaxNameLength or #identity.firstname < Config.Identity.MinNameLength then return cb(false) end
    if #identity.lastname > Config.Identity.MaxNameLength or #identity.lastname < Config.Identity.MinNameLength then return cb(false) end
    local dob = { }
    for k in string.gmatch(identity.dob, "([^".. '/' .."]+)") do
       table.insert(dob, k)
    end
    if #dob ~= 3 then return cb(false) end
    if #dob[1] ~= 2 or #dob[2] ~= 2 or #dob[3] ~= 4 then return cb(false) end
    if tonumber(dob[3]) > Config.Identity.MaxYear or tonumber(dob[3]) < Config.Identity.MinYear then return cb(false) end
    return cb(true)
end

---Register a command with the core's permissions
---@param name table - Can be a string or a table of strings with command names
---@param description string - Description of the command
---@param group string - Group that can use the command
---@param cb function - Callback function
---@param suggestions table - Table of suggestions
---@param rcon boolean - Can be used by rcon
ATL.RegisterCommand = function(name, description, group, cb, suggestions, rcon)
    if type(name) == 'table' then
        for i=1, #name do
            ATL.RegisterCommand(name[i], description, group, cb, suggestions, rcon)
        end
        return
    end
    RegisterCommand(name, function(source, args)
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

ATL.GetEntities = function(coords, entities, distance)
    local ents = {}
    local distance = distance or 1.0
    for _, ent in pairs(entities) do
        if not IsPedAPlayer(ent) then
            local entityCoords = GetEntityCoords(ent)
            if #(coords - entityCoords) <= distance then
                ents[#ents + 1] = ent
            end
        end
    end
    return ents
end

ATL.GetVehicles = function(coords, dist)
    return ATL.GetEntities(coords, GetAllVehicles(), dist or 1.0)
end

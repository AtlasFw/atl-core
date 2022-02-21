local CREATE_AUTOMOBILE = GetHashKey('CREATE_AUTOMOBILE')
local encode, decode = json.encode, json.decode

ATL.CheckIdentity = function(identity)
    if not identity or not next(identity) then return false end
    if not identity.firstname or not identity.lastname or not identity.dob or not identity.sex or not identity.quote then return false end
    return identity
end

ATL.CreatePlayer = function(playerId, license, chars, identity)
    if chars and next(chars) then
        local player = chars[1]
        Players[playerId] = ATL.new(playerId, license, player.char_id, decode(player.job_data), player.group, decode(player.accounts), decode(player.inventory), decode(player.status), decode(player.appearance), decode(player.char_data), decode(player.identity))
        TriggerClientEvent('atl:client:spawnPlayer', playerId, decode(player.char_data).coords)
        return
    end

    local newIdentity = next(identity) and identity or { }
    MySQL.insert('INSERT INTO users (license, accounts, appearance, `group`, status, inventory, identity, job_data, char_data) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)', {
        license,
        encode(Config.Accounts),
        encode({}),
        Config.Groups[1] or 'user',
        encode(Config.Status),
        encode({}),
        encode(newIdentity),
        encode({}),
        encode({ coords = Config.Spawn }),
    }, function(charId)
        if charId then
            Players[playerId] = ATL.new(playerId, license, charId, {}, Config.Groups[1] or "user", Config.Accounts, {}, Config.Status, {}, { coords = Config.Spawn }, newIdentity)
            TriggerClientEvent('atl:client:spawnPlayer', playerId, Config.Spawn)
        else
            print('[ATL] Error while creating player')
            DropPlayer(playerId, '[ATL] Error while creating player')
        end
    end)
end

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

ATL.CreateVehicle = function(model, coords, cb)
    if not coords or type(coords) ~= 'vector4' then return cb(false, false) end
    local vehicle = Citizen.InvokeNative(CREATE_AUTOMOBILE, model, coords.x, coords.y, coords.z, coords.w)
    local timeout = false
    SetTimeout(250, function() timeout = true end)
    repeat
        Wait(0)
        if timeout then return cb(false, false) end
    until DoesEntityExist(vehicle)

    return cb(vehicle, NetworkGetNetworkIdFromEntity(vehicle))
end

ATL.GetLicense = function(playerId)
    if not playerId then return false end

    local identifiers = GetPlayerIdentifiers(playerId)
    local found = false
    for i=1, #identifiers do
        if identifiers[i]:match('license:') then
            found = identifiers[i]
            break
        end
    end
    return found
end

ATL.GetCharacters = function(license)
    if not license then return {} end
    local p = promise.new()
    MySQL.query('SELECT * FROM `users` WHERE `license` = @license', {
        ['@license'] = license
    }, function(characters)
        p:resolve(characters)
    end)
    local result = Citizen.Await(p)
    return result
end

ATL.GetPassengers = function(ped, vehicle)
    local passengers = { }
    if vehicle and vehicle > 0 then
        for i=6, -1, -1 do
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
    local foundEntities = {}
    local distance = distance or 1.0
    for _, entity in pairs(entities) do
        if not IsPedAPlayer(entity) then
            local entityCoords = GetEntityCoords(entity)
            if #(coords - entityCoords) <= distance then
                foundEntities[#foundEntities + 1] = entity
            end
        end
    end
    return foundEntities
end

ATL.GetVehicles = function(coords, dist)
    return ATL.GetEntities(coords, GetAllVehicles(), dist or 1.0)
end
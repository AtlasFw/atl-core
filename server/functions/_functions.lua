local CREATE_AUTOMOBILE = GetHashKey('CREATE_AUTOMOBILE')

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
local encode, decode = json.encode, json.decode

ATL.GetLicense = function (playerId, cb)
    local identifiers = GetPlayerIdentifiers(playerId)
    local matchingIdentifier = "license:"
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
---@param src number
---@param license string
---@param exists boolean
ATL.CreatePlayer = function (src, license, exists)
    if not exists then
        MySQL.Async.execute("INSERT INTO users (license, accounts, appearance, `group`, status, inventory, identity, phone_data, job_data, char_data) VALUES (@license, @accounts, @appearance, @group, @status, @inventory, @identity, @phone_data, @job_data, @char_data)", {
            ['@license']    = license,
            ['@accounts']   = encode(Config.Accounts),
            ['@appearance'] = encode({}),
            ['@group']      = Config.Groups[1] or "user",
            ['@status']     = encode(Config.Status),
            ['@inventory']  = encode({}),
            ['@identity']   = encode({}),
            ['@phone_data'] = encode({}),
            ['@job_data']   = encode({}),
            ['@char_data']  = encode({ coords = Config.Others.coords }),
        }, function (row)
            MySQL.Async.fetchScalar("SELECT LAST_INSERT_ID()", {}, function (charId)
                Players[src] = ATL.SetData(src, license, charId, {}, Config.Groups[1] or "user", Config.Accounts, {}, Config.Status, {})
            end)
        end)
    else
        local data = exists[1]
        Players[src] = ATL.SetData(src, license, data.character_id, decode(data.job_data), data.group, decode(data.accounts), decode(data.inventory), decode(data.status), decode(data.appearance), decode(data.char_data), decode(data.phone_data))
        TriggerClientEvent("atl:client:spawnPlayer", src, decode(data.char_data).coords)
    end
end

---Set group to player
---@param id number
---@param group string
ATL.SetGroup = function (id, group)
    if not Players[tonumber(id)] then return end
    Players[tonumber(id)].group = group
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

---Register a command (WIP)
ATL.RegisterCommand = function (name, description, group, cb, suggestions, rcon)
    RegisterCommand(name, function (source, args, rawCommand)
        local src <const> = source
        if rcon then
            if src == 0 then
                cb(args)
            end
        else
            local player = ATL.GetPlayer(src)
            if player.group == group then
                cb(src, args, player)
            end
        end
    end)
end

ATL.SpawnVehicle = function (model, coords, heading, cb)
    local hash = GetHashKey(model)
    local vehicle = CreateVehicle(hash, coords.x, coords.y, coords.z, heading, true, false)
    return cb(vehicle)
end
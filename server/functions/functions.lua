local encode = json.encode

ATL.GetLicense = function(playerId, cb)
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
        print("Existing")
    end
end
local encode, decode = json.encode, json.decode

--#region Core functions
local function CheckIdentity(identity)
    if not identity or not next(identity) then return false end
    if not identity.firstname or not identity.lastname or type(identity.dob) ~= 'number' or not identity.sex or not identity.quote then return false end
    return identity
end

local function GetCharacters(license)
    if not license then return {} end
    local p = promise.new()
    MySQL.query('SELECT * FROM `users` WHERE `license` = @license', {
        ['@license'] = license
    }, function(characters)
        p:resolve(characters)
    end)
    return Citizen.Await(p)
end

local function CreatePlayer(playerId, license, identity)
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
            SetEntityCoords(GetPlayerPed(playerId), Config.Spawn.x, Config.Spawn.y, Config.Spawn.z)
        else
            print('[ATL] Error while creating player')
            DropPlayer(playerId, '[ATL] Error while creating player')
        end
    end)
end
--#endregion Core functions

--#region Events
local function playerJoined(playerId)
    local playerId <const> = source or playerId
    if Players[playerId] then return DropPlayer(playerId, '[ATL] Player with same identifier is already logged in.') end

    local license = ATL.GetLicense(playerId)

    local characters = GetCharacters(license)
    TriggerClientEvent('atl:client:startMulticharacter', playerId, characters, Config.Identity)
end

local function registerPlayer(identity)
    local playerId <const> = source
    if Players[playerId] then return DropPlayer(playerId, '[ATL] Player with same identifier is already logged in.') end
    if type(identity) ~= 'table' then return DropPlayer(playerId, '[ATL] Invalid identity.') end

    local license = ATL.GetLicense(playerId)

    local newIdentity = CheckIdentity({
        firstname = identity.data.firstname,
        lastname = identity.data.lastname,
        dob = identity.data.dob,
        sex = identity.data.sex,
        quote = identity.data.quote
    })
    if not newIdentity then return DropPlayer(playerId, '[ATL] Invalid identity.') end
    CreatePlayer(playerId, license, newIdentity)
end

local function loadPlayer(data)
    local playerId <const> = source
    if Players[playerId] then return DropPlayer(playerId, '[ATL] Player with same identifier is already logged in.') end
    if type(data) ~= 'table' or type(data.char_id) ~= 'number' then return DropPlayer(playerId, '[ATL] Table was not passed when loading player.') end

    local license = ATL.GetLicense(playerId)
    if license then
        MySQL.single('SELECT * FROM users WHERE license = ? AND char_id = ?', { license, data.char_id }, function(player)
            if player and next(player) then
                local coords = decode(player.char_data).coords
                Players[playerId] = ATL.new(playerId, license, player.char_id, decode(player.job_data), player.group, decode(player.accounts), decode(player.inventory), decode(player.status), decode(player.appearance), decode(player.char_data), decode(player.identity))
                SetEntityCoords(GetPlayerPed(playerId), coords.x, coords.y, coords.z)
            end
        end)
    end
end

local function deletePlayer(data)
    local playerId <const> = source
    if Players[playerId] then return DropPlayer(playerId, '[ATL] Player with same identifier is already logged in.') end
    if type(data) ~= 'table' or type(data.char_id) ~= 'number' then return DropPlayer(playerId, '[ATL] Table was not passed when loading player.') end

    local license = ATL.GetLicense(playerId)
    if license then
        MySQL.prepare('DELETE FROM `users` WHERE `char_id` = ? and `license` = ?', {{
            data.char_id,
            license
        }}, function(result)
            if result == 1 then
                playerJoined(playerId)
            else
                print('[ATL] Could not delete player with char_id of "' .. data.char_id .. '"" and license of "' .. license .. '"')
                DropPlayer(playerId, '[ATL] There was an error when deleting your character. Please contact administration.')
            end
        end)
    end
end

local function leaveServer()
    local playerId <const> = source
    if Players[playerId] then
        Players[playerId]:Save()
        Players[playerId] = nil
    end
    DropPlayer(playerId, '[ATL] You have left the server. Come back soon!')
end

RegisterNetEvent('atl:server:registerNewPlayer', registerPlayer)
RegisterNetEvent('atl:server:loadPlayer', loadPlayer)
RegisterNetEvent('atl:server:playerJoined', playerJoined)
RegisterNetEvent('atl:server:deletePlayer', deletePlayer)
RegisterNetEvent('atl:server:leaveServer', leaveServer)
--#endregion Events
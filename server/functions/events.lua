-- Character id has to be changed to char_id later on.

local decode = json.decode

---Check if a player was previously created
---@param license string
local function DoesPlayerExist(license, cb)
    local p = promise.new()
    MySQL.query('SELECT * FROM `users` WHERE `license` = @license', {
        ['@license'] = license
    }, function(characters)
        p:resolve(characters)
    end)
    local result = Citizen.Await(p)
    return cb(result)
end

local function playerJoined(playerId)
    local playerId <const> = source or playerId
    if Players[playerId] then return DropPlayer(playerId, '[ATL] Player with same identifier is already logged in.') end
    -- Check for license
    ATL.GetLicense(playerId, function(license)
        if license then
            -- Get all characters. If player does exists, start multicharacter depending on config.
            DoesPlayerExist(license, function(characters)
                if Config.Identity.Disable then
                    ATL.CreatePlayer(playerId, license, characters)
                    return
                end
                TriggerClientEvent('atl:client:startMulticharacter', playerId, characters, Config.Identity)
            end)
        else
            DropPlayer(playerId, '[ATL] License not found. Please make sure you are using an official license. If you think this is an error, please contact the server owner.')
        end
    end)
end

local function registerPlayer(identity)
    local playerId <const> = source
    if Players[playerId] then return DropPlayer(playerId, '[ATL] Player with same identifier is already logged in.') end
    if type(identity) ~= 'table' then return DropPlayer(playerId, '[ATL] Invalid identity.') end

    ATL.CheckIdentity(identity, function(resp)
        if resp then
            ATL.GetLicense(playerId, function(license)
                if license then
                    ATL.CreatePlayer(playerId, license, false, identity)
                else
                    DropPlayer(playerId, '[ATL] License not found. Please make sure you are using an official license. If you think this is an error, please contact the server owner.')
                end
            end)
        else
            DropPlayer(playerId, '[ATL] Invalid identity.')
        end
    end)


end

local function loadPlayer(data)
    local playerId <const> = source
    if Players[playerId] then return DropPlayer(playerId, '[ATL] Player with same identifier is already logged in.') end
    if type(data) ~= 'table' or type(data.character_id) ~= 'number' then return DropPlayer(playerId, '[ATL] Table was not passed when loading player.') end

    ATL.GetLicense(playerId, function(license)
        if license then
            MySQL.single('SELECT * FROM users WHERE license = ? AND character_id = ?', { license, data.character_id }, function(player)
                if player and next(player) then
                    Players[playerId] = ATL.SetData(playerId, license, player.character_id, decode(player.job_data), player.group, decode(player.accounts), decode(player.inventory), decode(player.status), decode(player.appearance), decode(player.char_data), decode(player.phone_data))
                    TriggerClientEvent('atl:client:spawnPlayer', playerId, decode(player.char_data).coords)
                end
            end)
        end
    end)
end

local function deletePlayer(data)
    local playerId <const> = source
    if Players[playerId] then return DropPlayer(playerId, '[ATL] Player with same identifier is already logged in.') end
    if type(data) ~= 'table' or type(data.character_id) ~= 'number' then return DropPlayer(playerId, '[ATL] Table was not passed when loading player.') end
    ATL.GetLicense(playerId, function(license)
        if license then
            MySQL.prepare('DELETE FROM `users` WHERE `character_id` = ? and `license` = ?', {{
                data.character_id,
                license
            }}, function(result)
                if result == 1 then
                    playerJoined(playerId)
                else
                    print('[ATL] Could not delete player with character_id of "' .. data.character_id .. '"" and license of "' .. license .. '"')
                    DropPlayer(playerId, '[ATL] There was an error when deleting your character. Please contact administration.')
                end
            end)
        end
    end)
end


RegisterNetEvent('atl:server:registerNewPlayer', registerPlayer)
RegisterNetEvent('atl:server:loadPlayer', loadPlayer)
RegisterNetEvent('atl:server:playerJoined', playerJoined)
RegisterNetEvent('atl:server:deletePlayer', deletePlayer)
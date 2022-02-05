local test = false

local decode = json.decode

---Check if a player was previously created
---@param license string
local function DoesPlayerExist(license, cb)
    local p = promise.new()
    MySQL.query('SELECT * FROM `users` WHERE `license` = @license', {
        ['@license'] = license
    }, function (characters)
        p:resolve(characters)
    end)
    local result = Citizen.Await(p)
    return cb(result)
end

local function createPlayer()
    local playerId <const> = source
    if Players[playerId] then print('[ATL] Player with same identifier is already logged in.') end
    ATL.GetLicense(playerId, function(license)
        if license then
            DoesPlayerExist(license, function(characters)
                if test then
                    ATL.CreatePlayer(playerId, license)
                    return
                end
                Wait(1000)
                TriggerClientEvent('atl:client:startMulticharacter', playerId, characters, Config.Identity.Slots)
                test = true
            end)
        else
            DropPlayer(playerId, '[ATL] License not found. Please make sure you are using an official license. If you think this is an error, please contact the server owner.')
        end
    end)
end

local function registerPlayer()
    local playerId <const> = source
    ATL.GetLicense(playerId, function(license)
        if license then
            ATL.CreatePlayer(playerId, license)
        else
            DropPlayer(playerId, '[ATL] License not found. Please make sure you are using an official license. If you think this is an error, please contact the server owner.')
        end
    end)
end

local function loadPlayer(character_id)
    local playerId <const> = source
    ATL.GetLicense(playerId, function(license)
        if license then
            MySQL.query('SELECT * FROM `users` WHERE `license` = @license AND `character_id` = @character_id', {
                ['@license']        = license,
                ['@character_id']   = tonumber(character_id)
            }, function(player)
                if next(player) then
                    Players[playerId] = ATL.SetData(playerId, license, player[1].character_id, decode(player[1].job_data), player[1].group, decode(player[1].accounts), decode(player[1].inventory), decode(player[1].status), decode(player[1].appearance), decode(player[1].char_data), decode(player[1].phone_data))
                    TriggerClientEvent('atl:client:spawnPlayer', playerId, decode(player[1].char_data).coords)
                end
            end)
        end
    end)
end

local function deletePlayer(character_id)
    local playerId <const> = source
    ATL.GetLicense(playerId, function(license)
        if license then
            MySQL.query('DELETE FROM `users` WHERE `character_id` = @character_id and `license` = @license', {
                ['@license'] 	    = license,
                ['@character_id']   = character_id
            }, function(rowsChanged)
                if rowsChanged ~= 0 then
                    print('Trigger multichar again')
                end
            end)
        end
    end)
end


RegisterNetEvent('atl:server:registerNewPlayer', registerPlayer)
RegisterNetEvent('atl:server:loadPlayer', loadPlayer)
RegisterNetEvent('atl:server:createPlayer', createPlayer)
RegisterNetEvent('atl:server:deletePlayer', deletePlayer)
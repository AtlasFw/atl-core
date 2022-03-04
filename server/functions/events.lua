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
    MySQL.query('SELECT * FROM `characters` WHERE `license` = @license', {
        ['@license'] = license
    }, function(characters)
        p:resolve(characters)
    end)
    return Citizen.Await(p)
end

local function GetUser(playerId, license)
    local p = promise.new()
    MySQL.single('SELECT * FROM users WHERE license = ?', { license }, function(data)
        if data and next(data) then
            p:resolve({
                group = data.group,
                slots = data.slots,
            })
        else
            MySQL.insert('INSERT INTO users (license, `name`, `group`, slots) VALUES (?, ?, ?, ?)', {
                license,
                GetPlayerName(playerId),
                Config.Groups[1] or 'user',
                Config.Identity.AllowedSlots
            }, function(id)
                if id then
                    p:resolve({
                        group = Config.Groups[1] or 'user',
                        slots = Config.Identity.AllowedSlots
                    })
                else
                    p:resolve({})
                    error('Failed to create user')
                end
            end)
        end
    end)
    return Citizen.Await(p)
end

local function CreateCharacter(playerId, license, identity, appearance)
    local user = GetUser(playerId, license)
    local newIdentity = next(identity) and identity or { }
    local newAppearance = { }
    MySQL.insert('INSERT INTO characters (license, accounts, appearance, status, inventory, identity, job_data, char_data) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
        license,
        encode(Config.Accounts),
        encode(appearance),
        encode(Config.Status),
        encode({}),
        encode(newIdentity),
        encode(Config.DefaultJob),
        encode({ coords = Config.Spawn }),
    }, function(charId)
        if charId then
            local player = {
                identity = encode(newIdentity),
                appearance = encode(newAppearance), -- TODO: Add appearance
                job_data = encode(Config.DefaultJob),
                group = user.group,
                slots = user.slots
            }
            Players[playerId] = ATL.new(playerId, license, charId, player)
            SetEntityCoords(GetPlayerPed(playerId), Config.Spawn.x, Config.Spawn.y, Config.Spawn.z)
        else
            print('[ATL] Error while creating player')
            DropPlayer(playerId, '[ATL] Error while creating player')
        end
    end)
end
--#endregion Core functions

--#region Events
function playerJoined(playerId)
    local playerId <const> = source or playerId
    if Players[playerId] then return DropPlayer(playerId, '[ATL] Player with same identifier is already logged in.') end

    local license = ATL.GetLicense(playerId)
    local characters = GetCharacters(license)
    local slots = GetUser(playerId, license).slots
    local cfgIdentity = Config.Identity
    cfgIdentity.AllowedSlots = slots
    TriggerClientEvent('atl:client:startMulticharacter', playerId, characters, cfgIdentity)
end

local function registerCharacter(identity)
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
    CreateCharacter(playerId, license, newIdentity)
end

local function loadCharacter(data)
    local playerId <const> = source
    if Players[playerId] then return DropPlayer(playerId, '[ATL] Player with same identifier is already logged in.') end
    if type(data) ~= 'table' or type(data.char_id) ~= 'number' then return DropPlayer(playerId, '[ATL] Table was not passed when loading player.') end

    local license = ATL.GetLicense(playerId)
    local user = GetUser(playerId, license)
    if license then
        MySQL.single('SELECT * FROM characters WHERE license = ? AND char_id = ?', { license, data.char_id }, function(player)
            if player and next(player) then
                local coords = decode(player.char_data).coords
                player.group = user.group
                player.slots = user.slots
                Players[playerId] = ATL.new(playerId, license, player.char_id, player)
                SetEntityCoords(GetPlayerPed(playerId), coords.x, coords.y, coords.z)
                ATL.RefreshCommands(playerId)
            end
        end)
    end
end

local function deleteCharacter(data)
    local playerId <const> = source
    if Players[playerId] then return DropPlayer(playerId, '[ATL] Player with same identifier is already logged in.') end
    if type(data) ~= 'table' or type(data.char_id) ~= 'number' then return DropPlayer(playerId, '[ATL] Table was not passed when loading player.') end

    local license = ATL.GetLicense(playerId)
    if license then
        MySQL.prepare('DELETE FROM `characters` WHERE `char_id` = ? and `license` = ?', {{
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
        Players[playerId]:savePlayer()
        Players[playerId] = nil
    end
    DropPlayer(playerId, '[ATL] You have left the server. Come back soon!')
end

RegisterNetEvent('atl:server:registerNewCharacter', registerCharacter)
RegisterNetEvent('atl:server:loadCharacter', loadCharacter)
RegisterNetEvent('atl:server:playerJoined', playerJoined)
RegisterNetEvent('atl:server:deleteCharacter', deleteCharacter)
RegisterNetEvent('atl:server:leaveServer', leaveServer)
--#endregion Events
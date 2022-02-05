---Check if a player was previously created
---@param license string
local function DoesPlayerExist(license, cb)
    MySQL.Async.fetchAll('SELECT * FROM `users` WHERE `license` = @license', {
        ['@license'] = license
    }, function (result)
        return cb(result)
    end)
end

local function createPlayer()
    local playerId <const> = source
    ATL.GetLicense(playerId, function(license)
        if license then
            DoesPlayerExist(license, function(result)
                ATL.CreatePlayer(playerId, license, result)
            end)
        else
            DropPlayer(playerId, '[ATL] License not found. Please make sure you are using an official license. If you think this is an error, please contact the server owner.')
        end
    end)
end


RegisterNetEvent('atl:server:createPlayer', createPlayer)
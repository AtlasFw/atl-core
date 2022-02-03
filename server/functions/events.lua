---Check if a player was previously created
---@param license string
local function DoesPlayerExist(license, cb)
    MySQL.Async.fetchScalar("SELECT `license` FROM `users` WHERE `license` = @license", {
        ['@license'] = license
    }, function (result)
        return cb(result)
    end)
end

local function createPlayer()
    local src <const> = source  
    ATL.GetLicense(src, function (license)
        if license then
            DoesPlayerExist(license, function (result)
                ATL.CreatePlayer(src, license, result)
                TriggerClientEvent("atl:client:spawnPlayer", src)
            end)
        else
            DropPlayer(src, "[atl-core] License not found")
        end
    end)
end

RegisterNetEvent("atl:server:createPlayer", createPlayer)
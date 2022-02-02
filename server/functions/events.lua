local function createPlayer()
    local src <const> = source 
    ATL.GetLicense(src, function (license)
        TriggerClientEvent("atl:client:spawnPlayer", src)
    end)
end


RegisterNetEvent("atl:server:createPlayer", createPlayer)
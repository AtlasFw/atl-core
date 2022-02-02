---Function to spawn the player (PENDING A REFACTOR)
---@param coords vector3
local function spawnPlayer(coords)
    local coords = { x = -802.00, y = 175.00, z = 72.95, h = 100.00 }

    local ped = PlayerPedId()
    local ply = PlayerId()

    FreezeEntityPosition(ped, true)
    
    local model = GetHashKey("mp_m_freemode_01")

    RequestModel(model)

    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(0)
    end

    SetPlayerModel(ply, model)
    ped = PlayerPedId()
    SetPedDefaultComponentVariation(ped)
    SetModelAsNoLongerNeeded(model)
    RequestCollisionAtCoord(coords.x, coords.y, coords.z)
    ped = PlayerPedId()
    SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, coords.h, true, true, false)
    ClearPedTasksImmediately(ped)
    RemoveAllPedWeapons(ped) 
    ClearPlayerWantedLevel(ply)
    local time = GetGameTimer()
    while not HasCollisionLoadedAroundEntity(ped) and (GetGameTimer() - time) < 3000 do
        Wait(0)
    end

    ShutdownLoadingScreen()
    if IsScreenFadedOut() then
        DoScreenFadeIn(500)

        while not IsScreenFadedIn() do
            Wait(0)
        end
    end
    SetEntityHealth(ped, 200)
    SetPedMaxHealth(ped, 200)
    FreezeEntityPosition(ped, false)
    SetCanAttackFriendly(ped, true, false)
    NetworkSetFriendlyFireOption(true)
    ClearPlayerWantedLevel(ply)
    SetMaxWantedLevel(0)
end

RegisterNetEvent("atl:client:spawnPlayer", spawnPlayer)
---Set some basic spawn things as pvp or wanted level
local function setSpawnParams()
    local ped = PlayerPedId()
    SetCanAttackFriendly(ped, true, false)
    SetMaxWantedLevel(0)
    SetPedDefaultComponentVariation(ped)
end

---Function to spawn the player (Using spawnmanager default resource)
---@param coords vector3
local function spawnPlayer(coords)
    local coords = vector3(-802.00, 175.00, 72.95)
    exports["spawnmanager"]:spawnPlayer({
        model = "mp_m_freemode_01",
        heading = 100.00,
        x = coords.x,
        y = coords.y,
        z = coords.z
    }, function()
        setSpawnParams()
    end)
end

RegisterNetEvent("atl:client:spawnPlayer", spawnPlayer)
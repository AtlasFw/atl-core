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
    exports["spawnmanager"]:spawnPlayer({
        model = 'mp_m_freemode_01',
        heading = coords.w,
        x = coords.x,
        y = coords.y,
        z = coords.z
    }, function()
        setSpawnParams()
    end)
end

---Sets a ped into a vehicle seat
---@param netVehicle number
---@param seat number
local function setPedSeats(netVehicle, seat)
    if type(netVehicle) ~= 'number' or type(seat) ~= "number" then return end

    local timeout = false
    SetTimeout(250, function() timeout = true end)
    repeat
        Wait(0)
        if timeout then return end
    until NetworkDoesEntityExistWithNetworkId(netVehicle)

    local vehicle = NetToVeh(netVehicle)
    if vehicle and vehicle > 0 then
        SetPedIntoVehicle(PlayerPedId(), vehicle, seat)
        if seat == -1 then
            SetVehicleOnGroundProperly(veh)
        end
    end
end


RegisterNetEvent('atl:client:spawnPlayer', spawnPlayer)
RegisterNetEvent('atl:client:setPedSeat', setPedSeats)
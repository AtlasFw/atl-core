local function spawnPlayer(coords)
    SetEntityVisible(PlayerPedId(), true)
    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z)
end

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
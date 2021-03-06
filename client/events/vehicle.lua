---Event function handling the setting
---of ped seats on specified vehicle.
---@param netVehicle number - NetID of the vehicle
---@param seat number - Seat number
local function setPedSeats(netVehicle, seat)
  if type(netVehicle) ~= 'number' or type(seat) ~= 'number' then
    return
  end

  local timeout = false
  SetTimeout(250, function()
    timeout = true
  end)
  repeat
    Wait(0)
    if timeout then
      return
    end
  until NetworkDoesEntityExistWithNetworkId(netVehicle)

  local vehicle = NetToVeh(netVehicle)
  if vehicle and vehicle > 0 then
    SetPedIntoVehicle(PlayerPedId(), vehicle, seat)
    if seat == -1 then
      SetVehicleOnGroundProperly(vehicle)
    end
  end
end

RegisterNetEvent('atl-core:client:setPedSeat', setPedSeats)

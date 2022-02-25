ATL.GetEntities = function(coords, entities, distance)
  local foundEntities = {}
  local distance = distance or 1.0
  for _, entity in pairs(entities) do
    if not IsPedAPlayer(entity) then
      local entityCoords = GetEntityCoords(entity)
      if #(coords - entityCoords) <= distance then
        foundEntities[#foundEntities + 1] = entity
      end
    end
  end
  return foundEntities
end

ATL.GetVehicles = function(coords, dist)
  return ATL.GetEntities(coords, GetAllVehicles(), dist or 1.0)
end

ATL.CreateVehicle = function(model, coords, cb)
  if type(coords) ~= 'vector4' then return cb(false, false) end

  local vehicle = Citizen.InvokeNative(`CREATE_AUTOMOBILE`, model, coords.x, coords.y, coords.z, coords.w)
  local timeout = false
  SetTimeout(250, function() timeout = true end)

  repeat
    Wait(0)
    if timeout then return cb(false, false) end
  until DoesEntityExist(vehicle)

  return cb(vehicle, NetworkGetNetworkIdFromEntity(vehicle))
end

ATL.CreatePed = function(model, coords, cb)
  if type(model) ~= 'string' or type(coords) ~= 'vector4' then return cb(false, false) end
  
  local ped = CreatePed(0, GetHashKey(model), coords.x, coords.y, coords.z, coords.w, true, true)
  local timeout = false
  SetTimeout(250, function() timeout = true end)

  repeat 
    Wait(0)
    if timeout then return cb(false, false) end
  until DoesEntityExist(ped)

  Wait(100)
  return cb(ped, NetworkGetNetworkIdFromEntity(ped))
end

ATL.CreateObject = function(model, coords, cb)
  if type(model) ~= 'string' or type(coords) ~= 'vector4' then return cb(false, false) end
  
  local object = CreateObject(GetHashKey(model), coords.x, coords.y, coords.z, coords.w, true, true)
  local timeout = false
  SetTimeout(250, function() timeout = true end)

  repeat 
    Wait(0)
    if timeout then return cb(false, false) end
  until DoesEntityExist(object)

  Wait(100)
  return cb(object, NetworkGetNetworkIdFromEntity(object))
end

ATL.DeleteEntity = function(netId, cb)
  if type(netId) ~= 'number' then return end
  local entity = NetworkGetEntityFromNetworkId(netId)
  if entity and entity > 0 then
    DeleteEntity(entity)
    return cb(true)
  end
  return cb(false)
end


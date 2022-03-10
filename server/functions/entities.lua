---Return found entities
---@param coords vector3 - Position to search
---@param entities table - Entities to search
---@param dist number - Max distance to search
---@return table - Found entities
ATL.GetEntities = function(coords, entities, dist)
  if type(coords) ~= 'vector3' or type(entities) ~= 'table' then return false end

  local foundEntities = {}
  local distance = dist or 1.0
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

---Return found vehicle entities
---@param coords vector3 - Position to search
---@param dist number - Max distance to search
---@return boolean - Found vehicle entities
ATL.GetVehicles = function(coords, dist)
  return ATL.GetEntities(coords, GetAllVehicles(), dist or 1.0)
end

---Create vehicle by the server
---@param hash number - Model hash
---@param coords vector4 - Position of the vehicle
---@param cb boolean - Callback function
---@return function - Callback function with vehicle and network id of the vehicle
ATL.CreateVehicle = function(hash, coords, cb)
  if type(hash) ~= 'number' or type(coords) ~= 'vector4' then return cb(false, false) end

  local vehicle = Citizen.InvokeNative(`CREATE_AUTOMOBILE`, hash, coords.x, coords.y, coords.z, coords.w)
  local timeout = false
  SetTimeout(250, function() timeout = true end)

  repeat
    Wait(0)
    if timeout then return cb(false, false) end
  until DoesEntityExist(vehicle)

  return cb(vehicle, NetworkGetNetworkIdFromEntity(vehicle))
end

---Create ped model
---@param model string - Model of the ped
---@param coords vector4 - Position of the ped
---@param cb boolean - Callback function
---@return function - Callback function with ped and network id of the ped
ATL.CreatePed = function(model, coords, cb)
  if type(model) ~= 'string' or type(coords) ~= 'vector4' then return cb(false, false) end

  local ped = CreatePed(0, joaat(model), coords.x, coords.y, coords.z, coords.w, true, true)
  local timeout = false
  SetTimeout(250, function() timeout = true end)

  repeat
    Wait(0)
    if timeout then return cb(false, false) end
  until DoesEntityExist(ped)

  Wait(100)
  return cb(ped, NetworkGetNetworkIdFromEntity(ped))
end

---Create object model
---@param model string - Model of the object
---@param coords vector4 - Position of the object
---@param cb boolean - Callback function
---@return function - Callback function with object and network id of the object
ATL.CreateObject = function(model, coords, cb)
  if type(model) ~= 'string' or type(coords) ~= 'vector4' then return cb(false, false) end

  local object = CreateObject(joaat(model), coords.x, coords.y, coords.z, coords.w, true, true)
  local timeout = false
  SetTimeout(250, function() timeout = true end)

  repeat
    Wait(0)
    if timeout then return cb(false, false) end
  until DoesEntityExist(object)

  Wait(100)
  return cb(object, NetworkGetNetworkIdFromEntity(object))
end

---Delete entity selected
---@param netId number - Network id of the entity
---@param cb boolean - Callback function
---@return boolean - Deleted entity
ATL.DeleteEntity = function(netId, cb)
  if type(netId) ~= 'number' then return end

  local entity = NetworkGetEntityFromNetworkId(netId)
  if entity > 0 then
    DeleteEntity(entity)
    return cb(true)
  end
  return cb(false)
end
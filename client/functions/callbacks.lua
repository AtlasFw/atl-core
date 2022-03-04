--[[ local callbacks = {}

ATL.TriggerServerCallback = function(name, cb, ...)
  local args = (...)
  CreateThread(function()
    TriggerServerEvent("atl:server:callbacks", name, args)
    local tick = 0
    while callbacks[name] == nil and tick < 10 do
      tick = tick + 1
      Wait(100)
    end 
    if callbacks[name] == nil then return cb(nil, "Callback no encontrado") end
    cb(callbacks[name], nil)
    callbacks[name] = nil
  end)
end

RegisterNetEvent("atl:client:recive", function (name, returnValue)
  callbacks[name] = returnValue
end) ]]

--[[ 
  client ---- server ---- client
  server ---- client ---- server
]]
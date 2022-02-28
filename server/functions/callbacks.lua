local callbacks = {}

ATL.RegisterServerCallback = function(name, fn)
  callbacks[name] = fn
end

RegisterServerEvent("atl:server:callbacks", function(name, ...)
  TriggerClientEvent("atl:client:recive", source, name, callbacks[name](...))
  callbacks[name] = nil
end)
local callbacks = {}

ATL.TriggerServerCallback = function(name, cb, ...)
  if type(name) ~= "string" then error("ATL: TriggerServerCallback: name must be a string") end
  if callbacks[name] then
    print("ATL: ServerCallback " .. name .. " already using, wait to resolve it")
    return
  end
  callbacks[name] = cb
  TriggerServerEvent("atl:server:cb_trigger", name, ...)
end

RegisterNetEvent("atl:client:cb_handler", function (name, ...)
  callbacks[name](...)
  callbacks[name] = nil
end)

ATL.RegisterServerCallback = function(name, cb)
  if type(name) ~= 'string' then error('ATL: RegisterServerCallback: name must be a string') end
  ATL.Callbacks[name] = cb
end

RegisterServerEvent('atl:server:cb_trigger', function(name, ...)
  local playerId <const> = source
  local rValue = nil

  if ATL.Callbacks[name] then
    rValue = ATL.Callbacks[name](playerId, ...)
  else
    rValue = nil
    print('ATL: ServerCallback ' .. name .. ' not found')
  end

  TriggerClientEvent('atl:client:cb_handler', playerId, name, rValue)
end)
ATL.RegisterServerCallback = function(name, cb)
  if type(name) ~= 'string' then error('ATL: RegisterServerCallback: name must be a string') end
  ATL.Callbacks[name] = cb
end

RegisterServerEvent('atl:server:cb_trigger', function(name, ...)
  local playerId <const> = source
  local returnValue = nil

  if ATL.Callbacks[name] then
    returnValue = ATL.Callbacks[name](playerId, ...)
  else
    returnValue = nil
    print('ATL: ServerCallback ' .. name .. ' not found')
  end

  TriggerClientEvent('atl:client:cb_handler', playerId, name, returnValue)
end)
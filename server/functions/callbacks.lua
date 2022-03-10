-- This is the current method of handling callbacks.
-- This can be used to register callbacks for client events.
-- If you need help with this, please read the documentation
-- or ask on the discord.
-- https://atlasfw.live/documentation

---Register a callback function on the server.
---@param name string - Name of the callback
---@param cb function - Callback function
ATL.RegisterServerCallback = function(name, cb)
  if type(name) ~= 'string' then error('ATL: RegisterServerCallback: name must be a string') end
  ATL.Callbacks[name] = cb
end

---Event triggering the callback back to the client
---@param name string - Name of the existing callback
---@param ... unknown - Arguments to pass to the callback
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
---Table with all the existing callbacks.
local callbacks = {}

---Function used to trigger a callback that
---was already registered on the server.
---@param name string - Name of the callback
---@param cb function - Callback function
---@param ... any - Arguments to pass to the callback
---@return function - The callback function
ATL.TriggerServerCallback = function(name, cb, ...)
  if type(name) ~= 'string' then error('ATL: TriggerServerCallback: name must be a string') end
  if callbacks[name] then
    print('ATL: ServerCallback ' .. name .. ' already using, wait to resolve it')
    return nil
  end
  callbacks[name] = cb
  TriggerServerEvent('atl:server:cb_trigger', name, ...)
end

---Event handling the callback from the server.
---@param name string - Name of the callback
---@param ... any - Arguments to pass to the callback
RegisterNetEvent('atl:client:cb_handler', function(name, ...)
  callbacks[name](...)
  callbacks[name] = nil
end)

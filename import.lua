-- Due to the way exports work, metatables are not preserved when importing.
-- This means that the only way to get the methods of the player "class" from
-- another resource is to import the file and then use the function provided below.

ATL = exports['atl-core']:get()

ATL.GetPlayer = function(playerId)
  local copyPlayer = ATL.Players[playerId] or exports['atl-core']:GetPlayer(playerId)
  if not copyPlayer then
    return {}
  end
  local metatable = {
    __index = function(self, name)
      if not ATL.Methods[name] then
        error('[ATL] Method ' .. name .. '() does not exist')
      end
      return function(...)
        if type(self[name]) == 'function' then
          print(debug.getinfo(exports['atl-core']['atl_' .. name], 'u').nparams)
          return exports['atl-core']['atl_' .. name](nil, self, ...)
        end
      end
    end,
  }

  setmetatable(copyPlayer, metatable)
  return copyPlayer
end

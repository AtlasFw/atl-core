-- Due to the way exports work, metatables are not preserved when importing.
-- This means that the only way to get the methods of the player "class" from
-- another resource is to import the file and then use the function provided below.

ATL = exports['atl-core']:get()

function Test(player)
  local b = player
  local metatable = {
    __index = function(self, name)
      return function(...)
        print(self, name, ...)
        print(debug.getinfo((exports['atl-core']['atl_' .. name]), 'u').nparams)
        return exports['atl-core']['atl_' .. name](nil, self, ...)
      end
    end
  }
  setmetatable(b, metatable)
  return b
end
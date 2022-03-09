ATL = exports['atl-core']:get()

Test = {}
local metatable = {
  __index = function(self, name)
    -- self prints out the table
    -- name prints out the function name that was called
    print(self, name)
    return
  end
}

setmetatable(Test, metatable)
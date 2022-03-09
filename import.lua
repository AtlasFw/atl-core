ATL = exports['atl-core']:get()

-- Test = {}
-- local metatable = {
--   __index = function(self, name)
--     print(self, name)
--     return
--   end
-- }

-- setmetatable(Test, metatable)

function Test()
  local b = {}
  local metatable = {
    __index = function(self, name)
      print(self, name)
      return
    end
  }
  setmetatable(b, metatable)
  return b
end
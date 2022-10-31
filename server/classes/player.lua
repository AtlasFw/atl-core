local Player = {}

setmetatable(Server.Players, {
  __index = function(self, key)
    print("index", self, key)
    return Player
  end,
  __add = function(self, player)
    print("add", self, player)
    return self
  end,
  __remove = function(self, player)
    print("remove", self, player)
    return self
  end,
})

Player.__index = Player
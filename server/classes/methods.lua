function Player:add(a)
  self.money = self.money + a
end

function Player:logout(dropped)
  if dropped then
    print("Player " .. self.name .. " has been dropped")
  else
    print("Player " .. self.name .. " has been logged out")
  end
end
_ENV.Player = setmetatable({}, {
	__newindex = function(self, key, value)
		print(self, key, value, "function added")
		rawset(self, key, value)
	end,
	__call = function(self, playerId, userId, character)
		self = setmetatable(character, {__index = Player})
		self.playerId = playerId
		self.userId = userId
		return self
	end
})
setmetatable(PlayerList, {__index = Player})

function Player:add(a)
	self.money = self.money + a
end

PlayerList[1] = Player(1, 1, {
	money = 0
})

local player = PlayerList[1]
player:add(1)
print(player.money)
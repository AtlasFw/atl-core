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
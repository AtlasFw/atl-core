---Set group to player
---@param playerId number - Id of the player (source)
---@param group string - Group name (admin, moderator, etc)
---@return boolean - True if the group was set, false otherwise
ATL.SetGroup = function(playerId, group)
  if type(player) ~= 'number' then return end
  local player = ATL.Players[playerId]

  if not player then return end
  return player:setGroup(group)
end

---Get the user group
---@param playerId number - Id of the player (source)
---@return string - Group name (admin, moderator, etc)
ATL.GetGroup = function(playerId)
  if not playerId then return end
  local player = ATL.Players[playerId]

  if not player then return false end
  return player:getGroup()
end

---Get the user slots
---@param playerId number - Id of the player (source)
---@return number - Number of slots
ATL.GetSlots = function(playerId)
  if not playerId then return end
  local player = ATL.Players[playerId]

  if not player then return false end
  return player:getSlots()
end

---Get character name
---@param playerId number - Id of the player (source)
---@return string - Character name
ATL.GetCharacterName = function(playerId)
  local player = ATL.Players[playerId]

  if not player then return false end
  return player:getCharacterName()
end

---Get character id
---@param playerId number - Id of the player (source)
---@return number - Character id
ATL.GetCharacterId = function(playerId)
  local player = ATL.Players[playerId]

  if not player then return false end
  return player:getCharacterId()
end

---Get character accounts
---@param playerId number - Id of the player (source)
---@param account string - Account name (bank, cash, etc)
---@return number - Account balance
ATL.GetAccount = function(playerId, account)
  if not playerId or not account then return false end
  local player = ATL.Players[playerId]

  if not player then return false end
  return player:getAccount(account)
end

---Add money to a player account
---@param playerId number - Id of the player (source)
---@param account string - Account name (bank, cash, etc)
---@param quantity number - Amount of money to add
---@return boolean - True if success
ATL.AddAccountMoney = function(playerId, account, quantity)
  if not playerId or not account or not quantity then return false end

  local player = ATL.Players[playerId]
  if not player then return end

  return player:addAccountMoney(account, quantity)
end

---Remove money to a player account
---@param playerId number - Id of the player (source)
---@param account string
---@param quantity number
---@return boolean - True if success
ATL.RemoveAccountMoney = function(playerId, account, quantity)
  if not playerId or not account or not quantity then return false end

  local player = ATL.Players[playerId]
  if not player then return end

  return player:removeAccountMoney(account, quantity)
end
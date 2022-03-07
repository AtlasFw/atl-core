---Set group to player
---@param playerId number
---@param group string
ATL.SetGroup = function(playerId, group)
  if type(player) ~= 'number' then return end
  local player = Players[playerId]

  if not player then return end
  return player:setGroup(group)
end

---Get the user group 
---@param playerId number
ATL.GetGroup = function(playerId)
  if not playerId then return end
  local player = Players[playerId]

  if not player then return false end
  return player:getGroup()
end

---Get the user slots
---@param playerId number
ATL.GetSlots = function(playerId)
  if not playerId then return end
  local player = Players[playerId]

  if not player then return false end
  return player:getSlots()
end

---Get character name
---@param playerId number
ATL.GetCharacterName = function(playerId)
  local player = Players[playerId]

  if not player then return false end
  return player:getCharacterName()
end

---Get character id
---@param playerId number
ATL.GetCharacterId = function(playerId)
  local player = Players[playerId]

  if not player then return false end
  return player:getCharacterId()
end

---Get character accounts
---@param playerId number
---@param account string
ATL.GetAccount = function(playerId, account)
  if not playerId or not account then return false end
  local player = Players[playerId]

  if not player then return false end
  return player:getAccount(account)
end

---Add money to a player account
---@param playerId number
---@param account string
---@param quantity number
---@return boolean
ATL.AddAccountMoney = function(playerId, account, quantity)
  if not playerId or not account or not quantity then return false end

  local player = Players[playerId]
  if not player then return end

  return player:addAccountMoney(account, quantity)
end

---Remove money to a player account
---@param playerId number
---@param account string
---@param quantity number
---@return boolean
ATL.RemoveAccountMoney = function(playerId, account, quantity)
  if not playerId or not account or not quantity then return false end

  local player = Players[playerId]
  if not player then return end

  return player:removeAccountMoney(account, quantity)
end
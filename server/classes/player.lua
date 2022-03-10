local encode = json.encode
local decode = json.decode

local player = {}
setmetatable(ATL.Players, player)

--Sets the player's index to player's table
player.__index = player

---Create/Load a new player
---@param playerId number - Id of the player (source)
---@param identifier string - Identifier of the player
---@param char_id number - Id of the character (auto-increment)
---@param data table - Data of the player
---@return table - Player
ATL.new = function(playerId, identifier, char_id, data)
  local self = {}
  self.source = playerId
  self.identifier = identifier
  self.char_id = char_id

  -- Player data
  self.accounts = decode(data.accounts) or Server.Accounts
  self.appearance = decode(data.appearance) or {}
  self.char_data = decode(data.char_data) or { coords = Server.Spawn }
  self.group = data.group or Server.Groups[1] or 'user'
  self.identity = decode(data.identity) or {}
  self.inventory = decode(data.inventory) or {}
  self.job_data = decode(data.job_data) or {}
  self.slots = data.slots or Server.Identity.AllowedSlots
  self.status = decode(data.status) or Server.Status

  -- Update the player data
  ATL.Players[playerId] = self

  -- Load the player
  TriggerClientEvent('atl:client:characterLoaded', playerId, self)
  SetEntityCoords(GetPlayerPed(playerId), self.char_data.coords.x, self.char_data.coords.y, self.char_data.coords.z)

  setmetatable(self, getmetatable(ATL.Players))
  ATL.RefreshCommands(playerId)
end

---Save the player data to the database
function player:savePlayer()
  local ped = GetPlayerPed(self.source)
  local coords, heading = GetEntityCoords(ped), GetEntityHeading(ped)
  self:setCoords(vector4(coords.x, coords.y, coords.z, heading))

  local queries = {
    { query = 'UPDATE `users` SET `group` = ?, `slots` = ? WHERE `license` = ?', values = { self.group, self.slots, self.identifier }},
    { query = 'UPDATE `characters` SET accounts = ?, status = ?, inventory = ?, job_data = ?, char_data = ? WHERE `char_id` = ? ', values = { encode(self.accounts), encode(self.status), encode(self.inventory), encode(self.job_data), encode(self.char_data), self.char_id }}
  }

  MySQL.Async.transaction(queries, function(result)
    if result then
      print('[ATL] User and Character ' .. self.source .. ' saved successfully')
    end
  end)
end

--#region Getters
-- Player data
---Return the character id
---@return number - Character id
function player:getCharId()
  return self.char_id
end

---Return the amount of identity slots the player has
---@return number - Amount of allowed identity slots
function player:getSlots()
  return self.slots
end

-- Character data
---Return the character name
---@return table - Character name (func().firstname, func().lastname)
function player:getCharName()
  return {
    firstname = self.identity.firstname,
    lastname = self.identity.lastname
  }
end

-- Group
---Return the group the player is in
---@return string - Group name
function player:getGroup()
  return self.group
end

---Return if the group the player is has enough permissions
---@param group string - Group name to check
---@return boolean - Has enough permissions
function player:hasPerms(group)
  if type(group) ~= 'string' then return false end
  if not Server.Groups[group] then return false end
  return Server.Groups[self.group] >= Server.Groups[group]
end

-- Jobs
---Return the job the player is in
---@return string - Job label
function player:getJobLabel()
  return Server.Jobs[self.job_data.name].name
end

---Return the rank the player is in (job)
---@return string - Job rank label
function player:getRankLabel()
  local job = self.job_data
  return Server.Jobs[job.name].ranks[job.rank].label
end

---Return if the player in on duty (job)
---@return boolean - Is on duty
function player:getDuty()
  return self.job_data.onDuty
end

-- Account
---Return the money the player has in specified account
---@param account string - Account name
---@return number - Money value
function player:getAccount(account)
  if type(account) ~= 'string' then return false end

  if Server.Accounts[account] then
    return self.accounts[account]
  end
end
--#endregion Getters

--#region Setters
-- Player data
---Set the player's coords
---@param coords vector4 - Coords to set
---@param now boolean - Teleport to coords now
---@return boolean - Teleport/Setting success
function player:setCoords(coords, now)
  if type(coords) ~= 'vector4' then return false end
  if now then
    SetEntityCoords(GetPlayerPed(self.source), coords.x, coords.y, coords.z)
  end

  self.char_data.coords = vec4(coords.x, coords.y, coords.z, coords.w)
  return true
end

---Set the slots of an user
---@param slots number - Amount of allowed identity slots
---@return boolean - Setting success
function player:setSlots(slots)
  if type(slots) ~= 'number' then return false end

  self.slots = slots
  return true
end

-- Group
---Set the group of an user to a specific group
---@param group string - Group name
---@return boolean - Setting success
function player:setGroup(group)
  if type(group) ~= 'string' then return false end
  if not Server.Groups[group] then return false end

  self.group = group
  ATL.RefreshCommands(self.source)
  return true
end

-- Jobs
---Set the job of an user to a specific job
---@param name string - Job name (lowercase)
---@param level number - Job rank number
---@return boolean - Setting success
function player:setJob(name, level)
  if type(name) ~= 'string' or type(level) ~= 'number' then return false end

  local job = Server.Jobs[name]
  local rank = job?.ranks[level]
  if not job or not rank then return false end

  -- Restarts the duty to false
  self.job_data = { name = job.name, rank = rank, onDuty = false}

  return true
end

---Set the duty state of a player
---@param state boolean - Duty state (true/false)
---@return boolean - Setting success
function player:setDuty(state)
  if type(state) ~= 'boolean' then return false end

  self.job_data.onDuty = state
  return true
end

-- Accounts
---Add money to an specified account
---@param account string - Account name
---@param quantity number - Amount to add
---@return boolean - Adding success
function player:addAccountMoney(account, quantity)
  if type(account) ~= 'string' or type(account) ~= 'number' then return false end
  if not self.accounts[account] then return false end

  self.accounts[account] = self.accounts[account] + quantity
  return true
end

---Remove money from an specified account
---@param account string - Account name
---@param quantity number - Amount to remove
---@return boolean - Removing success
function player:removeAccountMoney(account, quantity)
  if type(account) ~= 'string' or type(account) ~= 'number' then return false end
  if not self.accounts[account] then return false end

  self.accounts[account] = self.accounts[account] - quantity
  return true
end
--#endregion Setters

for name, func in pairs(player) do
  if type(func) == 'function' then
    print(debug.getinfo(func, 'u').nparams, name) -- Can be removed later
    exports('atl_' .. name, func)
    ATL.Methods[name] = name
  end
end

print('[ATL] Loaded exportable' .. #ATL.Methods .. ' methods')
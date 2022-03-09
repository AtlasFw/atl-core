-- If you plan working on the core, please use the following functions..

local encode = json.encode
local decode = json.decode

local player = {}
setmetatable(ATL.Players, player)

--Sets the player's index to player's table
player.__index = player

ATL.new = function(source, identifier, char_id, data)
  local self = {}
  self.source = source
  self.identifier = identifier
  self.char_id = char_id

  -- Player data
  self.accounts = decode(data.accounts) or Config.Accounts
  self.appearance = decode(data.appearance) or {}
  self.char_data = decode(data.char_data) or { coords = Config.Spawn }
  self.group = data.group or Config.Groups[1] or 'user'
  self.identity = decode(data.identity) or {}
  self.inventory = decode(data.inventory) or {}
  self.job_data = decode(data.job_data) or {}
  self.slots = data.slots or Config.Identity.AllowedSlots
  self.status = decode(data.status) or Config.Status

  ATL.Players[source] = self

  TriggerClientEvent('atl:client:characterLoaded', source, self)
  return setmetatable(self, getmetatable(ATL.Players))
end

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
function player:getCharId()
  return self.char_id
end

function player:getSlots()
  return self.slots
end

-- Character data
function player:getCharName()
  return {
    firstname = self.identity.firstname,
    lastname = self.identity.lastname
  }
end

-- Group
function player:getGroup()
  return self.group
end

function player:hasPerms(group)
  if type(group) ~= 'string' then return false end
  if not Config.Groups[group] then return false end
  return Config.Groups[self.group] >= Config.Groups[group]
end

-- Jobs
function player:getJobLabel()
  return Jobs[self.job_data.name].name
end

function player:getRankLabel()
  local job = self.job_data
  return Jobs[job.name].ranks[job.rank].label
end

function player:getDuty()
  return self.job_data.onDuty
end

-- Account
function player:getAccount(account)
  if type(account) ~= 'string' then return false end

  if Config.Accounts[account] then
    return self.accounts[account]
  end
end
--#endregion Getters

--#region Setters
-- Player data
function player:setCoords(coords, now)
  if type(coords) ~= 'vector4' then return false end
  if now then
    SetEntityCoords(GetPlayerPed(self.source), coords.x, coords.y, coords.z)
  end

  self.char_data.coords = vec4(coords.x, coords.y, coords.z, coords.w)
  return true
end

function player:setSlots(slots)
  if type(slots) ~= 'number' then return false end

  self.slots = self.slots + slots
  return true
end

-- Group
function player:setGroup(group)
  if type(group) ~= 'string' then return false end
  if not Config.Groups[group] then return false end

  self.group = group
  ATL.RefreshCommands(self.source)
  return true
end

-- Jobs
function player:setJob(name, level)
  if type(name) ~= 'string' or type(level) ~= 'number' then return false end

  local job = Jobs[name]
  local rank = job?.ranks[level]
  if not job or not rank then return false end

  -- Restarts the duty to false
  self.job_data = { name = job.name, rank = rank, onDuty = false}

  return true
end

function player:setDuty(bool)
  if type(bool) ~= 'boolean' then return false end

  self.job_data.onDuty = bool
  return true
end

-- Accounts
function player:addAccountMoney(account, quantity)
  if type(account) ~= 'string' or type(account) ~= 'number' then return false end
  if not self.accounts[account] then return false end

  self.accounts[account] = self.accounts[account] + quantity
  return true
end

function player:removeAccountMoney(account, quantity)
  if type(account) ~= 'string' or type(account) ~= 'number' then return false end
  if not self.accounts[account] then return false end

  self.accounts[account] = self.accounts[account] - quantity
  return true
end
--#endregion Setters
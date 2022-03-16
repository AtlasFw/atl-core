local encode = json.encode

---Returns if identity has all the required fields
---@param identity table - Identity
---@return boolean - Returns has proper fields
local function checkIdentity(identity)
  if not identity or not next(identity) then return false end
  if not identity.firstname or not identity.lastname or type(identity.dob) ~= 'number' or not identity.sex or not identity.quote then return false end
  return identity
end

---Creates a new character
---@param playerId number - Id of the player (source)
---@param license string - License of the player
---@param identity table - Identity of the player
---@param appearance table - Appearance of the player
local function createCharacter(playerId, license, identity, appearance)
  local user = getUser(playerId, license)
  local newIdentity = next(identity) and identity or {}
  local newAppearance = next(appearance) and appearance or {}
  local newJob = { name = 'unemployed', rank = 1, onDuty = false } -- Default job
  MySQL.insert('INSERT INTO characters (license, accounts, appearance, char_data, identity, inventory, job_data, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
    license,
    encode(Server.Accounts),
    encode(newAppearance),
    encode({ coords = Server.Spawn }),
    encode(newIdentity),
    encode({}),
    encode(newJob),
    encode(Server.Status),
  }, function(charId)
    if charId then
      local player = {
        appearance = encode(newAppearance), -- TODO: Add appearance
        identity = encode(newIdentity),
        job_data = encode(newJob),
        group = user.group,
        slots = user.slots
      }
      ATL.Players[playerId] = ATL.new(playerId, license, charId, player)
      ATL.RefreshCommands(playerId)
    else
      print('[ATL] Error while creating player')
      DropPlayer(playerId, '[ATL] Error while creating player')
    end
  end)
end

---Creates a new user for a player.
---Do not confuse this with a character.
---@param playerId number - Id of the player (source)
---@param license string - License of the player
---@return table - User
function createUser(playerId, license)
  local p = promise.new()
  MySQL.insert('INSERT INTO users (`license`, `name`, `group`, `slots`) VALUES (?, ?, ?, ?)', {
    license,
    GetPlayerName(playerId),
    Server.Groups[1] or 'user',
    Server.Identity.AllowedSlots
  }, function(id)
    if id then
      p:resolve({
        group = Server.Groups[1] or 'user',
        slots = Server.Identity.AllowedSlots
      })
    else
      p:resolve({})
      error('Failed to create user with id: ' .. playerId)
    end
  end)
  return Citizen.Await(p)
end

---Returns the user for the player.
---@param playerId number - Id of the player (source)
---@param license string - License of the player
---@return table - User (slots and group)
function getUser(playerId, license)
  local p = promise.new()
  MySQL.single('SELECT `slots`, `group` FROM users WHERE license = ?', { license }, function(data)
    if data and next(data) then
      p:resolve(data)
    else
      local user = createUser(playerId, license)
      p:resolve(user)
    end
  end)
  return Citizen.Await(p)
end

---Register a new character for the player.
---This is just the handler for the event.
---Drops player if it fails.
---Do not confuse this with createCharacter().
---@param identity table - Identity of the player
function registerCharacter(identity, appearance)
  local playerId <const> = source
  if type(identity) ~= 'table' then return DropPlayer(playerId, '[ATL] Invalid identity.') end

  local license = ATL.GetLicense(playerId)
  local newIdentity = checkIdentity({
    firstname = identity.data.firstname,
    lastname = identity.data.lastname,
    dob = identity.data.dob,
    sex = identity.data.sex,
    quote = identity.data.quote
  })
  if not newIdentity then return DropPlayer(playerId, '[ATL] Invalid identity.') end

  createCharacter(playerId, license, newIdentity, appearance)
end

---Loads the character into the game.
---Drops player if it fails.
---@param character table - Character (holds the char_id)
function loadCharacter(character)
  local playerId <const> = source
  if type(character.char_id) ~= 'number' then return DropPlayer(playerId, '[ATL] Table was not passed when loading player.') end

  local license = ATL.GetLicense(playerId)
  local user = getUser(playerId, license)
  if license then
    MySQL.single('SELECT * FROM characters WHERE license = ? AND char_id = ?', { license, character.char_id }, function(player)
      if player and next(player) then
        player.group = user.group
        player.slots = user.slots
        ATL.Players[playerId] = ATL.new(playerId, license, player.char_id, player)
        ATL.RefreshCommands(playerId)
      end
    end)
  end
end

-- Might update a deleted characters table later on.
---Deletes the character from the database.
---Drops player if it fails.
---@param character table - Character (holds the char_id)
function deleteCharacter(character)
  local playerId <const> = source
  if type(character.char_id) ~= 'number' then return DropPlayer(playerId, '[ATL] Table was not passed when loading player.') end

  local license = ATL.GetLicense(playerId)
  MySQL.prepare('DELETE FROM `characters` WHERE `char_id` = ? and `license` = ?', {character.char_id, license}, function(result)
    if result == 1 then
      playerJoined(playerId)
    else
      print('[ATL] Could not delete player with char_id of "' .. character.char_id .. '"" and license of "' .. license .. '"')
      DropPlayer(playerId, '[ATL] There was an error when deleting your character. Please contact administration.')
    end
  end)
end

RegisterNetEvent('atl-core:server:registerCharacter', registerCharacter)
RegisterNetEvent('atl-core:server:loadCharacter', loadCharacter)
RegisterNetEvent('atl-core:server:deleteCharacter', deleteCharacter)
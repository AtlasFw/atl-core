local encode, decode = json.encode, json.decode

local function checkIdentity(identity)
  if not identity or not next(identity) then return false end
  if not identity.firstname or not identity.lastname or type(identity.dob) ~= 'number' or not identity.sex or not identity.quote then return false end
  return identity
end

function createUser(playerId, license)
  local p = promise.new()
  MySQL.insert('INSERT INTO users (`license`, `name`, `group`, `slots`) VALUES (?, ?, ?, ?)', {
    license,
    GetPlayerName(playerId),
    Config.Groups[1] or 'user',
    Config.Identity.AllowedSlots
  }, function(id)
    if id then
      p:resolve({
        group = Config.Groups[1] or 'user',
        slots = Config.Identity.AllowedSlots
      })
    else
      p:resolve({})
      error('Failed to create user')
    end
  end)
  return Citizen.Await(p)
end

local function createCharacter(playerId, license, identity, appearance)
  local user = getUser(playerId, license)
  local newIdentity = next(identity) and identity or {}
  local newAppearance = next(appearance) and appearance or {}
  local newJob = { name = 'unemployed', rank = 1, onDuty = false }
  MySQL.insert('INSERT INTO characters (license, accounts, appearance, status, inventory, identity, job_data, char_data) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
    license,
    encode(Config.Accounts),
    encode(newAppearance),
    encode(Config.Status),
    encode({}),
    encode(newIdentity),
    encode(newJob),
    encode({ coords = Config.Spawn }),
  }, function(charId)
    if charId then
      local player = {
        identity = encode(newIdentity),
        appearance = encode(newAppearance), -- TODO: Add appearance
        job_data = encode(newJob),
        group = user.group,
        slots = user.slots
      }
      ATL.Players[playerId] = ATL.new(playerId, license, charId, player)
      ATL.RefreshCommands(playerId)
      SetEntityCoords(GetPlayerPed(playerId), Config.Spawn.x, Config.Spawn.y, Config.Spawn.z)
    else
      print('[ATL] Error while creating player')
      DropPlayer(playerId, '[ATL] Error while creating player')
    end
  end)
end

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

function registerCharacter(identity)
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

  createCharacter(playerId, license, newIdentity, {})
end

function loadCharacter(character)
  local playerId <const> = source
  if type(character.char_id) ~= 'number' then return DropPlayer(playerId, '[ATL] Table was not passed when loading player.') end

  local license = ATL.GetLicense(playerId)
  local user = getUser(playerId, license)
  if license then
    MySQL.single('SELECT * FROM characters WHERE license = ? AND char_id = ?', { license, character.char_id }, function(player)
      if player and next(player) then
        local coords = decode(player.char_data).coords
        player.group = user.group
        player.slots = user.slots
        ATL.Players[playerId] = ATL.new(playerId, license, player.char_id, player)
        ATL.RefreshCommands(playerId)
        SetEntityCoords(GetPlayerPed(playerId), coords.x, coords.y, coords.z)
      end
    end)
  end
end

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

RegisterNetEvent('atl:server:registerCharacter', registerCharacter)
RegisterNetEvent('atl:server:loadCharacter', loadCharacter)
RegisterNetEvent('atl:server:deleteCharacter', deleteCharacter)

---Returns all the existing characters for the player
---@param license string - License of the player
---@return table - Characters
local function getCharacters(license)
  local p = promise.new()
  MySQL.query('SELECT * FROM `characters` WHERE `license` = ?', {license}, function(characters)
    p:resolve(characters)
  end)
  return Citizen.Await(p)
end

---Event function handling the joining of a player.
---Drops the player if it fails (already exists).
---@param playerId number - Id of the player (source)
function playerJoined(playerId)
  local playerId <const> = source or playerId
  if ATL.Players[playerId] then return DropPlayer(playerId, '[ATL] Player with same identifier is already logged in.') end

  local license = ATL.GetLicense(playerId)
  local characters = getCharacters(license)
  local slots = getUser(playerId, license).slots
  local cfgIdentity = Server.Identity
  cfgIdentity.AllowedSlots = slots
  TriggerClientEvent('atl:client:startMulticharacter', playerId, characters, cfgIdentity, Server.Jobs)
end

---Event function handling the leaving of a player.
function playerLeave()
  local playerId <const> = source
  local player = ATL.Players[playerId]
  if player then
    player:savePlayer()
    ATl.Players[playerId] = nil
  end
  DropPlayer(playerId, '[ATL] You have left the server. Come back soon!')
end

RegisterNetEvent('atl:server:playerJoined', playerJoined)
RegisterNetEvent('atl:server:playerLeave', playerLeave)
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
  local newPlayerId <const> = source or playerId
  if ATL.Players[newPlayerId] then return DropPlayer(newPlayerId, '[ATL] Player with same identifier is already logged in.') end

  local license = ATL.GetLicense(newPlayerId)
  local characters = getCharacters(license)
  local slots = getUser(newPlayerId, license).slots
  local cfgIdentity = Server.Identity
  cfgIdentity.AllowedSlots = slots
  TriggerClientEvent('atl-identity:client:startMulticharacter', newPlayerId, characters, cfgIdentity, Server.Jobs)
end

---Event function handling the leaving of a player.
function playerExit()
  local playerId <const> = source
  local player = ATL.Players[playerId]
  if player then
    player:savePlayer()
    ATl.Players[playerId] = nil
  end
  DropPlayer(playerId, '[ATL] You have left the server. Come back soon!')
end

RegisterNetEvent('atl-core:server:playerJoined', playerJoined)
RegisterNetEvent('atl-core:server:playerExit', playerExit)
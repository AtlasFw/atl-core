---Register a command with custom parameters.
---@param name unknown - Name or table of names
---@param description string - Description of the command
---@param group string - Player group required to use the command
---@param cb function - Callback function
---@param suggestions table
---@param rcon boolean
ATL.RegisterCommand = function(name, description, group, cb, suggestions, rcon)
  if type(description) ~= 'string' or type(group) ~= 'string' or type(cb) ~= 'function' then error('ATL.RegisterCommand: description, group, and cb must be strings and cb must be a function') end
  if not Config.Groups[group] then error('ATL.RegisterCommand: group must be a valid group') end

  if type(name) == 'table' then
    for i=1, #name do
      ATL.RegisterCommand(name[i], description, group, cb, suggestions, rcon)
    end
    return
  end

  ATL.Commands[name] = {
    description = description,
    group = group,
    suggestions = suggestions,
}

  RegisterCommand(name, function(source, args)
    local playerId <const> = source
    if rcon then
      if playerId == 0 then
        cb(nil, args)
      end
    else
      local player = ATL.Players[playerId]
      if player and player:hasPerms(group) then
        cb(player, args)
      end
    end
  end)
end

---Refreshes the commands for the user with the specified group.
---@param playerId number - Id of the player (source)
---@return boolean - True if successful, false if not
ATL.RefreshCommands = function(playerId)
  local player = ATL.Players[playerId]
  if not player then return false end

  local suggestions = {}
  for name, command in pairs(ATL.Commands) do
    local commandName = '/' .. name
    if player:hasPerms(command.group) then
      suggestions[#suggestions + 1] = {
        name = commandName,
        help = command.description,
        params = command.suggestions
      }
    else
      TriggerClientEvent('chat:removeSuggestion', player.source, commandName)
    end
  end
  TriggerClientEvent('chat:addSuggestions', player.source, suggestions)
  return true
end

---Returns the license of the user
---@param playerId number - Id of the player (source)
---@return unknown - String of the license or false if not found
ATL.GetLicense = function(playerId)
  if not playerId then return false end

  local identifiers = GetPlayerIdentifiers(playerId)
  local found = false
  for i=1, #identifiers do
    if identifiers[i]:match('license:') then
    found = identifiers[i]
    break
    end
  end
  return found
end

---Returns the peds the seats of a vehicle
---@param ped number - Ped entity
---@param vehicle number - Vehicle entity
---@return table - Table of seat peds
ATL.GetPassengers = function(ped, vehicle)
  local passengers = {}
  if vehicle and vehicle > 0 then
    for i=6, -1, -1 do
      local seatPed = GetPedInVehicleSeat(vehicle, i)
      if seatPed > 0 then
        passengers[i] = seatPed
      end
    end
  else
    passengers[-1] = ped
  end
  return passengers
end
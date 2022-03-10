local function format(value, style)
  ---{0, 0, 0, 0}
  if style == 'string' then
    return tostring(v)
  elseif style == 'number' then
    return tonumber(v)
  elseif style == 'boolean' then
    return string.lower(style) == 'true'
  elseif style == 'vector3' then
    local x, y, z = json.decode(value)
    return vec4(x, y, z)
  else
    return value
  end
end

---Register a command with custom parameters.
---@param name unknown - Name or table of names
---@param description string - Description of the command
---@param group string - Player group required to use the command
---@param cb function - Callback function
---@param suggestions table
ATL.RegisterCommand = function(name, description, group, cb, types, suggestions)
  if type(name) == 'table' then
    for i = 1, #name do
      ATL.RegisterCommand(name[i], description, group, cb, types, suggestions)
    end
    return
  end

  if ATL.Commands[name] then
    error('Command ' .. name .. ' already exists.')
  end

  RegisterCommand(name, function(source, args, rawCommand)
    if #args < #types then
      print 'Not enough arguments.'
      return
    end
    local player = ATL.Players[source]
    if not player or not player:hasPerms(group) then
      return
    end

    local arguments = {}
    for i = 1, #args do
      local name, style = string.strsplit(types[i], '-')
      print(name, style)
      local value = format(args[i], style)
      print(value, type(value))
      arguments[name] = value
    end

    if type(cb) == 'function' then
      cb(source, arguments, rawCommand)
    end
  end)

  -- Register new command on ATL.Commands
  ATL.Commands[name] = {
    description = description,
    group = group,
    suggestions = suggestions,
  }
end

---Refreshes the commands for the user with the specified group.
---@param playerId number - Id of the player (source)
---@return boolean - True if successful, false if not
ATL.RefreshCommands = function(playerId)
  local player = ATL.Players[playerId]
  if not player then
    return false
  end

  local suggestions = {}
  for name, command in pairs(ATL.Commands) do
    local commandName = '/' .. name
    if player:hasPerms(command.group) then
      suggestions[#suggestions + 1] = {
        name = commandName,
        help = command.description,
        params = command.suggestions,
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
  if not playerId then
    return false
  end

  local identifiers = GetPlayerIdentifiers(playerId)
  local found = false
  for i = 1, #identifiers do
    if identifiers[i]:match 'license:' then
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
    for i = 6, -1, -1 do
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

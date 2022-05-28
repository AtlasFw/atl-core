local function format(value, style)
	if style == "string" then
		return tostring(value)
	elseif style == "number" then
		return tonumber(value)
	elseif style == "boolean" then
		return value:lower() == "true"
	else
		return value
	end
end

ATL.RegisterCommand = function(name, description, group, cb, types, suggestions)
	if type(name) == "table" then
		for i = 1, #name do
			ATL.RegisterCommand(name[i], description, group, cb, types, suggestions)
		end
		return
	end

	if ATL.Commands[name] then
		error("Command " .. name .. " already exists.")
	end

	local invoke = GetInvokingResource()
	RegisterCommand(name, function(source, args)
		types = types or {}
		if #args < #types then
			TriggerClientEvent("atl-ui:client:simpleNotify", source, {
				type = "error",
				message = "Not enough arguments.",
			})
			return
		end

		local player = ATL.Players[source]
		local arguments = {}
		for i = 1, #args do
			local style, argName = string.strsplit("-", types[i])
			local value = format(args[i], style)
			if args[i] ~= "me" then
				if value == nil then
					print('Argument "' .. args[i] .. '" cannot be formatted into "' .. style .. '"')
					return
				end
				if argName == "target" then
					player = ATL.Players[value]
					if not player then
						print("Player " .. value .. " not found.")
						return
					end
				end
			end
			arguments[argName] = value
		end

		if not player or not player:hasPerms(group) then
			print("No perms")
			return
		end
		if invoke == nil then
			cb(player, arguments)
		else
			cb(source, arguments)
		end
	end)

	-- Register new command on ATL.Commands
	ATL.Commands[name] = {
		description = description,
		group = group,
		suggestions = suggestions or {},
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
		local commandName = "/" .. name
		if player:hasPerms(command.group) then
			suggestions[#suggestions + 1] = {
				name = commandName,
				help = command.description,
				params = command.suggestions,
			}
		else
			TriggerClientEvent("chat:removeSuggestion", player.source, commandName)
		end
	end
	TriggerClientEvent("chat:addSuggestions", player.source, suggestions)
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
		if identifiers[i]:match("license:") then
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

ATL.RegisterCommand("c", "c creator", "admin", function(player, args)
	ATL.newVehicle(player.source, player.identifier, player.char_id, "sultanrs")
end, {}, {})

ATL.RegisterCommand("setgroup", "Set player group", "admin", function(player, args)
	player:setGroup(args.group)
end, { "number-target", "string-group" }, {
	{ name = "playerId", help = "Player id" },
	{ name = "group", help = "Group to set" },
})

ATL.RegisterCommand("setjob", "Set player job", "admin", function(player, args)
	player:setJob(args.name, args.rank)
end, { "number-target", "string-name", "number-rank" }, {
	{ name = "Target id", help = "Player id to set job" },
	{ name = "Job", help = "Player job" },
	{ name = "Rank", help = "Rank id" },
})

ATL.RegisterCommand("setduty", "Set player duty", "admin", function(player, args)
	player:setDuty(args.state)
end, { "number-target", "boolean-state" }, {
	{ name = "playerId", "Player id" },
	{ name = "bool", "Set true or false" },
})

ATL.RegisterCommand("giveaccount", "Give account money to player", "admin", function(player, args)
	player:addAccountMoney(args.account, args.amount)
end, { "number-target", "string-account", "number-amount" }, {
	{ name = "playerId", help = "Player id" },
	{ name = "account", help = "Account to add (cash, bank, tebex)" },
	{ name = "money", help = "Quantity to add" },
})

ATL.RegisterCommand("removeaccount", "Remove account money to player", "admin", function(player, args)
	player:removeAccountMoney(args.account, args.amount)
end, { "number-target", "string-account", "number-amount" }, {
	{ name = "playerId", help = "Player id" },
	{ name = "account", help = "Account to remove (cash, bank, tebex)" },
	{ name = "money", help = "Quantity to remove" },
})

ATL.RegisterCommand({ "car", "veh" }, "Spawn a vehicle", "admin", function(player, args)
	local ped = GetPlayerPed(player.source)
	if not ped or ped <= 0 then
		return
	end

	local curVehicle = GetVehiclePedIsIn(ped)
	local coords, heading = GetEntityCoords(ped), GetEntityHeading(ped)
	local seats = ATL.GetPassengers(ped, curVehicle)

	ATL.DeleteEntity(NetworkGetNetworkIdFromEntity(curVehicle), function()
		ATL.CreateVehicle(args.model, vector4(coords.x, coords.y, coords.z, heading), function(_, netVehicle)
			if netVehicle then
				local peds = {}
				for _, id in pairs(GetPlayers()) do
					peds[GetPlayerPed(id)] = id
				end

				for k, v in pairs(seats) do
					local targetSrc = peds[v]
					TriggerClientEvent("atl-core:client:setPedSeat", targetSrc, netVehicle, k)
				end
			end
		end)
	end)
end, { "string-model" }, {
	{ name = "model", help = "Vehicle name" },
})

ATL.RegisterCommand({ "dv", "deletevehicle" }, "Delete a vehicle", "admin", function(player, args)
	local coords = GetEntityCoords(GetPlayerPed(player.source))
	local vehicles = ATL.GetVehicles(coords, args.distance)
	for i = 1, #vehicles, 1 do
		DeleteEntity(vehicles[i])
	end
end, { "number-distance" }, {
	{ name = "dist", help = "Distance to remove (default: 1.0)" },
})

ATL.RegisterCommand("setcoords", "Teleport to specified coords", "admin", function(player, args)
	player:setCoords(vector4(args.x, args.y, args.z, GetEntityHeading(GetPlayerPed(player.source))), true)
end, { "number-x", "number-y", "number-z" }, {
	{ name = "x", help = "Coords x" },
	{ name = "y", help = "Coords y" },
	{ name = "z", help = "Coords z" },
})

ATL.RegisterCommand("setslots", "Set the slots of player", "admin", function(target, args)
	target:setSlots(args.slots)
end, { "number-target", "number-slots" }, {
	{ name = "playerId", help = "Player id" },
	{ name = "slots", help = "Slots" },
})

ATL.RegisterCommand("startmulti", "Open the identity/multichar again", "user", function(player)
	player:savePlayer()
	ATL.Players[player.source] = nil
	Wait(100)

	TriggerClientEvent("atl-core:client:onCharacterLoaded", player.source, nil)
	playerJoined(player.source)
end)

ATL.RegisterCommand('info', 'My character info', 'user', function(player)
  print(player:getAccount('cash'), player:getAccount('bank'), player.group)
  print(
    ('Name: %s | Character ID: %s | Character Name: %s | Group: %s | Money: %s$ | Bank: $%s | Job: %s | On Duty: %s'):format(
      GetPlayerName(player.source),
      player.char_id,
      player:getCharName().firstname .. ' ' .. player:getCharName().lastname,
      player.group,
      player:getAccount('cash'),
      player:getAccount('bank'),
      player:getJob().label .. ' ' .. player:getJob().rank.label,
      player:getJob().onDuty
    )
  )
end)

ATL.RegisterCommand("clear", "Clear chat", "user", function(player)
	TriggerClientEvent("chat:clear", player.source)
end)

ATL.RegisterCommand("clearall", "Clear chat for everyone", "admin", function()
	TriggerClientEvent("chat:clear", -1)
end)

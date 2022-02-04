ATL.RegisterCommand("setgroup", "Set player group", "guillewashere", function (args)
    local id = tonumber(args[1])
    local group = args[2]
    if not id or not group then error("Missing an id to set the group (Use setgroup + id + group)") end
    local player = ATL.GetPlayer(id)
    player.setGroup(group)
end, { }, true)

ATL.RegisterCommand("car", "Spawn a vehicle", "admin", function (source, args, rawCommand, playerData)
    local veh = args[1]
    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    ATL.SpawnVehicle(veh, coords, heading, function (veh)
        TaskWarpPedIntoVehicle(ped, veh, -1)
    end)
end, { }, false)
ATL = {
    Commands = {},
    Resources = {},
}

CreateThread(function()
    while true do
        for _, player in pairs(Players) do
            player:savePlayer()
        end
        Wait(Config.SaveTime)
    end
end)

AddEventHandler('playerConnecting', function(_, _, deferrals)
    deferrals.defer()
    local playerId <const> = source
    deferrals.update("[ATL] Checking player...")

    local license = ATL.GetLicense(playerId)
    Wait(500)
    if not license then
        deferrals.done('[ATL] No license found.')
        return CancelEvent()
    end
    deferrals.done()
end)

AddEventHandler('playerDropped', function()
	local playerId <const> = source
	if Players[playerId] then
        Players[playerId]:savePlayer(playerId)
		Players[playerId] = nil
        print('[ATL] Player ' .. playerId .. ' disconnected.')
	end
end)
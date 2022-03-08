ATL = {
  Callbacks = {},
  Commands = {},
  Players = {},
  Resources = {},
}

CreateThread(function()
  while true do
    for _, player in pairs(ATL.Players) do
      player:savePlayer()
    end
    Wait(Config.SaveTime)
  end
end)

AddEventHandler('playerConnecting', function(_, _, deferrals)
  deferrals.defer()
  local playerId <const> = source
  deferrals.update('[ATL] Checking player...')

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
  local player = ATL.Players[playerId]
	if player then
    player:savePlayer()
    ATL.Players[playerId] = nil
    print('[ATL] Player ' .. playerId .. ' disconnected.')
	end
end)
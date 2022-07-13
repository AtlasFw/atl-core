---Object containing the main server logic
ATL = {
  Callbacks = {},
  Commands = {},
  Players = {},
  Methods = {},
  Resources = {},
}

---Save player every specified time
CreateThread(function()
  while true do
    for _, player in pairs(ATL.Players) do
      player:savePlayer()
    end
    Wait(Server.SaveTime)
  end
end)

---Handler for the auto restart event.
---@param data table - Data of the event
AddEventHandler('txAdmin:events:scheduledRestart', function(data)
	if data.secondsRemaining == 60 then
    CreateThread(function()
			Wait(45000)
      for _, player in pairs(ATL.Players) do
        player:savePlayer()
      end
    end)
	end
end)

---Handler for the joining event.
---Should check for license and
---kick the player if it's not valid.
---@param _ any
---@param _ any
---@param deferrals function - Deferrals
---@return any
AddEventHandler('playerConnecting', function(_, _, deferrals)
  deferrals.defer()
  local playerId <const> = source
  deferrals.update('[ATL] Checking player...')

  local license = ATL.GetLicense(playerId)
  Wait(500)
  if not license then
    deferrals.done('[ATL] No license found.')
    CancelEvent()
    return
  end
  deferrals.done()
end)

---Handler for the leaving event.
---Should save the player and remove
---the player from the ATL.Players table.
AddEventHandler('playerDropped', function()
	local playerId <const> = source
  local player = ATL.Players[playerId]
	if player then
    player:savePlayer()
    ATL.Players[playerId] = nil
    print('[ATL] Player ' .. playerId .. ' disconnected.')
	end
end)

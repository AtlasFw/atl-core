ATL, PlayerList = {}, {}
_G.PlayerList, _G.ATL = PlayerList, ATL

local tempId

AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
  deferrals.defer()
  deferrals.update("[Atlas] Checking player...")
  local playerId <const> = source
  local identifier = GetIdentifier(playerId, 'license')
  if not identifier then
    deferrals.done("[Atlas] No identifier found")
    CancelEvent()
    return
  end

  deferrals.done()
end)

AddEventHandler('playerDropped', function(reason)
  local playerId <const> = source
  local player = PlayerList[playerId]
  if player then
    player:logout(true)
  end
end)
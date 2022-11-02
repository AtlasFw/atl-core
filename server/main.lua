ATL, PlayerList = {}, {}
_G.PlayerList, _G.ATL = PlayerList, ATL

AddEventHandler('playerJoining', function(name, setKickReason, deferrals)
  deferrals.defer()
  deferrals.update("Loading...")
  deferrals.done()
end)

AddEventHandler('playerDropped', function(reason)
  print("playerDropped", reason)
end)
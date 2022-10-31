PlayerList = {}
_G.PlayerList = PlayerList

AddEventHandler('playerJoining', function(name, setKickReason, deferrals)
  deferrals.defer()
  deferrals.update("Loading...")
  deferrals.done()
end)

AddEventHandler('playerDropped', function(reason)
  print("playerDropped", reason)
end)
---Table holding all the client-side functions + variables.
---ATL.Character is all the data from the server.
---This has be to kept in sync with the server by using
---events (at the moment).
ATL = {
  Character = {},
}

CreateThread(function()
  while true do
    if NetworkIsPlayerActive(PlayerId()) then
      TriggerServerEvent('atl:server:playerJoined')
      break
    end
    Wait(0)
  end
end)

---Event handling the first setting of the character in the client.
---@param character table - The character table.
RegisterNetEvent('atl:client:characterLoaded', function(character)
  ATL.Character = character
end)
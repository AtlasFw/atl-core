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

RegisterNetEvent('atl:client:characterLoaded', function(character)
  ATL.Character = character
end)
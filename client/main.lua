CreateThread(function()
    while true do
        if NetworkIsPlayerActive(PlayerId()) then
            TriggerServerEvent('atl:server:playerJoined')
            break
        end
        Wait(0)
    end
end)
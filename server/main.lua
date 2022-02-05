ATL = { }
ATL.Commands = { }

CreateThread(function()
    while true do
        for _, player in pairs(Players) do
            player:setCoords()
            player:savePlayer()
        end
        Wait(Config.SaveTime)
    end
end)
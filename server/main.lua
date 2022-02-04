ATL = { }
ATL.Commands = { }

CreateThread(function ()
    while true do
        for k, v in pairs(Players) do
            v:updateCoords()
            v:savePlayer()
        end
        Wait(Config.SaveTime)
    end
end)
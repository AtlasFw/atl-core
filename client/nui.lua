RegisterNUICallback('select_character', function(data, cb)
    TriggerServerEvent('atl:server:loadPlayer', data)
    cb({})
end)

RegisterNUICallback('create_character', function(data, cb)
    TriggerServerEvent('atl:server:createPlayer')
    cb({})
end)

RegisterNUICallback('delete_character', function(data, cb)
    TriggerServerEvent('atl:server:deletePlayer', data)
    cb({})
end)
---Set group to player
---@param playerId number
---@param group string
ATL.SetGroup = function(playerId, group)
    if type(player) ~= 'number' then return end
    local player = Players[playerId]

    if not player then return end
    return player:setGroup(group)
end

---Add money to a player account
---@param playerId number
---@param account string
---@param quantity number
---@return boolean
ATL.AddAccountMoney = function(playerId, account, quantity)
    if type(player) ~= 'number' then return false end
    local player = Players[playerId]

    if not player then return end
    return player:addAccountMoney(account, quantity)
end

exports('get', function()
    return ATL
end)
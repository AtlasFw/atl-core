-- PLEASE READ BELOW BEFORE USING THIS METHOD (DEPRECATED)
-- We are planning on deprecating this method in the future as more members use Atlas framework. Please use the other functions instead.
-- Please read the documentation on https://atlasfw.live/documentation, we will not provide support for this method.

---Get a player object
---@param playerId number
---@return table
ATL.GetPlayer = function(playerId)
    local player = Players[playerId]
    if not player then return error(("The player with id '%s' does not exist"):format(playerId)) end
    local self = { }

    self.setGroup = function(group)
        return player:SetGroup(group)
    end

    self.addAccountMoney = function(account, quantity)
        return player:addAccountMoney(account, quantity)
    end

    self.removeAccountMoney = function(account, quantity)

    end

    return self
end
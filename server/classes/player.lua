Players = {}
local player = {}
setmetatable(Players, player)

--Sets the player's index to player's table
player.__index = player

---Creates player metadata
---@param source number
player.setData = function(source, identifier, chardid, jobs, group, accounts, inventory, status, appearance)
    local self = {}
    self.source = source
    self.identifier = identifier
    self.charid =  chardid
    self.jobs = jobs
    self.group = group
    self.accounts = accounts
    self.inventory = inventory
    self.status = status
    self.appearance = appearance

    Players[self.source] = self
    return setmetatable(self, getmetatable(Players))
end

---Returns the source
---@return number
function player:getSource()
    return self.source
end

---Returns the identifier from argument
---@param identifier string
---@return string
function player:getIdentifier(identifier)
    local identifiers = self.identifiers
    local matchingIdentifier = not not identifier and identifier or "license:"
    for i=1, #identifiers do
        if identifiers[i]:match(matchingIdentifier) then
            return identifiers[i]
        end
    end
    return "No matching identifier: " .. tostring(matchingIdentifier)
end



Players[1] = Players.setData(1, 20)
print(json.encode(Players[1]:getSource()))

function ATL.getJob(id)
    return Players[1]
end



exports('get', function()
    return ATL
end)

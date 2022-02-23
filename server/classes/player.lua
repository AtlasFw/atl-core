local encode = json.encode
local decode = json.decode

Players = {}
local player = {}
setmetatable(Players, player)

--Sets the player's index to player's table
player.__index = player

ATL.new = function(source, identifier, char_id, player)
    print(player.group)
    local self = {}
    self.source = source
    self.identifier = identifier
    self.char_id = char_id
    self.jobs = decode(player.job_data) or {}
    self.group = player.group or Config.Groups[1] or 'user'
    self.accounts = decode(player.accounts) or Config.Accounts
    self.inventory = decode(player.inventory) or {}
    self.status = decode(player.status) or Config.Status
    self.appearance = decode(player.appearance) or {}
    self.char_data = decode(player.char_data) or { coords = Config.Spawn }
    self.identity = decode(player.identity) or {}

    Players[self.source] = self
    return setmetatable(self, getmetatable(Players))
end

--#region Getters

function player:getSource()
    return self.source or false
end

function player:getIdentifier()
    return self.identifier or false
end

function player:getGroup()
    return self.group
end

function player:getCharacterName()
    return self.identity.firstname, self.identity.lastname
end

function player:getCharacterId()
    return self.char_id
end

function player:getAccount(account)
    if Config.Accounts[account] then
        return self.accounts[account]
    end
end

--#endregion Getters

function player:setGroup(group)
    if not group then return false end
    for i=1, #Config.Groups do
        if Config.Groups[i] == group then
            self.group = group
            return true
        end
    end
    return false
end

function player:setCoords(coords)
    if not coords or type(coords) ~= 'vector4' then return false end
    self.char_data.coords = vector4(coords.x, coords.y, coords.z, coords.w)
    return true
end

function player:addAccountMoney(account, quantity)
    if not account or not quantity then return false end
    if not self.accounts[account] then return false end

    self.accounts[account] = self.accounts[account] + quantity
    return true
end

function player:savePlayer()
    local coords = GetEntityCoords(GetPlayerPed(self.source))
    self:setCoords(vector4(coords.x, coords.y, coords.z, GetEntityHeading(ped)))

    -- Update data in database
    MySQL.prepare('UPDATE `characters` SET accounts = ?, status = ?, inventory = ?, job_data = ?, char_data = ? WHERE `char_id` = ? ', {{
        encode(self.accounts),
        encode(self.status),
        encode(self.inventory),
        encode(self.jobs),
        encode(self.char_data),
        self.char_id
    }}, function(result)
        if result == 1 then
            print('[ATL] Player ' .. self.source .. ' saved successfully')
        end
    end)
end
--#endregion Setters

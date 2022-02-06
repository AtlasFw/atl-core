local encode = json.encode

Players = {}
local player = {}
setmetatable(Players, player)

--Sets the player's index to player's table
player.__index = player

---Sets the player's data
---@param source number
---@param identifier string
---@param char_id number
---@param jobs table
---@param group string
---@param accounts table
---@param inventory table
---@param status table
---@param appearance table
---@param char_data table
---@param phone_data table
---@return table
ATL.SetData = function(source, identifier, char_id, jobs, group, accounts, inventory, status, appearance, char_data, phone_data)
    local self = {}
    self.source = source
    self.identifier = identifier
    self.char_id =  char_id
    self.jobs = jobs
    self.group = group
    self.accounts = accounts
    self.inventory = inventory
    self.status = status
    self.appearance = appearance
    self.char_data = char_data
    self.phone_data = phone_data

    Players[self.source] = self
    return setmetatable(self, getmetatable(Players))
end

--#region Getters

---Returns the source
---@return number
function player:getSource()
    return self.source
end

---Returns the identifier from argument
---@return string
function player:getIdentifier()
    return self.identifier or false
end

--#endregion Getters

--#region Setters
---Set the player group
---@param group string
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

---Set new coords for the player table
---@param newCoords vector3
---@param newHeading number
---@return boolean
function player:setCoords(newCoords, newHeading)
    local ped = GetPlayerPed(self.source)
    if ped <= 0 then return false end
    local coords, heading = type(newCoords) == 'table' and newCoords or GetEntityCoords(ped), newHeading or GetEntityHeading(ped)
    if coords.x == 0 or coords.y == 0 or coords.z == 0 then return false end
    self.char_data.coords = vector4(coords.x, coords.y, coords.z, heading)
    return true
end

---Add money to an account
---@param account string
---@param quantity number
function player:addAccountMoney(account, quantity)
    self.accounts[account] = self.accounts + quantity
end

---Save player into the database
function player:savePlayer()
    self:setCoords()
    MySQL.prepare('UPDATE `users` SET accounts = ?, `group` = ?, status = ?, inventory = ?, phone_data = ?, job_data = ?, char_data = ? WHERE `character_id` = ? ', {{
        encode(self.accounts),
        self.group,
        encode(self.status),
        encode(self.inventory),
        encode(self.phone_data),
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
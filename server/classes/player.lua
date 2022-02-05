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
    local coords, heading = newCoords or GetEntityCoords(ped), newHeading or GetEntityHeading(ped)
    self.char_data.coords = vector4(coords.x, coords.y, coords.z, heading + 0.0)
    return true
end

function player:savePlayer()
    MySQL.Async.execute("UPDATE `users` SET license = @license, accounts = @accounts, appearance = @appearance, `group` = @group, status = @status, inventory = @inventory, identity = @identity, phone_data = @phone_data, job_data = @job_data, char_data = @char_data", {
        ['@license']    = self.identifier,
        ['@accounts']   = encode(self.accounts),
        ['@appearance'] = encode(self.appearance),
        ['@group']      = self.group,
        ['@status']     = encode(self.status),
        ['@inventory']  = encode(self.inventory),
        ['@identity']   = encode({}),
        ['@phone_data'] = encode(self.phone_data),
        ['@job_data']   = encode(self.jobs),
        ['@char_data']  = encode(self.char_data),
    }, function ()
        -- Add saved player log
    end)
end
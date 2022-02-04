Players = {}
local player = {}
setmetatable(Players, player)
local encode = json.encode

--Sets the player's index to player's table
player.__index = player

---Creates player metadata
---@param source number
---@param identifier string
---@param chardid number
---@param jobs table
---@param group string
---@param accounts table
---@param inventory table
---@param status table
---@param appearance table
---@param char any
---@param phonedata any
---@return table
ATL.SetData = function (source, identifier, chardid, jobs, group, accounts, inventory, status, appearance, char, phonedata)
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
    self.chardata = char
    self.phone_data = phonedata

    Players[self.source] = self
    return setmetatable(self, getmetatable(Players))
end

---Returns the source
---@return number
function player:getSource ()
    return self.source
end

function player:savePlayer ()
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
        ['@char_data']  = encode(self.chardata),
    }, function ()
        -- Add saved player log
    end)
end

---Update the player coords on save
function player:updateCoords ()
    local ped = GetPlayerPed(self.source)
    self.chardata.coords = GetEntityCoords(ped)
end

---Returns the identifier from argument
---@param identifier string
---@return string
function player:getIdentifier (identifier)
    local identifiers = self.identifiers
    local matchingIdentifier = not not identifier and identifier or "license:"
    for i=1, #identifiers do
        if identifiers[i]:match(matchingIdentifier) then
            return identifiers[i]
        end
    end
    return "No matching identifier: " .. tostring(matchingIdentifier)
end

---Set the player group
---@param group any
function player:setGroup (group)
    if not group then return end
    self.group = group
end

exports('get', function ()
    return ATL
end)
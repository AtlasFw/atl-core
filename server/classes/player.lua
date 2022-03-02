local encode = json.encode
local decode = json.decode

Players = {}
local player = {}
setmetatable(Players, player)

--Sets the player's index to player's table
player.__index = player

ATL.new = function(source, identifier, char_id, player)
    local self = {}
    self.source = source
    self.identifier = identifier
    self.char_id = char_id
    self.jobs = decode(player.job_data) or {}
    self.group = player.group or Config.Groups[1] or 'user'
    self.slots = player.slots or Config.Identity.AllowedSlots
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
    return self.source or 0
end

function player:getIdentifier()
    return self.identifier or false
end

function player:getCharData()
    return self.char_data or false
end

function player:getGroup()
    return self.group
end

function player:getJob()
    return self.jobs
end

function player:getSlots()
    return self.slots
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

function player:getCoords()
    return self.char_data.coords
end

function player:isOnDuty()
    return self.jobs.onDuty
end

--#endregion Getters

function player:setGroup(group)
    if not group then return false end
    if not Config.Groups[group] then return false end
    self.group = group
    ATL.RefreshCommands(self.source)
    return true
end

function player:isAuthorized(group)
    if not group then return false end
    if not Config.Groups[group] then return false end
    return Config.Groups[self.group] >= Config.Groups[group]
end

function player:setJob(jobname, jobrank)
    if not jobname or not jobrank then return false end
    if not Jobs[jobname] or not Jobs[jobname].ranks[jobrank] then return false end
    local job = Jobs[jobname]

    self.jobs.jobname, self.jobs.joblabel, self.jobs.rank, self.jobs.rankname, self.jobs.ranklabel, self.jobs.paycheck, self.jobs.taxes, self.jobs.onDuty = jobname, job.label, jobrank, job.ranks[jobrank].name, job.ranks[jobrank].label, job.ranks[jobrank].paycheck, job.ranks[jobrank].taxes, job.onDuty
    return true
end

function player:setDuty(bool)
    if not bool then return false end
    
    self.jobs.onDuty = bool
    return true
end

function player:setCoords(coords)
    if not coords or type(coords) ~= 'vector4' then return false end
    self.char_data.coords = vector4(coords.x, coords.y, coords.z, coords.w)
    return true
end

function player:addSlots(slots)
    if not slots then return false end
    self.slots = self.slots + slots
    return true
end

function player:removeSlots(slots)
    if not slots then return false end
    self.slots = self.slots - slots
    return true
end

function player:addAccountMoney(account, quantity)
    if not account or not quantity then return false end
    if not self.accounts[account] then return false end

    self.accounts[account] = self.accounts[account] + quantity
    return true
end

function player:removeAccountMoney(account, quantity)
    if not account or not quantity then return false end
    if not self.accounts[account] then return false end

    self.accounts[account] = self.accounts[account] - quantity
    return true
end

function player:savePlayer()
    local ped = GetPlayerPed(self.source)
    local coords, heading = GetEntityCoords(ped), GetEntityHeading(ped)
    self:setCoords(vector4(coords.x, coords.y, coords.z, heading))

    local queries = {
        { query = 'UPDATE `users` SET `group` = ?, `slots` = ? WHERE `license` = ?', values = { self.group, self.slots, self.identifier }},
        { query = 'UPDATE `characters` SET accounts = ?, status = ?, inventory = ?, job_data = ?, char_data = ? WHERE `char_id` = ? ', values = { encode(self.accounts), encode(self.status), encode(self.inventory), encode(self.jobs), encode(self.char_data), self.char_id }}
    } 
    
    MySQL.Async.transaction(queries, function(result) 
        if result then
            print('[ATL] User and Character ' .. self.source .. ' saved successfully')
        end
    end)
end

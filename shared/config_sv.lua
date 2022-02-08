Config = {}

Config.Accounts = { cash = 0, bank = 0, black = 0, tebex = 0  }

Config.Status = { hunger = 100, thirst = 100 }

Config.Groups = {
    [1] = 'user',
    [2] = 'admin',
}

-- Needs refactoring to be more dynamic so that admins can give people more slots.
Config.Identity = {
    Disable = false, -- Set to true to disable the identity/multicharacter system.
    MaxSlots = 3, -- Max amount of slots (official multichar only supports 3)
    AllowedSlots = 3, -- Max amount of slots that can be taken by a player.
    MinYear = 1900, -- Minimum year of birth.
    MaxYear = 2020, -- Maximum year of birth.
    MinNameLength = 3, -- Minimum name length.
    MaxNameLength = 20, -- Maximum name length.
}

Config.Others = {
    Coords = vector4(-802.00, 175.00, 72.00, 180.00) -- Default spawn coords
}

Config.SaveTime = --[[10 * 1000 * 60]] 10000

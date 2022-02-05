Config = {}

Config.Accounts = { cash = 0, bank = 0, black = 0, tebex = 0  }

Config.Status = { hunger = 100, thirst = 100 }

Config.Groups = {
    [1] = "user",
    [2] = "admin",
}

-- Needs refactoring to be more dynamic so that admins can give people more slots.
Config.Identity = {
    Disable = false,
    Slots = {
        [1] = true,
        [2] = true,
        [3] = false
    }
}

Config.Others = {
    coords = vector4(-802.00, 175.00, 72.95, 180.00)
}

Config.SaveTime = --[[10 * 1000 * 60]] 2000

Server = {
  Spawn = vec4(-75.5010, -818.9702, 326.1753, 221.4246), -- Spawn position for new players
  SaveTime = 10000, -- Time in ms to save the player data

  -- Starting status for new players (can add more)
  Status = {
    ['hunger'] = {
      value = 100, -- Starting value
      rate = 1, -- Rate of change
    },
    ['thirst'] = {
      value = 100,
      rate = 1,
    },
  },

  -- Starting accounts for new players with default values
  Accounts = {
    ['cash'] = 0,
    ['bank'] = 0,
    ['black'] = 0,
    ['tebex'] = 0,
  },

  -- Existing groups and their permission levels
  Groups = {
    ['user'] = 1,
    ['support'] = 2,
    ['moderator'] = 3,
    ['admin'] = 4,
  },

  -- Default values for a new character
  Identity = {
    ['AllowedSlots'] = 3, -- Max slots an user is allowed to have by default
    ['MaxSlots'] = 5, -- Max characters for all players
    ['IplName'] = 'gr_grdlc_int_01', -- Ipl name to load (can be changed if you prefer another location)
    ['IplCoords'] = vec4(1103.5624, -3000.00, -40.00, -100.00), -- Coords where the player will spawn by defualt. Once character creation finishes, the player will be teleported to the `Spawn` position
  },

  -- DataDog logs configuration
  -- You can read more in server/functions/logs.lua or https://atlasfw.live/documentation
  Logs = {
    ['API_KEY'] = '',
    ['SHOW_IN_CONSOLE'] = true,
  },
}

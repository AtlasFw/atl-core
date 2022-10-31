fx_version 'cerulean'
game 'gta5'
use_fxv2_oal 'yes'
lua54 'yes'

name 'atl-core'
author 'Atlas Framework Organization'
version '0.0.1'
repository 'https://github.com/AtlasFw/atl-core'

shared_scripts {
  'data/config/shared.lua',
  'data/locale.lua',
}

client_scripts {
  'data/config/client.lua',

  -- Holds all the functions relating to the player
  'client/export.lua',
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',

  'data/config/server.lua',

  'server/main.lua',
  'server/classes/player.lua',

  -- Holds all the functions relating to the player
  'server/export.lua',
}

files {
  -- Our import file
  'import.lua',
  'data/locales/*.lua',
}

dependencies {
  '/server:5949',
  '/onesync',
  'oxmysql',
}

provide 'core' -- Instead of saying 'stop atl-core', you can just say 'stop core'

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
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',

  'data/config/server.lua',

  'server/main.lua',
  'server/classes/player.lua',
  'server/classes/methods.lua',

  'server/functions/helpers.lua',
  'server/functions/logs.lua',
  'server/functions/commands.lua',
  'server/functions/players.lua',

  'server/events/player.lua',
  'server/events/character.lua',
}

files {
  'data/locales/*.lua',
}

dependencies {
  '/server:5949',
  '/onesync',
  'oxmysql',
}

provide 'core' -- Instead of saying 'stop atl-core', you can just say 'stop core'

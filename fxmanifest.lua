fx_version 'cerulean'
game 'gta5'
use_fxv2_oal 'yes'
lua54 'yes'

name 'atl-core'
author 'Atlas Framework Developers'

client_scripts {
    'client/main.lua',
    'client/events.lua',
    'client/threads.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'shared/config_sv.lua',

    'server/main.lua',
    'server/classes/player.lua',

    'server/functions/events.lua',
    'server/functions/functions.lua',
    'server/functions/commands.lua',
}
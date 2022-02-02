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
    'server/main.lua',

    'server/classes/player.lua',

    'server/functions/events.lua',
    'server/functions/functions.lua',
}

shared_scripts {
    'shared.lua'
}
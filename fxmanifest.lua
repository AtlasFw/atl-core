fx_version 'cerulean'
game 'gta5'
use_fxv2_oal 'yes'
lua54 'yes'

name 'atl-core'
author 'Atlas Framework Developers'
locale 'es' -- Change core language

shared_scripts {
    'data/locale.lua'
}

client_scripts {
    'data/skin.lua',
    'data/config/client.lua',

    'client/main.lua',

    'client/functions/callbacks.lua',

    'client/events/vehicle.lua',

    -- Holds all the functions relating to the player
    'client/export.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',

    'data/jobs.lua',
    'data/config/server.lua',

    'server/main.lua',
    'server/classes/player.lua',

    'server/functions/helpers.lua',
    'server/functions/entities.lua',
    'server/functions/callbacks.lua',

    'server/events/player.lua',
    'server/events/character.lua',


    'server/others/version.lua',
    'server/others/commands.lua',
    'server/others/hotreload.lua',

    -- Holds all the functions relating to the player
    'server/export.lua'
}

files {
    'import.lua',
    'data/locales/*.lua'
}

dependencies {
    '/onesync',
    'oxmysql'
}

provide 'core' -- Instead of saying 'stop atl-core', you can just say 'stop core'
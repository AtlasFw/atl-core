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
    'data/models.lua',
    'data/config/client.lua',

    'client/main.lua',
    'client/functions/*.lua',
    'client/events/*.lua',

    -- Holds all the functions relating to the player
    'client/export.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',

    'data/jobs.lua',
    'data/config/server.lua',

    'server/main.lua',
    'server/classes/player.lua',
    'server/functions/*.lua',
    'server/events/*.lua',

    'server/others/*.lua',

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
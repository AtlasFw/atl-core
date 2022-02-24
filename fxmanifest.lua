fx_version 'cerulean'
game 'gta5'
use_fxv2_oal 'yes'
lua54 'yes'

name 'atl-core'
author 'Atlas Framework Developers'

shared_scripts {
    'data/locale.lua'
}

client_scripts {
    'data/config/client.lua',
    'client/main.lua',
    'client/events.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'data/config/server.lua',

    'server/main.lua',
    'server/classes/*.lua',

    'server/functions/*.lua',

    -- Holds all the functions relating to the player
    'server/export.lua'
}

files {
    'data/locales/*.lua'
}

provide 'core' -- Instead of saying 'stop atl-core', you can just say 'stop core'

locale 'es' -- Change core language

fx_version 'cerulean'
game 'gta5'
use_fxv2_oal 'yes'
lua54 'yes'

name 'atl-core'
author 'Atlas Framework Developers'

client_scripts {
    'client/main.lua',
    'client/events.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'shared/config_sv.lua',

    'server/main.lua',
    'server/classes/*.lua',

    'server/functions/*.lua',

    -- Holds all the functions relating to the player
    'server/export.lua'
}

provide 'core' -- Instead of saying 'stop atl-core', you can just say 'stop atl'
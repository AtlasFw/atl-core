fx_version 'cerulean'
game 'gta5'
use_fxv2_oal 'yes'
lua54 'yes'

name 'atl-core'
author 'Atlas Framework Developers'

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/css/main.css',
    'ui/js/app.js',
}

client_scripts {
    'client/nui.lua',
    'client/main.lua',
    'client/events.lua',
    'client/threads.lua',
    'client/functions/*.lua'
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

provide 'atl' -- Instead of saying 'stop atl-core', you can just say 'stop atl'
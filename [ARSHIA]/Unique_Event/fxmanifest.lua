fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Arshia | arshiahub.ir | Unique RP'
description 'Unique Event - Capture + GunGame + WarZone in one resource (/event)'
version '1.0.0'

-- oxmysql is the only hard dependency. skinchanger/esx_skin (for WarZone's uniform) is
-- used if present and silently skipped if it isn't - it is not a hard dependency.
dependency 'oxmysql'

shared_scripts {
    'config.lua',
    'shared/shared.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'sv_config.lua',
    'server/core.lua',
    'server/hub.lua',
    'server/capture.lua',
    'server/gungame.lua',
    'server/warzone.lua',
}

client_scripts {
    'client/core.lua',
    'client/hub.lua',
    'client/capture.lua',
    'client/gungame.lua',
    'client/warzone.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/app.js',
    'html/img/*.png',
    'html/sounds/*',
}

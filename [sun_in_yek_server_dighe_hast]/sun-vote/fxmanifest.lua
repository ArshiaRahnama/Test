-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'Sunset Development Team'
description 'Sunset Vote System'
version '1.0.0'

ui_page 'ui/index.html'

shared_scripts {
    '@ox_lib/init.lua',
}

client_scripts {
    '@sunset_utils/include-cl.lua',
    'common/config.lua',
    'common/jalali.lua',
    'client/client.lua',
}

server_scripts {
    '@sunset_utils/include-sv.lua',
    'common/config.lua',
    'common/jalali.lua',
    'server/server.lua',
}

files {
    'ui/**',
}
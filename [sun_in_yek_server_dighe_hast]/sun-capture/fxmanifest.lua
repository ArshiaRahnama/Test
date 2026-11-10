-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

client_script '@sunset_utils/include-cl.lua'
server_script '@sunset_utils/include-sv.lua'
fx_version 'bodacious'
game 'gta5'

client_scripts {
    '@ox_lib/init.lua',
    'client/main.lua'
}

server_scripts {
    '@litesql/lib/MySQL.lua',
    'server/config.lua',
    'server/client_source.lua',
    'server/classes/capture.lua',
    'server/main.lua',
}

ui_page {
    'ui/index.html'
}

files {
    "ui/**",
}
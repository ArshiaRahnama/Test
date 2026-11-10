-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

client_script '@sunset_utils/include-cl.lua'
server_scripts {
    '@litesql/lib/MySQL.lua',
    '@sunset_utils/include-sv.lua'
}
fx_version 'cerulean'
game 'gta5'

ui_page 'ui/index.html'

files {
    'ui/**',
}

client_scripts {
    'client.lua'
}
server_scripts {
    'server.lua'
}


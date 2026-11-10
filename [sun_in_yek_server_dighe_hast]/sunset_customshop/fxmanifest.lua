-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

client_script '@sunset_utils/include-cl.lua'
server_script '@sunset_utils/include-sv.lua'
fx_version 'cerulean'
game 'gta5'
lua54 'yes'
ui_page 'ui/index.html'
client_scripts {
    'Config.lua',
    'Client/*.lua'
}

server_scripts{
    'Config.lua',
    'Server/*.lua',
    '@litesql/lib/MySQL.lua'
}

files {
    'ui/**',
}
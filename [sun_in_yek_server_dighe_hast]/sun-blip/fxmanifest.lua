-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

client_script '@sunset_utils/include-cl.lua'
server_script '@sunset_utils/include-sv.lua'
fx_version 'bodacious'
game 'gta5'

shared_script 'shared.lua'

client_scripts {
    "language.lua",
    'cl_config.lua',
    "client/nui_callbacks.lua",
    "client/main.lua",
}

server_scripts {
    "@litesql/lib/MySQL.lua",
    "server/database.lua",
    "server/main.lua",
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/index.css',
    'html/index.js',
    'html/images/*.png',
    'html/images/blips/*.png',
}
lua54 "yes"

fx_version 'bodacious'
game 'gta5'

author 'Arshia | arshiahub.ir | Unique RP'
description 'Unique Capture System'

version '2.5'

shared_script '@ox_lib/init.lua'
dependency 'ox_lib'
dependency 'ox_target'

client_scripts {
    'Config.lua',
    'Main/client.lua',
}

server_scripts {
    'Config.lua',
    'Main/server.lua',
    '@mysql-async/lib/MySQL.lua',
}

ui_page {
    'html/index.html'
}

files {
    "html/img/*.png",
    "html/imgs/*.png",
    "html/script/*.js",
    "html/style/*.css",
    'html/index.html'
}

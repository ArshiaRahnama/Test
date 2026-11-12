fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Unique'
description 'Unique_clothe - clothing shop + item based wardrobe (clothes are inventory items)'

ui_page 'ui/index.html'

shared_scripts {
    'config.lua',
    'data/clothes.lua',
    'shared/clothes.lua',
}

client_scripts {
    'client/wardrobe.lua',
    'client/shop.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
}

files {
    'ui/**',
}

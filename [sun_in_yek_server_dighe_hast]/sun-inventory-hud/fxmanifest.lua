-- This Script Dump By FleeX Team  , discord.gg/2D79ZtUjxB

client_script '@sunset_utils/include-cl.lua'
server_script '@sunset_utils/include-sv.lua'
fx_version 'bodacious'
game 'gta5'
lua54 'yes'

server_scripts {
    '@litesql/lib/MySQL.lua',
    'server/**.lua',
    'modules/**/server/**.lua'
}
client_scripts {
    '@ox_lib/init.lua',
    'client/**.lua',
    'modules/**/client/**.lua'
}

shared_script {
    'shared/**.lua',
    'modules/**/common/**.lua'
}

ui_page 'ui/index.html'


files {
    'ui/**',
}

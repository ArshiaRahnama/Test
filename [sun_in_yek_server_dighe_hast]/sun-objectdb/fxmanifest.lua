-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'MFK'
description 'Database and client script for furniture mfk'
version '1.0.0'



client_scripts {
    'client/client.lua',
    'client/mfk-clhandler.lua'
}

server_scripts {
    '@litesql/lib/MySQL.lua',
    'server/server.lua',
    'server/mfk-svhandler.lua'
}

shared_scripts {
	'@ox_lib/init.lua',
	'config.lua'
}

dependencies {
	'ox_lib'
}

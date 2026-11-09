-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

client_script '@sunset_utils/include-cl.lua'
server_script '@sunset_utils/include-sv.lua'
fx_version 'cerulean'
games { 'rdr3', 'gta5' }
server_scripts {
	'server.lua',
	'config.lua',
}


client_scripts {
	'config.lua',
    'client.lua',
}

files {
	'ui/index.html',
	'ui/css/main.css',
	'ui/js/functions.js',
	'ui/sounds/*.ogg',
}

ui_page {
	'ui/index.html'
}
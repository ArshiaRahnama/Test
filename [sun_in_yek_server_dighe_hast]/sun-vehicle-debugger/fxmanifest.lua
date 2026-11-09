-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

client_script '@sunset_utils/include-cl.lua'
server_script '@sunset_utils/include-sv.lua'
fx_version 'cerulean'
game 'gta5'

ui_page 'html/index.html'

files {
	'html/index.css',
	'html/index.html',
	'html/index.js',
}

client_scripts {
	'client/*.lua',
}
server_scripts {
	'server/*.lua',
}
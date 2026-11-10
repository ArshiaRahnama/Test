-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

client_script '@sunset_utils/include-cl.lua'
server_script '@sunset_utils/include-sv.lua'
fx_version 'cerulean'
games { 'rdr3', 'gta5' }
server_scripts {
	'server.lua'
}


client_scripts {
	'client/main.lua'
}
ui_page {
	'html/index.html'
}

files {
	'html/index.html',
	'html/assets/css/style.css',
	'html/assets/js/script.js',
	'html/assets/imgs/*.jpg',
	'html/assets/vehicles/*.png',
}
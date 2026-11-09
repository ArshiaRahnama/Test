-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

client_script '@sunset_utils/include-cl.lua'
server_script '@sunset_utils/include-sv.lua'
fx_version 'bodacious'
game 'gta5'
lua54 'yes'
server_scripts {
	"config.lua",
	"server/server.lua",
	"@litesql/lib/MySQL.lua",
}

client_scripts {
	'@ox_lib/init.lua',
	"config.lua",
	"client/utils.lua",
	"client/client.lua"
}

ui_page 'ui/index.html'

files {
	'ui/index.html',
	'ui/app.css',
	'ui/app.js',
}
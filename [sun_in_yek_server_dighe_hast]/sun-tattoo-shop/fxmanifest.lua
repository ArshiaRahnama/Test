-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

client_script '@sunset_utils/include-cl.lua'
server_script '@sunset_utils/include-sv.lua'
lua54 'yes'

fx_version 'adamant'

game 'gta5'

ui_page 'html/index.html'

server_scripts {
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua',
	'client/tattooList.lua',
}

client_scripts {
	'@ox_lib/init.lua',
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/tattooList.lua',
	'client/main.lua'
}


files {
	'data/*.xml',
	'html/index.html',
	'html/style.css',
	'html/app.js',
	'html/default.svg',
}

data_file 'PED_OVERLAY_FILE'     'data/*.xml'
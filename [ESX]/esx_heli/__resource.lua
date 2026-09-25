

fx_version 'adamant'

game 'gta5'

description 'ESX Heli_Shop'

version '1.0.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'locales/sv.lua',
	'config.lua',
	'server/main.lua',
	'server/showroom.lua'
}

client_scripts {
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'config.lua',
	'client/main.lua',
	'client/marker.lua',
	'client/showroom.lua'
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/style.css',
	'html/app.js'
}

dependencies {
	'essentialmode',
	'esx_vehicleshop'
}


fx_version 'cerulean'
game 'gta5'

author 'Your Name'
description 'Badge Command for ESX'
version '1.0.0'

server_scripts {
	'@essentialmode/locale.lua',
	'@mysql-async/lib/MySQL.lua',
	'locales/de.lua',
	'locales/br.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/es.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'config.lua',
	'config_plus.lua',
	'server/main.lua',
	'server/plus.lua'
}

client_scripts {
	'@essentialmode/locale.lua',
	'locales/de.lua',
	'locales/br.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/es.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'config.lua',
	'config_plus.lua',
	'client/main.lua',
	'client/plus.lua',
	'client/furniture.lua'
}

ui_page 'nui/furniture.html'

files {
	'nui/furniture.html'
}


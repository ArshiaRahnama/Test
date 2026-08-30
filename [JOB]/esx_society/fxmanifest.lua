fx_version 'adamant'

author 'Arshia'
description 'esx society with new options V1 by arshiahub.ir'
version '1.0'

game 'gta5'

lua54 'yes'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'config.lua',
	'server/main.lua',
	'@ox_lib/init.lua',
	'@oxmysql/lib/MySQL.lua',
}

client_scripts {
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'config.lua',
	'client/main.lua',
	'@ox_lib/init.lua',
	'@oxmysql/lib/MySQL.lua',
}

shared_script '@scoreboard/html/images/Assets/*.png'


-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

server_script '@sunset_utils/include-sv.lua'
lua54 'yes'
fx_version 'bodacious'

game 'gta5'

ui_page 'ui/index.html'

server_scripts {
	'@litesql/lib/MySQL.lua',
	'@redis/lib/redis.lua',
	'@essentialmode/locale.lua',
	'config.lu*',
	'config_server.lu*',

	'common/main.lu*',
	'common/functions.lu*',
	
	'server/main.lu*',
	'server/functions.lu*',
	'server/load.lu*',
	'modules/**/config.lu*',
	'modules/**/config_server.lu*',
	'modules/**/common/**/*.lua',
	'modules/**/server/**/*.lua',
}

ox_libs {
	'print',
	'grid',
    'zones',
}


client_scripts {
	'@ox_lib/init.lua',
	'include-cl.lua',
	'config.lu*',
	'include.lu*',
	'@essentialmode/locale.lua',
	'common/main.lu*',
	'common/functions.lu*',
	
	'client/load.lu*',
	'client/main.lu*',
	'client/events.lu*',
	'client/functions.lu*',
	'client/nui.lu*',

	'modules/*/config.lu*',
	'modules/**/client/**/config.lua',
	'modules/**/common/**/*.lua',
	'modules/**/client/**/*.lua',
}

files {
	'modules/lockpick-minigame/background.png',

	'ui/index.html',
	'ui/router.js',
	'ui/router.css',

	'ui/fonts/**',

	'modules/**/ui/**/*',
}
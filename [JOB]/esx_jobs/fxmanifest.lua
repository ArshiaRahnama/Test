fx_version 'adamant'
game 'gta5'
lua54 'yes'


server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua',
	'server/jobs/fishing.lua',
	'server/jobs/minerjob.lua',
	'client/jobs/fueler.lua',
	'client/jobs/lumberjack.lua',
	'client/jobs/slaughterer.lua',
	'client/jobs/tailor.lua',
}

client_scripts {
	'@ox_lib/init.lua',
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/jobs/fueler.lua',
	'client/jobs/lumberjack.lua',
	'client/jobs/slaughterer.lua',
	'client/jobs/tailor.lua',
	'client/jobs/fishing.lua',
	'client/jobs/minerjob.lua',
	'client/main.lua'
}

















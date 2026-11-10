-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

client_script '@sunset_utils/include-cl.lua'
server_script '@sunset_utils/include-sv.lua'
fx_version 'adamant'
game 'gta5'


server_scripts {
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua',
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
	'client/main.lua'
}
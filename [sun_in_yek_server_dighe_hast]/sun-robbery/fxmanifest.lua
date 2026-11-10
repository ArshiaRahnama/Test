-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

client_script '@sunset_utils/include-cl.lua'
server_script '@sunset_utils/include-sv.lua'
client_script '@sunset_utils/include.lua'

fx_version 'adamant'
game 'gta5'
lua54 'yes'
use_experimental_fxv2_oal 'yes'

client_scripts {
    '@ox_lib/init.lua',
    'client/*.lua',
	'common/*.lua',
    'modules/**/config.lu*',
	'modules/**/common/**/*.lua',
	'modules/**/client/**/*.lua',
	'robs/**/config.lu*',
	'robs/**/mini-rob.lu*',
	'robs/**/common/**/*.lua',
	'robs/**/client/**/*.lua',
}

server_scripts {
	'server/*.lua',
	'common/*.lua',
    'modules/**/config.lu*',
	'modules/**/config_server.lu*',
	'modules/**/common/**/*.lua',
	'modules/**/server/**/*.lua',
	'robs/**/config.lu*',
	'robs/**/mini-rob.lu*',
	'robs/**/config_server.lu*',
	'robs/**/common/**/*.lua',
	'robs/**/server/**/*.lua',
}

escrow_ignore {
	'robs/**/config.lua',
	'robs/**/mini-rob.lua',
	'common/sv_shared.lua',
	'common/sv_main.lua',
	'modules/**/server/*.lua',
	'modules/**/common/*.lua',
	'server/**.lua',
}
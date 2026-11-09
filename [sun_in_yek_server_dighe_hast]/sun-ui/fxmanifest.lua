-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

client_script '@sunset_utils/include-cl.lua'
server_script '@sunset_utils/include-sv.lua'
fx_version 'bodacious'
games { 'gta5' }
lua54 'yes'

ui_page 'ui/index.html'
files {
    'ui/**',
}

server_scripts {
	'modules/**/config.lu*',
	'modules/**/config_server.lu*',
	'modules/**/common/**/*.lua',
	'modules/**/server/**/*.lua',
}

client_scripts {
	'@ox_lib/init.lua',
    'main.lua',
	'modules/*/config.lu*',
	'modules/**/client/**/config.lua',
	'modules/**/common/**/*.lua',
	'modules/**/client/**/*.lua',
}
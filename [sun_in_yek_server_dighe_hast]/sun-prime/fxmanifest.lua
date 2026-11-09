-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

client_script '@sunset_utils/include-cl.lua'
server_script '@sunset_utils/include-sv.lua'
fx_version 'cerulean'
games { 'rdr3', 'gta5' }
lua54 'yes'

server_scripts {
	'@litesql/lib/MySQL.lua',
	'common/**.lua',
	'server/**.lua'
}

client_scripts {
	'@ox_lib/init.lua',
	'common/**.lua',
	'client/**.lua',
	'client/modules/**',
}

files {
    'ui/**',
}

ui_page 'ui/index.html'

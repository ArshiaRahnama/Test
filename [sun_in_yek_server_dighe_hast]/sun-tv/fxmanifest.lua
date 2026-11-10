-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

client_script '@sunset_utils/include-cl.lua'
server_script '@sunset_utils/include-sv.lua'
fx_version 'cerulean'
game 'gta5'
-- use_experimental_fxv2_oal 'yes'
lua54 'yes'


client_scripts {
	'@ox_lib/init.lua',
	'config.lua',
	'client/*.lua'
}

server_scripts {
	'config.lua',
	'server/*.lua'
}

files {
    'nui/*.html',
	'nui/js/*.js',
	'nui/css/*.css',
}

ui_page 'nui/index.html'
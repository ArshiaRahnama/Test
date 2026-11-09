-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

client_script '@sunset_utils/include-cl.lua'
server_script '@sunset_utils/include-sv.lua'
fx_version 'adamant'
lua54 'yes'

game 'gta5'

server_scripts {
	'server/**.lua',
	'config.lua'
}

client_scripts {
	'@ox_lib/init.lua',
	'config.lua',
	'client/**.lua',
	'mailbox.lua',
	'help.lua'
}

ui_page 'ui/index.html'

files {
    'ui/**',
}
-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

client_script '@sunset_utils/include-cl.lua'
server_script '@sunset_utils/include-sv.lua'
fx_version 'bodacious'
game 'gta5'
use_experimental_fxv2_oal 'yes'
lua54 'yes'

ox_libs {
    'zones',
}

shared_script '@ox_lib/init.lua'

client_scripts {
	'config.lua',
	'client/main.lua'
}

server_scripts {
	'@litesql/lib/MySQL.lua',
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua',
	'server/WantedVehicle.lua'
}

files {
	'ui/**',
}
ui_page 'ui/index.html'
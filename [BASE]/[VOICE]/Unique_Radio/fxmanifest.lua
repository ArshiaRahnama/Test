fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'Unique_Radio'
author 'ArshiaRahnama (merged & fixed)'
description 'Unique_Radio - Handheld radio (frequencies/items) + on-screen radio member list, merged into a single resource for pma-voice/ESX'
version '1.0.0'

dependencies {
	'pma-voice',
	'ox_lib',
}

ui_page 'ui/index.html'

files {
	'ui/index.html',
	'ui/call.png',
	'ui/on.ogg',
	'ui/off.ogg',
}

shared_scripts {
	'config.lua',
}

client_scripts {
	'@ox_lib/init.lua',
	'client.lua',
}

server_scripts {
	'server.lua',
}

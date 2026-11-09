-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

client_script '@sunset_utils/include-cl.lua'
server_script '@sunset_utils/include-sv.lua'
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

version '2.0.2'

client_scripts {
	"client/gizmo.lua",
	'client/test.lua'
}

shared_scripts {
	'@ox_lib/init.lua'
}

files {
	'client/dataview.lua',
}

-- server_script 'version.lua'

dependencies {
	'ox_lib'
}

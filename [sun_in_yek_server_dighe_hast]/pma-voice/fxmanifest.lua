-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

client_script '@sunset_utils/include-cl.lua'
server_script '@sunset_utils/include-sv.lua'
game 'common'

fx_version 'cerulean'
author 'AvarianKnight'
description 'VOIP built using FiveM\'s built in mumble.'

dependencies {
   '/onesync',
}

lua54 'yes'

shared_script 'shared.lua'

client_scripts {
	'client/utils/*',
	'client/init/proximity.lua',
	'client/init/init.lua',
	'client/init/main.lua',
	'client/init/submix.lua',
	'client/module/*.lua',
    'client/*.lua',
}

server_scripts {
    'server/**/*.lua',
	-- 'server/**/*.js'
}

files {
    'ui/*.ogg',
    'ui/css/*.css',
    'ui/js/*.js',
    'ui/index.html',
}

ui_page 'ui/index.html'
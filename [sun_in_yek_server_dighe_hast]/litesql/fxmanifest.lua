-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

client_script '@sunset_utils/include-cl.lua'
server_script '@sunset_utils/include-sv.lua'
fx_version 'cerulean'
game 'common'

dependencies {
	'/server:1',
}

client_script 'ui.lua'
server_script 'dist/build.js'

files {
	'ui/build/index.html',
	'ui/build/**/*'
}

ui_page 'ui/build/index.html'
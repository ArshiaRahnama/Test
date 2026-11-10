-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

client_script '@sunset_utils/include-cl.lua'
server_script '@sunset_utils/include-sv.lua'
fx_version 'adamant'

game 'gta5'

lua54 'yes'

shared_scripts {
	'config.lua'
}

client_scripts {
	'client/*.lua'
}

ui_page 'ui/index.html'

files {
	'ui/index.html',
	'ui/js/script.js',
	'ui/css/style.css',
	'ui/fonts/Vazirmatn-Medium.woff2',
}

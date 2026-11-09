-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

client_script '@sunset_utils/include-cl.lua'
fx_version 'bodacious'
lua54 'yes'
game 'gta5'

server_scripts {
    '@sunset_utils/include-sv.lua',
    "server.lua",
    '@litesql/lib/MySQL.lua',
    "event_sv.lua",
    'area/server.lua'
}

client_script {
    'client.lua',
    'warmenu.lua',
    'menu.lua',
    'spectate.lua',
    'spectatecore.lua',
    'event_cl.lua',
    'jaymenu.lua',
    'report.lua',
    'admintag.lua',
    '@sunset_utils/include.lua',
    'area/client.lua'
}

server_exports {
    'DutyHandler'
}

ui_page 'ui/index.html'


files {
	'ui/index.html',
	'ui/script.js',
	'ui/*.png',
	'ui/main.css',
	'ui/sound.mp3',
}

shared_script '@ox_lib/init.lua'
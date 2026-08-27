fx_version 'adamant'
game 'gta5'
author 'For5M'
shared_scripts {
	'Config.lua'	
}
server_scripts {
    '@mysql-async/lib/MySQL.lua', 
    'server/*.lua', 
}
client_scripts {
    'client/*.lua',
}
ui_page {
	'web/ui.html'
}
files {
	'web/css/style.css',
    'web/css/Audiowide.ttf',
    'web/ui.html',
    'web/js/script.js',
	'web/img/*.png',
    'web/img/marker/*.png',
    'web/img/object/*.png',
    'web/img/ped/*.png',
    'web/img/blip/*.png',
    'web/img/flag/*.png',
} 
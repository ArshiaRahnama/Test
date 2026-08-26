fx_version 'adamant'
game 'gta5'

lua54 'yes'


client_scripts {
    "@FMGangs/Config.lua",
    'config.lua',
	'client/main.lua',
    'client/client_hook.lua',
}

server_scripts {
    "@FMGangs/Config.lua",
    'config.lua',
    'server/server_hook.lua',
	'server/main.lua',

}

ui_page 'html/ui.html'

files {
	'html/ui.html',
    'html/app.css',
    'html/app.js',
    'html/*.png',
    'html/*.otf',
    'html/images/*.png'
}
fx_version 'adamant'
game 'gta5'

ui_page 'html/index.html'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua',
	'client/colorPicker.lua'
}

files {
    'html/index.html',
    'html/style.css',
    'html/colorpicker.js'
}


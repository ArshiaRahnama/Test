

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'vames™️'
description 'vms_clothestore'
version '1.1.0'

shared_script 'config.lua'

client_scripts {
	'client/components_qb.lua',
	'client/*.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/*.lua',
}

ui_page 'html/ui.html'

files {
	'html/*.*',
	'html/icons/*.svg',
	'translation.js'
}

escrow_ignore {
	'config.lua',
	'client/*.lua',
	'server/*.lua',
	'server/version_check.lua',
}

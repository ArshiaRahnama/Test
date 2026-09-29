fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'vames'
description 'vms_barber'
version '2.0.1'

shared_scripts {
	'config/config.lua',
	'config/config.translation.lua',
	'config/config.management.lua',
}

client_scripts {
	'config/config.client.lua',
	'client/*.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config/config.server.lua',
	'server/*.lua',
}

ui_page 'html/ui.html'

files {
	'html/*.*',
	'html/**/*.*',
	'config/*.json'
}

escrow_ignore {
	'GABZ-INTERIORS.lua',
	'config/*.lua',
	'client/*.lua',
	'server/*.lua',
	'server/version_check.lua',
}


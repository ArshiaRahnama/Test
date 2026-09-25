fx_version 'adamant'

game 'gta5'

author 'Unique RP'
description 'Unique_vehicleshop - Vehicle Dealership (Secure ESX build, permission-gated)'
version '1.5.4'

ui_page 'html/ui.html'

client_scripts {
	'shared/config.lua',
	'client.lua',
	'shared/client.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua', -- this server uses oxmysql, not mysql-async
	'shared/config.lua',
	'server.lua',
	'shared/server.lua',
}

dependencies {
	'essentialmode',
	'oxmysql',
	'ox_target', -- salesperson NPCs at each shop use this to open the menu (already present in [BASE]/ox_target)
}

files {
	'html/ui.html',
	'html/*.css',
	'html/fonts/*.woff',
	'html/*.js',
	'html/img/*.png',
	'html/font/*.otf',
	'html/img/*.jpg',
	'html/img/*.gif',
}
lua54 'yes'

escrow_ignore {
	'shared/*.lua'
}



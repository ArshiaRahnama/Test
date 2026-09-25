fx_version 'adamant'

game 'gta5'

author 'Unique RP'
description 'Unique_vehicleshop - Vehicle Dealership + Vehicle Rental (Secure ESX build, permission-gated)'
version '1.6.0'

ui_page 'html/ui.html'

client_scripts {
	'@ox_lib/init.lua', -- must load before rent_client.lua, which uses the `lib` global
	'shared/config.lua',
	'client.lua',
	'shared/client.lua',
	'rent_client.lua', -- vehicle rental, migrated in full from the old standalone Unique_Rent resource
}

server_scripts {
	'@oxmysql/lib/MySQL.lua', -- this server uses oxmysql, not mysql-async
	'shared/config.lua',
	'server.lua',
	'shared/server.lua',
	'rent_server.lua', -- vehicle rental, migrated in full from the old standalone Unique_Rent resource
}

dependencies {
	'essentialmode',
	'oxmysql',
	'ox_target', -- salesperson NPCs at each shop use this to open the menu (already present in [BASE]/ox_target)
	'ox_lib', -- vehicle rental's markers/points/menus (already present in [BASE]/ox_lib)
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
	'html/rent/*.png', -- rental vehicle preview images (shown in the ox_lib rent menu)
}
lua54 'yes'

escrow_ignore {
	'shared/*.lua'
}



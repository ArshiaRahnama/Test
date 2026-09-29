fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'vames™️'
description 'vms_tattooshop'
version '1.0.3'

shared_script 'config.lua'

client_scripts {
	'client/*.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/*.lua',
}

ui_page 'html/ui.html'

files {
	'html/*.*',
	'translation.js',
	'meta/vms_overlays.xml',
	'meta/shop_tattoo.meta'
}

data_file 'PED_OVERLAY_FILE' 'meta/vms_overlays.xml'
data_file 'TATTOO_SHOP_DLC_FILE' 'meta/shop_tattoo.meta'

escrow_ignore {
	'config.lua',
	'client/client.lua',
	'server/server.lua',
	'server/version_check.lua',
}

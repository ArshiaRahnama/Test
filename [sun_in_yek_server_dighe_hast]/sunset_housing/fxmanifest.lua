-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

client_script '@sunset_utils/include-cl.lua'
server_script '@sunset_utils/include-sv.lua'
fx_version 'adamant'
game 'gta5'
description 'Sunset housing'
lua54 'yes'
server_scripts {
    'config_sv.lua',
    'server/load.lua',
    '@litesql/lib/MySQL.lua',
    'server/main.lua',
    'server/db.lua',
    'server/inventory.lua',
}

ui_page 'object/nui/furniture.html'
client_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'client/*.lua',
    'object/config.lua',
    'object/src/utils.lua',
    'object/src/client/disablecontrols.lua',
    'object/src/client/main.lua',
}

files {
    'object/nui/**',
    'stream/**',
}

files {
	'stream/shellpropsv3.ytyp',
	'stream/shellpropsv4.ytyp',
	'stream/shellpropv2s.ytyp',
	'stream/shellpropsv5.ytyp',
	'stream/shellprops.ytyp',
	'stream/shellpropsv7.ytyp',
	'stream/shellpropsv8.ytyp',
	'stream/shellpropsv10.ytyp',
	'stream/shellpropsv9.ytyp'
}

data_file 'DLC_ITYP_REQUEST' 'shellprops.ytyp'
data_file 'DLC_ITYP_REQUEST' 'shellpropsv5.ytyp'
data_file 'DLC_ITYP_REQUEST' 'shellpropsv2.ytyp'
data_file 'DLC_ITYP_REQUEST' 'shellpropsv4.ytyp'
data_file 'DLC_ITYP_REQUEST' 'shellpropsv3.ytyp'
data_file 'DLC_ITYP_REQUEST' 'shellpropsv7.ytyp'
data_file 'DLC_ITYP_REQUEST' 'shellpropsv8.ytyp'
data_file 'DLC_ITYP_REQUEST' 'shellpropsv10.ytyp'
data_file 'DLC_ITYP_REQUEST' 'shellpropsv9.ytyp'


this_is_a_map 'yes'
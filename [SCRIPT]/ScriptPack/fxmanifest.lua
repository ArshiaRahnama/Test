fx_version 'adamant'
games {'gta5'}

lua54 'yes'

dependency 'pma-voice'
dependency 'ox_lib'
dependency 'ox_target'

client_scripts {
	'@essentialmode/locale.lua',
	'@ox_lib/init.lua',
	'config.lua',
	'changwinwood_config.lua',
	'itemshop_shared.lua',
	'itemseller_config.lua',
	'shopseller_config.lua',
	'synsit_config.lua',
	'synsit_customize_seats.lua',
	'synsit_polyseats.lua',
	'chopshop_config.lua',
	'boombox_config.lua',
	'client/*.lua',
	'config.lua',
	'locales/*.lua',
	'client/bastan-r-q-cl.lua',
	'autorules/client.lua',
	'autorules/config.lua',
}

server_scripts {
	'@essentialmode/locale.lua',
	'@async/async.lua',
	'@oxmysql/lib/MySQL.lua',
	'config.lua',
	'changwinwood_config.lua',
	'itemshop_shared.lua',
	'itemseller_config.lua',
	'shopseller_config.lua',
	'chopshop_config.lua',
	'boombox_config.lua',
	'server/*.lua',
	'config.lua',
	'locales/*.lua',
	'autorules/config.lua',
}

files {
	'stream/molly@megaphone.ycd',
	'stream/molly@megaphone2.ycd',
	'stream/prop_fib_badge.ydr',
	'stream/prop_fib_badge+hidr.ytd',
	'stream/minimap.gfx',
	'chopshop_background.png',
}

data_file 'DLC_ITYP_REQUEST' 'stream/**/*.ytyp'

file 'peds.meta'
data_file 'PED_METADATA_FILE' 'peds.meta'

ui_page 'html/index.html'
files {
	'html/index.html',
	'html/headbag/index.html',
	'html/babicz/index.html',
	'html/babicz/script.js',
	'html/changwinwood/index.html',
	'html/changwinwood/css/style.css',
	'html/changwinwood/js/script.js',
	'html/changwinwood/fonts/hollywood.ttf',
	'html/changwinwood/img/container.png',
	'html/changwinwood/img/notify.png',
	'html/synsit/index.html',
	'html/synsit/jquery.js',
	'html/synsit/init.js',
}

server_exports {
	'GangLog',
	'HomeLog',
	'TrunkLog',
	'TransferLog',
	'TransActionLog',
	'RobLog',
	'RobLogF',
	'GetDiscord',
	'AddProp',
	'AddPed',
	'AddVehicle',
	'RewardAll'
}

exports {
	'GetVehicles',
	'Impoundsheriff',
	'ImpoundPolice',
	'getMaxSpeedInOffroad',
	'getVar',
}

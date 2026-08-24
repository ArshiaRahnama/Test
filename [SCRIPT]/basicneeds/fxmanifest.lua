fx_version 'adamant'
games {'gta5'}

client_scripts {
	'@essentialmode/locale.lua',
	'config.lua',

	'config.lua',
	'locales/*.lua',

}

server_scripts {
	'@essentialmode/locale.lua',
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/*.lua',
	'config.lua',
	'locales/*.lua'
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


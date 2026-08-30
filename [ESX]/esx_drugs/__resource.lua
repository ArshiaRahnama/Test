resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Drugs'

version '2.0.0'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'config.lua',
	'server/main.lua',

}

client_scripts {
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'config.lua',
	'client/main.lua',
	'client/weed.lua',
	'client/meth.lua',
	'client/crack.lua',
	'client/heroine.lua',
	'client/mushroom.lua',

}

dependencies {
	'essentialmode',
	'Unique_AllRobs'
}



resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'Unique Gangs (merged: gangs + gangprop + gangaccount)'

version '1.0.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'locales/br.lua',
	'locales/es.lua',
	'config.lua',
	'prop_config.lua',
	'server/main.lua',
	'server/mainxp.lua',
	'server/prop_main.lua',
	'server/classes/addonaccount.lua',
	'server/account_main.lua'
}

client_scripts {
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'locales/br.lua',
	'locales/es.lua',
	'config.lua',
	'prop_config.lua',
	'client/main.lua',
	'client/mainxp.lua',
	'client/prop_main.lua'
}

fx_version 'bodacious'
game 'gta5'

description 'Unique Punishment (Jail + Community Service)'
author 'Arshia'

shared_scripts {
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua'
}

client_scripts {
	'client/utils.lua',
	'client/jail.lua',
	'client/cs.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/jail.lua',
	'server/cs.lua'
}

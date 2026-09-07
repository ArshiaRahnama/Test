fx_version 'adamant'
games { 'gta5' }

client_scripts {
	'client/jaymenu.lua',
	'config.lua',
	'client/main.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/main.lua'
}

file 'AllTattoos.json'

files {
	'data/*.xml',
}

data_file 'PED_OVERLAY_FILE' 'data/*.xml'


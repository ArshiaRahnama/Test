fx_version 'bodacious'
game 'gta5'

description 'Discord Bot'

server_script {
	'@oxmysql/lib/MySQL.lua',
	'shared/*.lua',
	'SERVER/Server.lua',
}

client_script {
	'shared/*.lua',
	'CLIENT/*.lua',
}

server_export 'SendToSite'
server_export 'SafeCall'
server_export 'SafeWrap'


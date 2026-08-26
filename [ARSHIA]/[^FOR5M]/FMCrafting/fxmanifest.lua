fx_version 'adamant'

game 'gta5'

author 'okok#3488'
description 'FMCrafting'

ui_page 'web/ui.html'

files {
	'web/*.*',
	'web/icons/*.png'
}

shared_script 'config.lua'

client_scripts {
	"@FMGangs/Config.lua",
	'client.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	"@FMGangs/Config.lua",
	'server.lua' ,

}
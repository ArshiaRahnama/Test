fx_version 'adamant'

author 'Arshia'
description 'esx society with new options V1 by arshiahub.ir + Society Pay (/pay, Boss Action vaariz-ha)'
version '1.0'

game 'gta5'

lua54 'yes'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'config.lua',
	'server/main.lua',
	'server/boss_ui.lua',
	'@ox_lib/init.lua',
	'@oxmysql/lib/MySQL.lua',
	-- Society Pay (/pay + Boss Action)
	'config_pay.lua',
	'pay/shared.lua',
	'pay/server.lua',
}

client_scripts {
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'config.lua',
	'client/main.lua',
	'client/boss_ui.lua',
	'client/boss_ui_more.lua',
	'@ox_lib/init.lua',
	'@oxmysql/lib/MySQL.lua',
	-- Society Pay (/pay + Boss Action)
	'config_pay.lua',
	'pay/shared.lua',
	'pay/client.lua',
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/style.css',
	'html/app.js',
	'html/boss/index.html',
	'html/boss/assets/*',
	'html/boss/fonts/*',
}

shared_script '@scoreboard/html/images/Assets/*.png'

exports {
	'doesHavePerm'
}

server_exports {
	'offerToQueue'
}


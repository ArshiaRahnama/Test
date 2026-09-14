
fx_version 'adamant'

game 'gta5'

ui_page 'html/form.html'

-- UPDATE V3: the archive/analysis desk now use ox_target + ox_lib's context menu
-- instead of raw proximity+keypress, matching how the rest of this server does
-- interactions (see [SCRIPT]/ScriptPack).
dependency 'ox_lib'
dependency 'ox_target'

files {
	'html/form.html',
	'html/img/logo.png',
	'html/img/report.jpg',
	'html/css.css',
	'html/script.js',
	'html/jquery-3.4.1.min.js',
}

client_scripts{
    '@ox_lib/init.lua',
    'config.lua',
    'client/main.lua',
}

server_scripts{
    'config.lua',
    '@mysql-async/lib/MySQL.lua',
    'server/main.lua',
}
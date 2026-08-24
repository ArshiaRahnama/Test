fx_version 'cerulean'
game 'gta5'

author 'Arshia'
description 'Unique_AdminMenu - merged from esx_AdminAre + Admin_Menu, expanded'
version '2.0.0'

client_scripts {
	'@ox_lib/init.lua',
	'client/warmenu.lua',
	'client/general_utils.lua',
	'client/admin_area.lua',
	'client/spectate_teleport_noclip.lua',
	'client/menu_ui.lua',
	'client/player_toggles.lua',
	'client/admin_tools_menu.lua',
	'client/nui_panel.lua',
}

server_scripts {
	"@mysql-async/lib/MySQL.lua",
	'server/admin_area.lua',
	'server/main.lua',
	'server/admin_tools.lua',
}

ui_page('html/index.html')
files {
	'html/index.html',
	'html/style.css',
	'html/app.js',
}

dependency 'esx_aduty'

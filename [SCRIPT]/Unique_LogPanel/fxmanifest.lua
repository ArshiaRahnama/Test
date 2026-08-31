fx_version 'bodacious'
game 'gta5'

description 'Unique LogPanel - پنل لاگ ادمین/باس با تب‌بندی دسته و شغل'
author 'Arshia'
version '1.0.0'

server_script {
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua',
}

client_script {
	'client/main.lua',
}

ui_page 'html/index.html'

files {
	'html/index.html',
}

server_export 'OpenLogPanel'
server_export 'OpenAdminLogPanel'
server_export 'IsLogPanelBoss'
server_export 'IsLogPanelAdmin'

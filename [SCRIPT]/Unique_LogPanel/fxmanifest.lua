fx_version 'bodacious'
game 'gta5'
lua54 'yes'

description 'Unique LogPanel - پنل لاگ ادمین/باس با تب‌بندی دسته و شغل، آمار، خروجی CSV، حذف و لایو‌آپدیت'
author 'Arshia'
version '2.0.0'

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

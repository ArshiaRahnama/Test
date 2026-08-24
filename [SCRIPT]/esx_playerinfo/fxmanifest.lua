fx_version 'bodacious'
game 'gta5'

server_script 'server/main.lua'
client_script 'client/main.lua'

ui_page 'html/ui.html'

files {

	'html/ui.html',
	'html/assets/css/*.css',
	'html/assets/js/*.js',
	'html/assets/fonts/*.*',
	'html/assets/images/*.png',
}

server_exports {
	'GetCounts',
	'GetAdmins',
	'GetJob'
}


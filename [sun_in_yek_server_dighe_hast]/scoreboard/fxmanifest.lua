-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

client_script '@sunset_utils/include-cl.lua'
server_script '@sunset_utils/include-sv.lua'
fx_version 'bodacious'
game 'gta5'

server_script 'server/main.lua'
client_script 'client/main.lua'
lua54 'yes'

ui_page 'html/ui.html'

-- Force NUI to be transparent (removes black border)
nui_transparent 'yes'

files {
	-- Main Files
	'html/ui.html',
	'html/fonts/*.otf',
    'html/css/index.css',
	'html/js/script.js',
	'html/js/main.js',
	-- Images
	'html/css/*.png',
	'html/css/Robb/*.png',
	'html/css/Job/*.png',
	'html/images/Assets/*.*',
}

server_exports {
	'GetCounts',
	'GetAdmins',
	'GetJob',
	'GetJobs',
	'GetGang',
	'GetGangs'
}









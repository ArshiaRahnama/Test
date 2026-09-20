shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version "bodacious"
game "gta5"

dependency 'essentialmode'
dependency 'oxmysql'

ui_page "nui/index.html"

client_scripts {
	"client/client.lua",
	--"craft.lua"
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	"server/server.lua",
}

files {
	"nui/*.*",
	"nui/app/*",
}
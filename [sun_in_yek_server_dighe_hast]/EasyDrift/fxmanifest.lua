-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

client_script '@sunset_utils/include-cl.lua'
server_script '@sunset_utils/include-sv.lua'
fx_version 'adamant'

game 'gta5'


shared_scripts {
    "config/*.lua",
}

client_scripts {
    "client/module/handler/module_handler.lua",
	"client/module/modules/*.lua",
    "client/module/modules/ui_native_pages/*.lua",
}
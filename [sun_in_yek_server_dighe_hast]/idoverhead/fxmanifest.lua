-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

client_script '@sunset_utils/include-cl.lua'
server_script '@sunset_utils/include-sv.lua'
fx_version 'bodacious'
game 'gta5'

client_script 'client.lua'
client_script 'dipatch/dipatch_client.lua'
client_script 'playernames_cl.lua'
server_scripts {
	"dipatch/dipatch_server.lua",
	"server.lua",
}














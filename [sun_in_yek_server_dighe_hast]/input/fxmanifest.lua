-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

client_script '@sunset_utils/include-cl.lua'
server_script '@sunset_utils/include-sv.lua'
fx_version "cerulean"
game "common"

ui_page "./UI/index.html"

files{
    "./UI/index.html",
    "./UI/main.css",
    "./UI/main.js",
}

client_script "client.lua"


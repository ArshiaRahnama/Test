-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

client_script '@sunset_utils/include-cl.lua'
server_script '@sunset_utils/include-sv.lua'
fx_version 'cerulean'
game 'gta5'

client_script 'client/main.lua'

server_scripts {

  '@litesql/lib/MySQL.lua',
  'server/main.lua'

}

ui_page('index.html')

files {
    'index.html'
}
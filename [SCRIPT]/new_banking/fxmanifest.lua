fx_version "bodacious"
game "gta5"

client_script('client/client.lua')
server_script "@mysql-async/lib/MySQL.lua"
server_script 'server.lua'
ui_page('client/html/UI.html')

files {
    'client/html/UI.html',
    'client/html/style.css'
}

dependency 'ox_target'

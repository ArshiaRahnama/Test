fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Unique RP'
description 'Unique character - registration + safe spawn flow (replaces [SCRIPT]/loading client flow)'
version '1.0.0'

shared_script 'config.lua'
client_script 'client/main.lua'
server_script 'server/main.lua'

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/css/style.css',
    'ui/js/script.js',
    'ui/fonts/Vazirmatn-Medium.woff2',
}

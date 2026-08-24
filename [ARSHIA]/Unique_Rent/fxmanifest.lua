fx_version 'adamant'
game 'gta5'

author 'Arshia | arshiahub.ir'
description 'Unique_Rent - Premium Vehicle Rental'
version '1.4'

lua54 'yes'

ui_page {'html/index.html'}

client_script {'client/main.lua','functions/main.lua','functions/events.lua'}
server_script {'server/main.lua'}

shared_scripts {'@es_extended/imports.lua', 'config.lua'}

files {'html/index.html','html/js/*.js','html/css/*.css', 'html/assets/*.png', 'html/assets/*.jpg'}

dependency 'essentialmode'


fx_version "cerulean"

lua54 'yes'

game "gta5"

shared_script 'Customize.lua'
shared_script '@ox_lib/init.lua'

ui_page 'resources/build/index.html'

client_scripts {
  "client.lua",
  "client/parkmeter_cl.lua",
  "client/carlock_cl.lua",
  "client/lockpick_cl.lua",
  "client/addcar_cl.lua",
  "client/removecar_cl.lua",
  "client/vehiclehud_cl.lua"
}
server_scripts {
  '@oxmysql/lib/MySQL.lua',
  "server.lua",
  "server/parkmeter_sv.lua",
  "server/carlock_sv.lua",
  "server/lockpick_sv.lua",
  "server/addcar_sv.lua",
  "server/removecar_sv.lua"
}

files {
  'resources/build/index.html',
  'resources/build/**/*',
  'resources/images/*.png',
}

dependencies {
  'ox_lib',
  'ox_target'
}


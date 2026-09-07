fx_version 'cerulean'
game 'gta5'

author 'arshiahub.ir'
description 'duty'
version '2.1.0'

server_scripts {
  'config.lua',
  'server/main.lua',
  '@oxmysql/lib/MySQL.lua',
}

client_scripts {
  '@oxmysql/lib/MySQL.lua',
  '@ox_lib/init.lua',
  'config.lua',
  'client/main.lua',
}

dependencies {
  'ox_lib',
}

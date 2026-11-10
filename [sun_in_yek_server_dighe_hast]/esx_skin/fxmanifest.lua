-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

client_script '@sunset_utils/include-cl.lua'
server_script '@sunset_utils/include-sv.lua'
fx_version 'cerulean'
game 'gta5'

server_scripts {
  '@essentialmode/locale.lua',
  '@litesql/lib/MySQL.lua',
  'config.lua',
  'locales/en.lua',
  'server/main.lua',
}

client_scripts {
  '@essentialmode/locale.lua',
  'config.lua',
  'locales/en.lua',
  'client/main.lua',
}

ui_page 'ui/index.html'

files {
  'ui/index.html',
  'ui/**',
}







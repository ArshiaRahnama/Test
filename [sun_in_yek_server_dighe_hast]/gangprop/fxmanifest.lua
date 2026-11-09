-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

client_script '@sunset_utils/include-cl.lua'
server_script '@sunset_utils/include-sv.lua'
fx_version 'bodacious'
game 'gta5'
lua54 'yes'
server_scripts {
  '@essentialmode/locale.lua',
  'locales/en.lua',
  '@litesql/lib/MySQL.lua',
  'config.lua',
  'server/main.lua'
}

client_scripts {
  '@essentialmode/locale.lua',
  'locales/en.lua',
  'config.lua',
  'client/main.lua'
}
shared_script '@ox_lib/init.lua'
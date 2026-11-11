fx_version 'bodacious'
games { 'gta5' }

author 'justamir'
description 'ESX Skin'
version '1.0.0'

server_scripts {
  '@essentialmode/locale.lua',
  'config.lua',
  'locales/de.lua',
  'locales/br.lua',
  'locales/en.lua',
  'locales/fr.lua',
  'server/main.lua',
}

client_scripts {
  '@essentialmode/locale.lua',
  'config.lua',
  'locales/de.lua',
  'locales/br.lua',
  'locales/en.lua',
  'locales/fr.lua',
  'client/main.lua',
}

-- Sunset-style NUI skin menu
ui_page 'ui/index.html'

files {
  'ui/index.html',
  'ui/assets/index.js',
  'ui/assets/index.css',
  'ui/fonts/Vazirmatn-Regular.ttf',
  'ui/fonts/Vazirmatn-Medium.woff2',
  'ui/fonts/Vazirmatn-SemiBold.ttf',
  'ui/fonts/Vazirmatn-Bold.ttf',
}

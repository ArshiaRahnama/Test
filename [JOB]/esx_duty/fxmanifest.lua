
fx_version 'cerulean'
game 'gta5'

author 'arshiahub.ir'
description 'duty'
version '2.0.0'

server_scripts {
  --'@essentialmode/locale.lua',
  --'translation/en.lua',
  'config.lua',
  'server/main.lua',
  '@oxmysql/lib/MySQL.lua',
}



client_scripts {
  --'@essentialmode/locale.lua',
  --'translation/en.lua',
  '@oxmysql/lib/MySQL.lua',
  '@ox_lib/init.lua',
  'config.lua',
  'client/main.lua',

  'html/*.png',
  'html/font/*.ttf',
}

ui_page 'html/dutyjob.html'

dependencies {
  'ox_lib',
}

files {
  'html/dutyjob.html',  
  'html/style.css',     
  'html/script.js',
  'html/*.png',
  'html/font/*.ttf',

}

fx_version 'bodacious'
game 'gta5'

description 'chat management stuff'

ui_page 'html/index.html'

dependency 'ox_lib'

client_scripts {
  '@ox_lib/init.lua',
  'cl_chat.lua',
}
server_script 'sv_chat.lua'

files {
  'html/index.html',
  'html/index.css',
  'html/config.default.js',

  'html/App.js',
  'html/Message.js',
  'html/Suggestions.js',
  'html/report_categories.js',
  'html/vendor/vue.2.3.3.min.js',
  'html/vendor/flexboxgrid.6.3.1.min.css',
  'html/vendor/animate.3.5.2.min.css',
  'html/vendor/latofonts.css',
  'html/vendor/fonts/*.woff2',
}

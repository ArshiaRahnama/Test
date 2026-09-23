fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Arshia | arshiahub.ir | Unique RP'
description 'Unique RP - Premium FiveM Loading Screen'
version '2.0.0'

-- NOTE: no ui_page here on purpose. A loadscreen already owns its NUI frame;
-- declaring ui_page as well spawns a second, permanent copy of the page.
loadscreen 'index.html'
loadscreen_cursor 'yes'
loadscreen_manual_shutdown 'yes'

client_script 'client.lua'

files {
    'index.html',
    'assets/css/*.css',
    'assets/js/*.js',
    'assets/background.mp4',
    'assets/logo.png',
    'assets/icon.png',
    'assets/svg/*.svg',
    'assets/fonts/Inter/inter.css',
    'assets/fonts/Inter/*.woff2',
    'assets/fonts/Peyda-Bold.ttf',
}

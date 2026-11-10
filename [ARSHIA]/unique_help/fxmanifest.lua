fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Unique RP'
description 'Unique_Help - منوی راهنمای بازی (/help)'
version '1.0.0'

ui_page 'ui/index.html'

-- این سرور هسته‌ی جدا (es_extended) نداره؛ essentialmode هسته‌ی ESX هست و
-- ESX از طریق event ی 'esx:getSharedObject' گرفته میشه (مثل بقیه‌ی ریسورس‌های Unique_).
dependency 'essentialmode'

client_scripts {
    'settings.lua',
    'config.lua',
    'client/main.lua',
}

server_scripts {
    'settings.lua',
    'server/main.lua',
}

files {
    'ui/**',
}

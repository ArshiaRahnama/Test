

fx_version 'cerulean'
game 'gta5'

author 'Arshia (arshiahub.ir)'
description 'UNIQUE_AC hardened anti-cheat and admin UI'
version '9.6.0'

ui_page 'ui/index.html'

files {
    'ui/*.html',
    'ui/css/*.css',
    'ui/js/*.js',
    'ui/assists/**/*.*'
}

shared_scripts {
    'tables/*.lua',
    'configs/fire-config.lua'
}

client_scripts {
    'src/fire-client.lua',
    'src/fire-menu.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'configs/fire-webhook.lua',
    'src/fire-server.lua'
}

exports {
    'UNIQUE_AC_CHANGE_TEMP_WHITELIST',
    'UNIQUE_AC_CHANGE_TEMP_WHHITELIST',
    'UNIQUE_AC_CHECK_TEMP_WHITELIST',
    'UNIQUE_AC_ACTION'
}

server_exports {
    'UNIQUE_AC_CHANGE_TEMP_WHITELIST',
    'UNIQUE_AC_CHANGE_TEMP_WHHITELIST',
    'UNIQUE_AC_CHECK_TEMP_WHITELIST',
    'UNIQUE_AC_ACTION',
    'UNIQUE_AC_BAN_PLAYER',
    'BanPlayer',
    'UNIQUE_AC_UNBAN_PLAYER',
    'UnbanPlayer'
}

dependencies {
    'oxmysql'
}

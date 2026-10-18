fx_version 'cerulean'
game 'gta5'

author 'Arshia | arshiahub.ir | Unique RP'
description 'Unique_AllRobs - Merged: DarkPhone + PartySystem + Unique_RobSystem + Unique_OilRig, wired into esx_uniquejobs DOJ/dispatch'
version '1.2.0'

dependency 'icon_menu'
dependency 'mythic_progbar'
dependency 'ps-ui'
dependency 'ox_target'
dependency 'esx_uniquejobs'

client_scripts {
    'client.lua',
    'oilrig_client.lua',
    'heist_client.lua',
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',   -- heist stats / tokens (works with oxmysql's mysql-async compat too)
    'server.lua',
    'oilrig_server.lua',
    'heist_server.lua',            -- Gang Heists (plan robberies claimed from Boss Menu > Robbery)
}

shared_scripts {
    'config.lua',
    'oilrig_config.lua',
}

-- Gang Heist menu (NUI)
ui_page 'web/index.html'
files {
    'web/index.html',
    'web/style.css',
    'web/app.js',
    'web/kinds.js',
    'web/fonts/*.woff2',
}

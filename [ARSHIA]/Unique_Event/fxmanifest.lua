fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Unique RP'
description 'Unique_Event - WarZone + GunGame + Capture merged into one project, with a unified /event hub'
version '2.0.0'

-- وابستگی‌های همون سه ریسورس اصلی، بدون تغییر:
dependency 'oxmysql'    -- WarZone + Capture (از طریق MySQL.Async.* compat) + GunGame (exports.oxmysql)
dependency 'ox_lib'     -- Capture
dependency 'ox_target'  -- Capture

shared_scripts {
    '@ox_lib/init.lua',

    -- کانفیگ هر ماژول با اسم جدا (WZConfig/GGConfig/CapConfig/HubConfig)
    -- که تداخلی با هم نداشته باشن حالا که همه تو یه ریسورسن.
    'config/warzone.lua',
    'config/gungame.lua',
    'config/capture.lua',
    'config/gangpvp.lua',
    'hub/config.lua',
}

client_scripts {
    'modules/warzone/client.lua',
    'modules/gungame/client.lua',
    'modules/capture/client.lua',
    'modules/gangpvp/client.lua',
    'hub/client.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua', -- compat شیم MySQL.Async.* که WarZone و Capture باهاش کار میکنن
    'modules/warzone/server.lua',
    'modules/gungame/server.lua',
    'modules/capture/server.lua',
    'modules/gangpvp/server.lua',
    'hub/server.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',

    'html/hub/index.html',

    'html/warzone/ui.html',

    'html/gungame/index.html',
    'html/gungame/style.css',
    'html/gungame/script.js',
    'html/gungame/callingcards/*',
    'html/gungame/sounds/*',

    -- Capture (UI جدید به سبک sun-capture)
    'html/capture/index.html',
    'html/capture/index.js',
    'html/capture/index.css',
    'html/capture/bridge.js',
    'html/capture/*.woff',
    'html/capture/*.woff2',
}

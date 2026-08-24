fx_version 'bodacious'
game 'gta5'

-- ============================================================
-- Unique_Hud
-- status + sun-streetlabel + combat mode + speedometer با هم یکی شدن تو یه
-- ریسورس واحد.
-- ============================================================

-- oxmysql's MySQL.* compatibility lib. لازمه چون global هر ریسورس جدا هست؛
-- بدون این خط، متغیر MySQL تو server/streetlabel.lua همیشه nil می‌موند حتی
-- با اینکه خودِ oxmysql داره اجرا میشه.
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/streetlabel.lua',
    'server/scoreboard.lua',
}

client_scripts {
    'client/main.lua',
    'client/streetlabel.lua',
    'client/combat.lua',
    'client/speedometer.lua',
    'client/scoreboard.lua',
}

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/index.css',
    'ui/style.css',
    'ui/script.js',
    'ui/debounce.min.js',
    'ui/css/index.css',
    'ui/css/style.css',
    'ui/js/script.js',
    'ui/js/debounce.min.js',
    'ui/fonts/*.ttf',
    'ui/fonts/*.woff',
    'ui/fonts/*.woff2',
    'ui/assets/imgs/*.png',
    'ui/img/*.png',
    'ui/streetlabel/index.html',
    'ui/streetlabel/listener.js',
    'ui/streetlabel/style.css',
    'ui/combat/index.html',
    'ui/combat/app.js',
    'ui/combat/style.css',
    'ui/speedometer/index.html',
    'ui/speedometer/script.js',
    'ui/speedometer/style.css',
    'ui/scoreboard/index.html',
    'ui/scoreboard/script.js',
    'ui/scoreboard/style.css',
}

-- speedometer.lua از exports['LegacyFuel']:GetFuel استفاده می‌کنه (همون
-- الگویی که تو Unique_Garage/client/vehiclehud_cl.lua خودتون هم هست).
-- scoreboard.lua هم از exports['Unique_AllRobs']:GetRobStatusSummary استفاده
-- می‌کنه (export جدیدی که به اون ریسورس اضافه شد).
dependencies {
    'oxmysql',
    'LegacyFuel',
    'Unique_AllRobs'
}

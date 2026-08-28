fx_version 'bodacious'
game 'gta5'

-- ============================================================
-- ریسورس "hud1" — کاملاً مستقل و جدا از Unique_Hud
-- ============================================================
-- همیشه نشون میده: هیل، آرمور، آب (thirst)، غذا (hunger)، میکروفون.
-- اختیاری (فقط موقع دویدن/شنا): استامینا، اکسیژن.
-- هیچ export، dependency یا ارتباطی به Unique_Hud نداره - ui_page خودشو داره.

client_scripts {
    'client/main.lua',
}

server_scripts {
    'server/main.lua',
}

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/style.css',
    'ui/main.js',
    'ui/img/logos/health.png',
    'ui/img/logos/armor.png',
    'ui/img/logos/hunger.png',
    'ui/img/logos/thirst.png',
    'ui/img/logos/microphone.png',
    'ui/img/logos/stamina.png',
    'ui/img/logos/oxygen.png',
    'ui/fonts/KumbhSans-Regular.ttf',
}

fx_version "bodacious"
game "gta5"

description "FiveM Base By arshiahub.ir"

dependency 'ox_lib'

server_scripts {
    "@async/async.lua",
    "@mysql-async/lib/MySQL.lua",
    '@oxmysql/lib/MySQL.lua',
    "locale.lua",
    "locales/fr.lua",
    "locales/en.lua",
    "config.lua",
    "config.weapons.lua",
    "server/util.lua",
    "server/common.lua",
    "server/functions.lua",
    "server/paycheck.lua",
    "server/main.lua",
    "server/db.lua",
    "server/classes/player.lua",
    "server/classes/groups.lua",
    "server/player/login.lua",
    "shared/modules/math.lua",
    "shared/functions.lua"
}

client_scripts {
    "@ox_lib/init.lua",
    "locale.lua",
    "locales/fr.lua",
    "locales/en.lua",
    "config.lua",
    "config.weapons.lua",
    "client/common.lua",
    "client/entityiter.lua",
    "client/functions.lua",
    "client/main.lua",
    "client/modules/death.lua",
    "client/modules/scaleform.lua",
    "client/modules/streaming.lua",
    "shared/modules/math.lua",
    "shared/functions.lua"
}

ui_page {
    "html/ui.html"
}

files {
    "html/ui.html",
    "html/css/app.css",
    "html/js/mustache.min.js",
    "html/js/wrapper.js",
    "html/js/app.js",
    "html/fonts/pdown.ttf",
    "html/fonts/bankgothic.ttf",
    "html/img/accounts/bank.png",
    "html/img/accounts/black_money.png",
    "shared/data/vehicle_names.json",
}

exports {
    "getUser",
    "GetPlayerICName",
}

server_exports {
    "addAdminCommand",
    "addCommand",
    "addGroupCommand",
    "addACECommand",
    "canGroupTarget",
    "log",
    "debugMsg",
    "IcName"
}


fx_version 'bodacious'
game 'gta5'

server_scripts {
    "Server/*.lua",
    'Config.lua',
    "@mysql-async/lib/MySQL.lua"
}

server_exports {
    'DutyHandler',
    'DutyHandlerForJail',
    'CK',
    'AddUserMoney',
    'GetUserInfo',
    'AddUserBank',
    'SetJob',
    'SetGang',
    'SetMoney',
    'SetBank',
    'GetReports'
}

client_scripts{
    "@ox_lib/init.lua",
    "Client/*.lua",
    'Config.lua',
    "ReportMenu.lua"
}
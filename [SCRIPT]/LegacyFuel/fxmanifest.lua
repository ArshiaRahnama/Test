fx_version 'cerulean'
game 'gta5'

author 'LegacyFuel'
description 'LegacyFuel - standalone fuel system (replaces esx_Fuel exports used by Unique_Garage)'
version '1.0.0'

lua54 'yes'

server_scripts {
    'config.lua',
    'source/fuel_server.lua'
}

client_scripts {
    'config.lua',
    'source/fuel_client.lua'
}

exports {
    'GetFuel',
    'SetFuel'
}

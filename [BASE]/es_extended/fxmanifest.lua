fx_version 'cerulean'
game 'gta5'

author 'Bridge Resource - generated for essentialmode -> ox_inventory compatibility'
description 'Fake es_extended shim exposing essentialmode as a getSharedObject() ESX object, so ox_inventory (and other es_extended-only resources) can run without migrating the core framework.'
version '1.6.0'

dependency 'essentialmode'
dependency 'oxmysql'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/bridge.lua',
    'server/inventory_migration.lua'
}

server_exports {
    'getSharedObject'
}

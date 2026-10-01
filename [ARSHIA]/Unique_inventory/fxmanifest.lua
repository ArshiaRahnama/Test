fx_version 'adamant'
game 'gta5'

description 'Unique_inventory - merged esx_inventory + esx_inventoryhud + esx_inventoryhud_trunk'
version '1.5.2'

dependency 'essentialmode'
dependency 'oxmysql'
dependency 'ox_target'

ui_page 'nui/index.html'

client_scripts {
    '@essentialmode/locale.lua',
    'locales/en.lua',
    'locales/cs.lua',
    'locales/fr.lua',
    'config_hud.lua',
    'config_trunk.lua',
    -- inventory_main.lua must load first: it's the only file that sets
    -- the shared PlayerData/secondInventory globals the other two read.
    'client/inventory_main.lua',
    'client/hud_keys.lua',
    'client/trunk_client.lua',
    'client/vehicle_target.lua',
}

server_scripts {
    -- must be first: everything below registers callbacks through it
    -- (see the comment at the top of that file for why the old
    -- ESX.RegisterServerCallback pattern silently failed on this server)
    'server/callback_bridge.lua',
    -- shared item/weapon label cache, used by every file below instead of
    -- calling ESX.GetItemLabel/GetWeaponLabel (linear scan) in a loop
    'server/label_cache.lua',

    '@essentialmode/locale.lua',
    '@oxmysql/lib/MySQL.lua',
    'locales/en.lua',
    'locales/cs.lua',
    'locales/fr.lua',
    'config_hud.lua',
    'config_trunk.lua',
    'config_joblock.lua',

    'server/spam_guard.lua',
    -- IsGangItemLocked/IsJobItemLocked - must load before inventory_main.lua,
    -- which calls them from getGangINV/getJobINV1/getJobINV2 and the take-item events
    'server/job_gang_lock.lua',
    'server/inventory_main.lua',
    'server/hud_data.lua',
    'server/classes/c_trunk.lua',
    'server/trunk_helpers.lua',
    'server/trunk_main.lua',
}

files {
    'nui/*.*',
    'nui/app/*',
    'html/img/items/*.png',
}

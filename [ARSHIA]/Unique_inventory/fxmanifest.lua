-- Unique_inventory  |  Unique RP adaptation (essentialmode)
-- Replaces Unique_inventory. Stage 1: core inventory + weapon slots + drop/give.
fx_version 'bodacious'
game 'gta5'
lua54 'yes'
description 'Unique_inventory - NUI inventory for Unique RP'

dependency 'essentialmode'
dependency 'oxmysql'
dependency 'ox_lib'

-- resources taken from the original server call exports['sun-inventory-hud'] / ['sunset_inventory']; these two lines make them reach THIS resource
provide 'sun-inventory-hud'
provide 'sunset_inventory'

ui_page 'ui/index.html'

shared_scripts {
    'shared/weapon-slots.lua',
}

client_scripts {
    '@ox_lib/init.lua',
    'client/00_compat.lua',   -- must be first: builds ESX + missing helpers
    'client/config.lua',
    'client/setting.lua',
    'client/weapon-slots.lua',
    'client/shortcuts.lua',
    'client/clothe.lua',
    'client/ui_bridge.lua',
    'client/main.lua',
    'client/weapon-wheel.lua', -- weapon wheel = weapons in slots (replaces core:client:giveWeapon)
    'client/extras.lua',
    -- stage 2 modules
    'modules/trunk/common/config.lua',
    'modules/trunk/client/main.lua',
    -- Stage 2 (need their server side first):
    -- 'modules/**/common/*.lua', 'modules/**/client/*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/callback_bridge.lua', -- must be before main.lua
    'server/main.lua',
    'server/second.lua', -- stash store + trunk
    'server/persist.lua', -- autosave + save on shutdown so items/guns survive restarts
    'server/gang_store.lua', -- exports['Unique_inventory']:Add/RemoveGangArmoryItem|Weapon, GetGangArmory* (used by Unique_ALLGangs / Unique_AllRobs)
}

files { 'ui/**' }

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'For5M (merged: FMGangs + FMGangBoss) - patched for IRV-inventory + lag fix'
description 'Unique_ALLGangs - merged FMGangs + FMGangBoss, IRV-inventory, fixed openpanel lag'
version '1.0.0'

-- NOTE: IRV-inventory (and its own dependency, oxmysql) must be started
-- BEFORE this resource in your server.cfg:
--   ensure oxmysql
--   ensure essentialmode
--   ensure IRV-inventory
--   ensure Unique_ALLGangs
--
-- ox_target is OPTIONAL: ped interactions (e.g. the boss NPC) use it
-- automatically if it's running (checked at runtime via
-- GetResourceState), and fall back to the old press-E prompt if it
-- isn't installed. Marker/object-type interactions (Locker, Armory,
-- etc.) always stay on press-E regardless, unchanged.
--
-- Gang vehicle spawning (Config.GangVehicles, OpenGangVehicleSpawner
-- in client/load.lua) requires esx_vehicleshop (for GeneratePlate and
-- the shared owned_vehicles table) and Unique_Garage's CarLock system
-- (for real vehicle keys) - both must be running for spawned gang
-- vehicles to be properly owned and keyed. Do NOT install or start
-- FMGangsGarage - it contains a confirmed backdoor (see README).

shared_script 'Config.lua'

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'shared/config.lua',
    'server/main.lua',      -- avatar cache / admin panel / logging
    'server/level.lua',
    'server/Gangs.lua',     -- core gang data, armory -> IRV-inventory stashs table
    'server/boss.lua',      -- boss panel actions (was FMGangBoss/server.lua)
}

client_scripts {
    'client/lib.lua',
    'client/gps.lua',
    'client/level.lua',
    'client/load.lua',
    'client/main.lua',      -- member panel (openpanel) + boss panel bridge
    'client/boss.lua',      -- boss menu actions (was FMGangBoss/client.lua) - NUI panel, kept but no longer the default trigger (see client/boss_esx_menu.lua)
    'client/boss_esx_menu.lua', -- boss actions via ESX default menu (top-left), styled like the old Unique_Gangs system - this is what the boss NPC opens now
}

ui_page 'web/ui.html'

files {
    -- member panel (FMGangs) - now also contains the boss panel's
    -- markup directly (merged into one page, see notes in web/ui.html)
    'web/ui.html',
    'web/css/style.css',
    'web/css/Audiowide.ttf',
    'web/js/script.js',
    'web/img/*.png',
    'web/img/marker/*.png',
    'web/img/object/*.png',
    'web/img/ped/*.png',
    'web/img/blip/*.png',
    'web/img/flag/*.png',

    -- boss panel (FMGangBoss) assets - html/ui.html itself is no
    -- longer loaded as its own page (its markup now lives directly in
    -- web/ui.html); its stylesheet and script are still linked from
    -- there and kept as separate files.
    'html/main.css',
    'html/js.js',
    'html/img/*.png',
    'html/img/*.jpg',
    'html/img/*.gif',
}

escrow_ignore {
    'shared/*.lua',
    'Config.lua',
}

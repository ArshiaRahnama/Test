fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'For5M (merged: FMGangs + FMGangBoss) - patched for inventory + lag fix'
description 'Unique_ALLGangs - merged FMGangs + FMGangBoss, inventory, fixed openpanel lag'
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
shared_script '@ox_lib/init.lua' -- for the "Set Log Webhook" per-category context menu (client/boss_esx_menu.lua) - requires ox_lib to be running

dependencies {
    'ox_lib',
}

server_scripts {
    'crafting/server/main.lua', -- Unique_Crafting
    -- ===== uniquecafejobs (merged) =====
    '@oxmysql/lib/MySQL.lua',
    'uniquecafejobs/server/main.lua',
    'uniquecafejobs/server/items.lua',
    'uniquecafejobs/server/newbiz_items.lua',
    'uniquecafejobs/server/crafting_sv.lua',
    'uniquecafejobs/server/shop_server.lua',
    'uniquecafejobs/server/market_config.lua',
    'uniquecafejobs/server/market_server.lua',
    'uniquecafejobs/server/corp_server.lua',
    'uniquecafejobs/server/takeover_sv.lua',
    'uniquecafejobs/server/ipo_sv.lua',
    'uniquecafejobs/server/turfco_server.lua',
    'uniquecafejobs/server/vms_bridge.lua',
    'uniquecafejobs/auctionhouse/server.lua',
    'uniquecafejobs/vms_barber/config/config.server.lua',
    'uniquecafejobs/vms_barber/server/*.lua',
    'uniquecafejobs/vms_tattooshop/server/*.lua',
    '@oxmysql/lib/MySQL.lua',
    'shared/config.lua',
    'server/main.lua',      -- avatar cache / admin panel / logging
    'server/level.lua',
    'server/Gangs.lua',     -- core gang data, armory -> IRV-inventory stashs table
    'server/boss.lua',      -- boss panel actions (was FMGangBoss/server.lua)
    'server/territory.lua', -- Territory Control add-on (see Config.Territory) - loads after Gangs.lua/boss.lua since it calls their global functions (Gangs, AddGangBlackMoney, SendLog, GetCategoryWebhook)
    'server/zonewar.lua',   -- Gang War (contained, contract-based war over one territory zone) - loads after territory.lua (uses Territories, CaptureZone, ZW_* wrappers)
}

client_scripts {
    'crafting/client/main.lua', -- Unique_Crafting
    -- ===== uniquecafejobs (merged) =====
    'client/nui_gang.lua',
    'uniquecafejobs/client/nui_router.lua',
    'uniquecafejobs/client/main.lua',
    'uniquecafejobs/client/items.lua',
    'uniquecafejobs/client/newbiz_items.lua',
    'uniquecafejobs/client/functions.lua',
    'uniquecafejobs/client/shop_client.lua',
    'uniquecafejobs/client/crafting_cl.lua',
    'uniquecafejobs/client/market_client.lua',
    'uniquecafejobs/client/corp_client.lua',
    'uniquecafejobs/client/takeover_cl.lua',
    'uniquecafejobs/client/ipo_cl.lua',
    'uniquecafejobs/client/turfco_client.lua',
    'uniquecafejobs/auctionhouse/client.lua',
    'uniquecafejobs/vms_barber/config/config.client.lua',
    'uniquecafejobs/vms_barber/client/*.lua',
    'uniquecafejobs/vms_tattooshop/client/*.lua',
    'client/lib.lua',
    'client/gps.lua',
    'client/level.lua',
    'client/load.lua',
    'client/main.lua',      -- member panel (openpanel) + boss panel bridge
    'client/boss.lua',      -- boss menu actions (was FMGangBoss/client.lua) - NUI panel, kept but no longer the default trigger (see client/boss_esx_menu.lua)
    'client/boss_esx_menu.lua', -- boss actions via ESX default menu (top-left), styled like the old Unique_Gangs system - this is what the boss NPC opens now
    'client/gangwar.lua',       -- shootout detection -> live FBI/CIA dispatch (see Config.GangWar, README #45)
    'client/territory.lua',     -- Territory Control add-on (see Config.Territory) - loads after boss.lua so the global `PlayerData` it reads is already set up
    'client/territory_zombies.lua',
    'client/zonearmory.lua', -- ambient zombies inside territory zones (see Config.Territory.ZombieTiers) - loads after territory.lua since it listens for the same Territory:BossZoneState event
    'client/zonewar.lua',       -- Gang War menu (/zonewar), HUD and war-zone blips
}

ui_page 'router.html'

files {
    'crafting/html/**/*',
    'router.html',
    'translation.js',
    'uniquecafejobs/html/**/*',
    -- member panel (FMGangs) - now also contains the boss panel's
    -- markup directly (merged into one page, see notes in web/ui.html)
    'web/ui.html',
    'web/css/style.css',
    'web/css/theme.css',
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
}

escrow_ignore {
    'shared/*.lua',
    'Config.lua',
}

-- ===== DRUGS (merged from esx_drugs; see drugs/) =====
-- drugs config lives in the global DrugCfg (not Config) so the two configs never clash.
shared_scripts {
    'crafting/config.lua', -- Unique_Crafting (CraftConfig)
    -- ===== uniquecafejobs (merged) =====
    '@essentialmode/locale.lua',
    'uniquecafejobs/locales/en.lua',
    'uniquecafejobs/shared/cafes.lua',
    'uniquecafejobs/shared/menu.lua',
    'uniquecafejobs/shared/configcrafting.lua',
    'uniquecafejobs/shared/market_products.lua',
    'uniquecafejobs/shared/newbiz_items.lua',
    'uniquecafejobs/shared/customnames.lua',
    'uniquecafejobs/shared/customblips.lua',
    'uniquecafejobs/shared/corp.lua',
    'uniquecafejobs/shared/takeover.lua',
    'uniquecafejobs/shared/ipo.lua',
    'uniquecafejobs/shared/turfco.lua',
    'uniquecafejobs/vms_barber/config/config.lua',
    'uniquecafejobs/vms_barber/config/config.translation.lua',
    'uniquecafejobs/vms_barber/config/config.management.lua',
    'uniquecafejobs/vms_tattooshop/config.lua',
    'uniquecafejobs/shared/vms_businesses.lua',
    'uniquecafejobs/auctionhouse/config.lua',
    'drugs/config.lua',
    'config_gunshop.lua',
}
server_scripts {
    '@essentialmode/locale.lua',
    'drugs/locales/en.lua',
    'drugs/locales/fr.lua',
    'drugs/locales/sv.lua',
    'server/gunshop.lua',
    'drugs/server/skills.lua',
    'drugs/server/main.lua',
    'drugs/server/convoy.lua',
}
client_scripts {
    '@essentialmode/locale.lua',
    'drugs/locales/en.lua',
    'drugs/locales/fr.lua',
    'drugs/locales/sv.lua',
    'drugs/client/skills.lua',
    'drugs/client/main.lua',
    'drugs/client/weed.lua',
    'drugs/client/meth.lua',
    'drugs/client/crack.lua',
    'drugs/client/heroine.lua',
    'drugs/client/mushroom.lua',
    'drugs/client/convoy.lua',
}

-- uniquecafejobs: tattoo shop DLC data
data_file 'PED_OVERLAY_FILE' 'uniquecafejobs/vms_tattooshop/meta/vms_overlays.xml'
data_file 'TATTOO_SHOP_DLC_FILE' 'uniquecafejobs/vms_tattooshop/meta/shop_tattoo.meta'

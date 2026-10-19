fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Arshia | arshiahub.ir'
description 'Unique Cafe Jobs - multi-cafe crafting job (UwU Café / Obsidian Brew / Voltage Coffee Co.) + the uwumarket player marketplace, bundled into one resource'
version '1.0.0'

-- shared/cafes.lua is the single source of truth for the 3 cafes (job name,
-- society, station coordinates). Add a 4th cafe by copying a block in there -
-- nothing else needs to change, every file below already loops over `Cafes`.

shared_scripts {
	'@essentialmode/locale.lua',
	'@ox_lib/init.lua',
	'locales/en.lua',
	'shared/cafes.lua',
	'shared/menu.lua',
	'shared/configcrafting.lua',
	'shared/market_products.lua',
	'shared/newbiz_items.lua',
	'shared/customnames.lua',
	'shared/customblips.lua',
	'shared/corp.lua',
	'shared/takeover.lua',
	'shared/ipo.lua',
	'shared/turfco.lua',
	-- vms barber + tattoo (merged in, see shared/vms_businesses.lua)
	'vms_barber/config/config.lua',
	'vms_barber/config/config.translation.lua',
	'vms_barber/config/config.management.lua',
	'vms_tattooshop/config.lua',
	'shared/vms_businesses.lua',
	'auctionhouse/config.lua',
}

client_scripts {
	'client/nui_router.lua',
	'client/main.lua',
	'client/items.lua',
	'client/newbiz_items.lua',
	'client/functions.lua',
	'client/shop_client.lua',
	'client/crafting_cl.lua',
	'client/market_client.lua',
	'client/corp_client.lua',
	'client/takeover_cl.lua',
	'client/ipo_cl.lua',
	'client/turfco_client.lua',
	'auctionhouse/client.lua',
	'vms_barber/config/config.client.lua',
	'vms_barber/client/*.lua',
	'vms_tattooshop/client/*.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua', -- FIX: this base server runs oxmysql (see server.cfg), not mysql-async.
	                          -- oxmysql ships a drop-in mysql-async-compatible MySQL.lua, so every
	                          -- MySQL.Sync/MySQL.Async call elsewhere in this resource still works unchanged.
	'server/main.lua',
	'server/items.lua',
	'server/newbiz_items.lua',
	'server/crafting_sv.lua',
	'server/shop_server.lua',
	'server/market_config.lua',
	'server/market_server.lua',
	'server/corp_server.lua',
	'server/takeover_sv.lua',
	'server/ipo_sv.lua',
	'server/turfco_server.lua',
	'server/vms_bridge.lua',
	'auctionhouse/server.lua',
	'vms_barber/config/config.server.lua',
	'vms_barber/server/*.lua',
	'vms_tattooshop/server/*.lua',
}

ui_page 'html/index.html'

files {
	'html/index.html',

	'html/cafe/form.html',
	'html/cafe/css.css',
	'html/cafe/script.js',
	'html/cafe/jquery-3.4.1.min.js',

	'html/shop/index.html',
	'html/shop/style.css',
	'html/shop/script.js',

	'html/market/index.html',
	'html/market/css/*.css',
	'html/market/js/*.js',
	'html/market/img/*.png',
	'html/market/favicon.ico',

	'html/vms_barber/**/*',
	'html/vms_tattooshop/**/*',
	'translation.js',
	'html/auctionhouse/**/*',
	'html/config/*.json',
}

dependencies {
	'essentialmode',
	'esx_society',
	'oxmysql',
	'ox_lib',
	'ox_target',
	
}

-- NOTE: the gang-account resource (Unique_Gangs, event 'gangaccount:getGangAccount')
-- is used by Turf Wars' map-rental payment, but is intentionally NOT a hard
-- dependency above - a missing/late-loading gang resource would otherwise
-- block this ENTIRE resource (all 17 businesses) from starting. Turf Wars
-- checks for it at runtime instead (GetResourceState('Unique_Gangs')) and
-- just shows a clear error if it's not running.

-- vms_tattooshop DLC data (paths inside this resource)
data_file 'PED_OVERLAY_FILE' 'vms_tattooshop/meta/vms_overlays.xml'
data_file 'TATTOO_SHOP_DLC_FILE' 'vms_tattooshop/meta/shop_tattoo.meta'

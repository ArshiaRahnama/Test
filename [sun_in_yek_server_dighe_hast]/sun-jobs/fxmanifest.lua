-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

client_script '@sunset_utils/include-cl.lua'
fx_version 'cerulean'
game 'gta5'
use_experimental_fxv2_oal 'yes'
lua54 'yes'

shared_scripts {
	-- Main
	'common/shared.lua',
	-- Locales
	'locales/*.lua',
	-- Taxi
	-- 'modules/taxi/config.lua',
	-- Weazel
	-- 'modules/weazel/config.lua',
	-- Mechanic
	-- 'modules/mechanic/config.lua',
	-- Sheriff
	-- 'modules/sheriff/config.lua',
	-- Fbi
	-- 'modules/fbi/config.lua',
}

client_scripts {
	'@ox_lib/init.lua',
	-- Main
	'common/cl_shared.lua',
	'common/cl_main.lua',
	'common/raycast.lua',
	-- Taxi
	'modules/taxi/client/*.lua',
	'modules/taxi/config.lua',
	-- Medic
	'modules/medic/client/*.lua',
	'modules/medic/config.lua',
	-- Weazel
	'modules/weazel/client/*.lua',
	'modules/weazel/config.lua',
	-- Mechanic
	'modules/mechanic/client/*.lua',
	'modules/mechanic/config.lua',
	----- [[ LEGALS ]]
	'modules/legals/config.lua',
	-- Police
	'modules/legals/police/client/*.lua',
	'modules/legals/police/config.lua',
	-- FBI
	'modules/legals/fbi/client/*.lua',
	'modules/legals/fbi/config.lua',
	-- Sheriff
	'modules/legals/sheriff/client/*.lua',
	'modules/legals/sheriff/config.lua',
	-- mt
	'modules/legals/mt/client/*.lua',
	'modules/legals/mt/config.lua',
	-- detective
	'modules/legals/detective/client/*.lua',
	'modules/legals/detective/config.lua',
	-- Justice
	'modules/legals/justice/client/*.lua',
	'modules/legals/justice/config.lua',
	-- Vehicle insurance
	'modules/vehicle-insurance/client/*.lua',
	'modules/vehicle-insurance/config.lua',
}

server_scripts {
	'@litesql/lib/MySQL.lua',
	'@sunset_utils/include-sv.lua',
	-- Main
	'common/sv_shared.lua',
	'common/sv_main.lua',
	-- Taxi
	'modules/taxi/config.lua',
	'modules/taxi/server/*.lua',
	-- Medic
	'modules/medic/config.lua',
	'modules/medic/server/*.lua',
	-- Weazel
	'modules/weazel/config.lua',
	'modules/weazel/server/*.lua',
	-- Mechanic
	'modules/mechanic/config.lua',
	'modules/mechanic/server/*.lua',
	----- [[ LEGALS ]]
	'modules/legals/config.lua',
	-- Police
	'modules/legals/police/config.lua',
	'modules/legals/police/server/*.lua',
	-- FBI
	'modules/legals/fbi/config.lua',
	'modules/legals/fbi/server/*.lua',
	-- Sheriff
	'modules/legals/sheriff/config.lua',
	'modules/legals/sheriff/server/*.lua',
	-- Military
	'modules/legals/mt/config.lua',
	'modules/legals/mt/server/*.lua',
	-- detective
	'modules/legals/detective/config.lua',
	'modules/legals/detective/server/*.lua',
	-- Justice
	'modules/legals/justice/config.lua',
	'modules/legals/justice/server/*.lua',
	-- Vehicle insurance
	'modules/vehicle-insurance/server/*.lua',
	'modules/vehicle-insurance/config.lua',
}

ui_page 'ui/index.html'
files {
	'ui/**.**',
}

escrow_ignore {
	'modules/**/config.lua',
	'common/sv_shared.lua',
	'common/sv_main.lua',
	'modules/**/server/*.lua',
	'locales/*.lua',
}
fx_version 'adamant'
games { 'gta5' }

name 'Unique_housing'
description 'Merged housing suite: allhousing + furni + lockpicking + meta_libs + mythic_interiors + input (originally 6 separate resources, combined into a single resource)'
version '1.0.0'

dependency 'oxmysql'
dependency 'essentialmode'

ui_page 'nui/furniture.html'

-------------------------------------------------------------------
-- CLIENT SCRIPTS (load order matters: shared libs first, then
-- each module's own config before its logic files)
-------------------------------------------------------------------
client_scripts {
  -- NativeUI is NOT needed on this server: essentialmode + esx_menu_default
  -- are installed, and HousingConfig.UsingESXMenu / FurniConfig equivalent
  -- already default to true, so ESX's own menu system is used instead.

  -- meta_libs (shared helper library used across modules)
  'client/meta_libs/classes/String.lua',
  'client/meta_libs/classes/Blip.lua',
  'client/meta_libs/classes/Marker.lua',
  'client/meta_libs/classes/Scenes.lua',
  'client/meta_libs/classes/Vector.lua',
  'client/meta_libs/classes/Vehicle.lua',
  'client/meta_libs/classes/Scaleforms.lua',
  'client/meta_libs/scripts/BlipHandler.lua',
  'client/meta_libs/scripts/MarkerHandler.lua',
  'client/meta_libs/scripts/Networking.lua',
  'client/meta_libs/scripts/Streaming.lua',
  'client/meta_libs/scripts/Teleporter.lua',
  'client/meta_libs/scripts/Notifications.lua',
  'client/meta_libs/scripts/Controls.lua',

  -- housing (formerly "allhousing")
  'client/housing/config.lua',
  'client/housing/houses.lua',
  'client/housing/labels.lua',
  'client/housing/framework_functions.lua',
  'client/housing/menus.lua',
  'client/housing/menus_native.lua',
  'client/housing/menus_esx.lua',
  'client/housing/functions.lua',
  'client/housing/main.lua',
  'client/housing/commands.lua',

  -- furni (furniture placement)
  'client/furni/config.lua',
  'client/furni/utils.lua',
  'client/furni/disablecontrols.lua',
  'client/furni/main.lua',

  -- lockpicking (this is the actual house-door lockpick minigame used by
  -- default via HousingConfig.UsingLockpickV1 = true, triggered through the
  -- internal "lockpicking:StartMinigame" event; fully self-contained, no
  -- external "lockpick" resource is required)
  'client/lockpicking/config.lua',
  'client/lockpicking/utils.lua',
  'client/lockpicking/client.lua',

  -- interiors (formerly "mythic_interiors")
  'client/interiors/main.lua',
  'client/interiors/shells.lua',
  'client/interiors/furnished.lua',

  -- input (on-screen text-input dialog; its NUI lives inside nui/input.html,
  -- embedded as an iframe inside nui/furniture.html)
  'client/input/client.lua',
}

-------------------------------------------------------------------
-- SERVER SCRIPTS
-------------------------------------------------------------------
server_scripts {
  -- MYSQL: this server runs oxmysql, not mysql-async. This shim (shipped
  -- inside the oxmysql resource itself) re-implements the classic
  -- MySQL.Async.*/MySQL.Sync.* API on top of oxmysql, so every
  -- MySQL.Async.execute/fetchAll call already in this codebase keeps
  -- working unchanged.
  '@oxmysql/lib/MySQL.lua',

  -- meta_libs
  'server/meta_libs/classes/String.lua',
  'server/meta_libs/classes/Table.lua',
  'server/meta_libs/classes/Json.lua',
  'server/meta_libs/scripts/Utilities.lua',
  'server/meta_libs/scripts/_.lua',

  -- housing
  'server/housing/config.lua',
  'server/housing/houses.lua',
  'server/housing/labels.lua',
  'server/housing/framework_functions.lua',
  'server/housing/functions.lua',
  'server/housing/main.lua',

  -- furni
  'server/furni/config.lua',
  'server/furni/credentials.lua',
  'server/furni/main.lua',

  -- lockpicking
  'server/lockpicking/config.lua',
  'server/lockpicking/utils.lua',
  'server/lockpicking/server.lua',
}

-------------------------------------------------------------------
-- NUI + STREAMED ASSETS
-------------------------------------------------------------------
files {
  'nui/furniture.html',
  'nui/input.html',
  'textures/LockPick1.PNG',
  'textures/LockPick2.PNG',
  'textures/LockPick3.PNG',
  'nui/aim.png',
  'nui/back.png',
  'nui/cancel.png',
  'nui/dec.png',
  'nui/down.png',
  'nui/edit.png',
  'nui/exit.png',
  'nui/forward.png',
  'nui/icon1.png',
  'nui/inc.png',
  'nui/left.png',
  'nui/remove.png',
  'nui/right.png',
  'nui/slide.png',
  'nui/test.png',
  'nui/up.png',
  'nui/pricedown.black.ttf',

  'nui/affirm-detuned.wav',
  'nui/affirm-melodic-2.wav',
  'nui/affirm-melodic-3.wav',
  'nui/alert-echo.wav',
  'nui/camera_click.wav',
  'nui/click-analogue-1.wav',
  'nui/click-round-pop-1.wav',
  'nui/click-round-pop-2.wav',
  'nui/click-round-pop-3.wav',

  'stream/playerhouse_hotel/playerhouse_hotel.ytyp',
  'stream/playerhouse_tier1/playerhouse_tier1.ytyp',
  'stream/playerhouse_tier3/playerhouse_tier3.ytyp',
}

data_file 'DLC_ITYP_REQUEST' 'stream/v_int_20.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/playerhouse_hotel/playerhouse_hotel.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/playerhouse_tier1/playerhouse_tier1.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/playerhouse_tier3/playerhouse_tier3.ytyp'

-------------------------------------------------------------------
-- EXPORTS (static exports from the former "mythic_interiors")
-------------------------------------------------------------------
exports {
  'DespawnInterior',
  'CreateMotel',
  'CreateTier1House',
  'CreateTier2House',
  'CreateTier3House',
  'CreateTier1HouseFurnished',
}

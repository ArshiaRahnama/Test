HudConfig = {}
HudConfig.Locale = "en"
HudConfig.IncludeCash = true -- Include cash in inventory?
HudConfig.IncludeWeapons = true -- Include weapons in inventory?
HudConfig.IncludeAccounts = true -- Include accounts (bank, black money, ...)?
HudConfig.ExcludeAccountsList = {} -- List of accounts names to exclude from inventory
HudConfig.OpenControl = 289 -- Key for opening inventory. Edit html/js/config.js to change key for closing it.

HudConfig.EnableVehicleKey = false
HudConfig.EnableHouseKey = false

-- FIX (Unique_inventory merge): used by the real weight calculation in
-- server/hud_data.lua, replacing what used to be a hardcoded "4000" on
-- the client with no config option at all.
HudConfig.MaxInventoryWeight = 90

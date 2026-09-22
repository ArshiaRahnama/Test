Config = {}
Config.Locale = "en"

Config.Accounts = {"bank", "black_money"}
Config.AccountLabels = {bank = _U("bank"), black_money = _U("black_money")}
Config.TargetDistance = 4

Config.EnableSocietyPayouts = true
Config.ShowDotAbovePlayer = false
Config.DisableWantedLevel = true
Config.EnableHud = false

Config.PaycheckInterval = 15 * 60000
Config.MaxPlayers = GetConvarInt("sv_maxclients", 64)

Config.EnableDebug = false

-- ================================================================= --
-- INVENTORY WEIGHT SYSTEM
-- ================================================================= --
-- UNIT FIX: this used to be 24000 while every real weight value in the
-- pack (esx_inventory's own Config.WeaponWeight, Config.ClothesWeight,
-- Config.WeightVehicle) is expressed in small kilogram-scale numbers
-- (0.1 - 500). Comparing a kg-scale "used weight" against a
-- grams-scale 24000 cap meant the cap basically never bound (or bound
-- 1000x too loose). Everything below is now in KILOGRAMS, consistently.
Config.DefaultMaxWeight = 24 -- kg, base carry capacity before any level bonus

-- FIX: ESX.getItemWeight/ESX.getWeaponWeight (server/common.lua) used to
-- unconditionally return 0 - no item ever had weight, so getUsedWeight()
-- was always 0 and canCarryItem() always true, AND anything reading
-- item.weight directly (e.g. esx_inventory's trunk deposit, which does
-- `InfoItem.weight * count`) crashed on a nil arithmetic error, because
-- the inventory-item stub never carried a weight field at all. Real
-- per-item weight now comes from the `items` table's new `weight`
-- column (see database.sql); this is just the fallback for any item
-- that doesn't have one set yet.
Config.DefaultItemWeight = 0.5 -- kg, used when an item has no weight set in the DB

-- Weapons aren't in the `items` table, so they get their own weight
-- config, same idea/shape as esx_inventory's own Config.WeaponWeight.
Config.WeaponDefaultWeight = 2
Config.WeaponWeight = {
    ["WEAPON_NIGHTSTICK"] = 1,
    ["WEAPON_STUNGUN"] = 1,
    ["WEAPON_FLASHLIGHT"] = 1,
    ["WEAPON_ASSAULTRIFLE"] = 5,
    ["WEAPON_SMG"] = 3,
}

-- Player-level integration (Unique_LevelQuest): base capacity stays
-- Config.DefaultMaxWeight, +WeightPerLevel kg for every level above 1.
-- Applied once at login (server/player/login.lua, from the player's
-- current `rank`) and re-applied live whenever Unique_LevelQuest fires
-- 'essentialmode:levelChanged' (server/main.lua) after a level-up.
Config.WeightPerLevel = 5 -- kg added per level above level 1

-- Backpack items (esx_inventory's 'backpack' usable item, or any other
-- item name added here): extra kg while equipped, on top of level
-- bonus. A player can only wear one at a time - see esx_inventory's
-- server/custom/apps/backpack.lua for the equip/unequip flow, and
-- server/main.lua's RecalculateMaxWeight (below-ish) for how base +
-- level + backpack all combine.
Config.BackpackWeight = {
    ['backpack'] = 10,
    ['backpack_medium'] = 20,
    ['backpack_large'] = 35,
}

-- How many copies of the SAME weapon type one player may carry (each copy keeps
-- its own serial number). 1 = the old "one weapon per type" rule.
-- GTA itself only knows "ped has WEAPON_PISTOL: yes/no", so the copies share one
-- ammo pool on the client; the server tracks every copy + serial separately.
Config.MaxSameWeapon = 3

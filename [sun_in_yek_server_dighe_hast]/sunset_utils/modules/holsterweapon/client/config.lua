-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

configHolster = {}
configHolster.Cooldowns = {
	["police"] = {
		light = 700,
		heavy = 1200
	},
	["civilian"] = {
		light = 1000,
		heavy = 1350
	}
}
configHolster.World = {
    [0] = true,
    [101] = true,
    [102] = true,
}
-- Add/remove weapon hashes here to be added for holster checks.
configHolster.Weapons = {
    [`WEAPON_APPISTOL`] = "light",
    [`WEAPON_CERAMICPISTOL`] = "light",
    [`WEAPON_VINTAGEPISTOL`] = "light",
    [`WEAPON_MARKSMANPISTOL`] = "light",
    [`WEAPON_MACHINEPISTOL`] = "light",
    [`WEAPON_PISTOL_MK2`] = "light",
    [`WEAPON_SNSPISTOL_MK2`] = "light",
    [`WEAPON_FLAREGUN`] = "light",
    [`WEAPON_PISTOL`] = "light",
    [`WEAPON_COMBATPISTOL`] = "light",
    [`WEAPON_PISTOL50`] = "light",
    [`WEAPON_SNSPISTOL`] = "light",
    [`WEAPON_HEAVYPISTOL`] = "light",
    [`WEAPON_STUNGUN`] = "light",
    [`WEAPON_MICROSMG`] = "heavy",
    [`WEAPON_REVOLVER`] = "light",
    [`WEAPON_MICROSMG`] = "light",
    [`WEAPON_NAVYREVOLVER`] = "light",
    [`WEAPON_PISTOLXM3`] = "light",
    [`WEAPON_REVOLVER_MK2`] = "light",
    [`WEAPON_ASSAULTSMG`] = "heavy",
    [`WEAPON_COMBATPDW`] = "heavy",
    [`WEAPON_SMG_MK2`] = "heavy",
    [`WEAPON_MINISMG`] = "heavy",
    [`WEAPON_TECPISTOL`] = "heavy",
    [`WEAPON_PUMPSHOTGUN`] = "heavy",
    [`WEAPON_PUMPSHOTGUN_MK2`] = "heavy",
    [`WEAPON_SAWNOFFSHOTGUN`] = "heavy",
    [`WEAPON_ASSAULTSHOTGUN`] = "heavy",
    [`WEAPON_BULLPUPSHOTGUN`] = "heavy",
    [`WEAPON_AUTOSHOTGUN`] = "heavy",
    [`WEAPON_DBSHOTGUN`] = "heavy",
    [`WEAPON_HEAVYSHOTGUN`] = "heavy",
    [`WEAPON_ASSAULTRIFLE`] = "heavy",
    [`WEAPON_ASSAULTRIFLE_MK2`] = "heavy",
    [`WEAPON_ADVANCEDRIFLE`] = "heavy",
    [`WEAPON_SMG`] = "heavy",
    [`WEAPON_CARBINERIFLE`] = "heavy",
    [`WEAPON_CARBINERIFLE_MK2`] = "heavy",
    [`WEAPON_SPECIALCARBINE`] = "heavy",
    [`WEAPON_SPECIALCARBINE_MK2`] = "heavy",
    [`WEAPON_BULLPUPRIFLE`] = "heavy",
    [`WEAPON_BULLPUPRIFLE_MK2`] = "heavy",
    [`WEAPON_GUSENBERG`] = "heavy",
    [`WEAPON_COMPACTRIFLE`] = "heavy",
    [`WEAPON_MG`] = "heavy",
    [`WEAPON_COMBATMG`] = "heavy",
    [`WEAPON_COMBATMG_MK2`] = "heavy",
}
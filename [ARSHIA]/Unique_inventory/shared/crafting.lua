-- ============================================================================
-- Unique_inventory | shared/crafting.lua
-- Weapon crafting recipes. The numbers are the PERMANENT recipes of the original server
-- (sunset_crafting); shorter weapon lifetimes cost less (see WeaponLife.tiers).
--   time  = seconds at the workbench
--   forge / wolfram / gun_metal = materials for a PERMANENT weapon
-- A recipe costs  ceil(material * tier.cost)  (at least 1 of each material that is used).
-- ============================================================================
Crafting = {
    -- This is Unique_inventory's own small workbench menu (/craft). Your server already has a crafting
    -- system (Unique_Crafting in Unique_ALLGangs), which is the one to use, so this one is OFF.
    -- Turn it on only if you want a second, simple crafting menu.
    enabled = false,

    -- true: everybody can craft anywhere with /craft (handy for testing). Set it to false in production
    -- and list the workbenches below (or call exports['Unique_inventory']:OpenCrafting() from your own target).
    anywhere = true,
    command  = 'craft',
    benchRadius = 2.5,
    -- { label = 'Workbench', coords = vector3(x, y, z) },
    benches = {},

    -- materials: they are created in the items table automatically
    materials = {
        forge     = { label = 'Forge',     weight = 0.1 },
        wolfram   = { label = 'Wolfram',   weight = 0.1 },
        gun_metal = { label = 'Gun Metal', weight = 0.1 },
    },
    materialOrder = { 'forge', 'wolfram', 'gun_metal' },

    groups = {
        { id = 'melee',   label = 'سلاح سرد' },
        { id = 'pistol',  label = 'تپانچه' },
        { id = 'smg',     label = 'سابمشین‌گان' },
        { id = 'rifle',   label = 'تفنگ' },
        { id = 'shotgun', label = 'شات‌گان' },
        { id = 'sniper',  label = 'اسنایپر' },
        { id = 'other',   label = 'سایر' },
    },

    weapons = {
        WEAPON_KNIFE                   = { time = 10, forge =  3, wolfram =  1, gun_metal =  2 },
        WEAPON_DAGGER                  = { time = 10, forge =  4, wolfram =  1, gun_metal =  2 },
        WEAPON_KNUCKLE                 = { time = 15, forge =  5, wolfram =  1, gun_metal =  5 },
        WEAPON_MACHETE                 = { time = 10, forge =  5, wolfram =  2, gun_metal =  2 },
        WEAPON_SNSPISTOL               = { time = 15, forge =  4, wolfram =  2, gun_metal =  2 },
        WEAPON_COMBATPISTOL            = { time = 15, forge =  6, wolfram =  3, gun_metal =  3 },
        WEAPON_PISTOLXM3               = { time = 25, forge =  6, wolfram =  3, gun_metal =  4 },
        WEAPON_SNSPISTOL_MK2           = { time = 25, forge =  6, wolfram =  2, gun_metal =  2 },
        WEAPON_PISTOL                  = { time = 15, forge =  7, wolfram =  2, gun_metal =  2 },
        WEAPON_PISTOL_MK2              = { time = 25, forge =  7, wolfram =  3, gun_metal =  6 },
        WEAPON_CERAMICPISTOL           = { time = 20, forge =  8, wolfram =  3, gun_metal =  4 },
        WEAPON_VINTAGEPISTOL           = { time = 15, forge =  9, wolfram =  4, gun_metal =  4 },
        WEAPON_NAVYREVOLVER            = { time = 25, forge = 10, wolfram =  5, gun_metal =  4 },
        WEAPON_HEAVYPISTOL             = { time = 15, forge = 11, wolfram =  5, gun_metal =  4 },
        WEAPON_REVOLVER_MK2            = { time = 25, forge = 12, wolfram =  5, gun_metal =  5 },
        WEAPON_REVOLVER                = { time = 25, forge = 13, wolfram =  5, gun_metal =  6 },
        WEAPON_GADGETPISTOL            = { time = 25, forge = 14, wolfram =  7, gun_metal =  5 },
        WEAPON_TECPISTOL               = { time = 25, forge = 14, wolfram =  6, gun_metal =  6 },
        WEAPON_PISTOL50                = { time = 15, forge = 15, wolfram =  6, gun_metal =  5 },
        WEAPON_DOUBLEACTION            = { time = 25, forge = 16, wolfram =  7, gun_metal =  6 },
        WEAPON_APPISTOL                = { time = 25, forge = 20, wolfram = 10, gun_metal = 10 },
        WEAPON_COMBATPDW               = { time = 20, forge = 12, wolfram =  6, gun_metal =  6 },
        WEAPON_MACHINEPISTOL           = { time = 25, forge = 16, wolfram =  8, gun_metal =  6 },
        WEAPON_SMG                     = { time = 20, forge = 16, wolfram =  8, gun_metal =  4 },
        WEAPON_ASSAULTSMG              = { time = 20, forge = 19, wolfram =  8, gun_metal =  6 },
        WEAPON_SMG_MK2                 = { time = 25, forge = 20, wolfram = 10, gun_metal = 10 },
        WEAPON_MICROSMG                = { time = 25, forge = 22, wolfram = 10, gun_metal = 10 },
        WEAPON_MINISMG                 = { time = 25, forge = 25, wolfram = 11, gun_metal = 10 },
        WEAPON_GUSENBERG               = { time = 20, forge = 26, wolfram = 12, gun_metal = 10 },
        WEAPON_COMPACTRIFLE            = { time = 20, forge = 17, wolfram =  8, gun_metal =  7 },
        WEAPON_HEAVYRIFLE              = { time = 25, forge = 18, wolfram =  9, gun_metal =  7 },
        WEAPON_ASSAULTRIFLE            = { time = 20, forge = 20, wolfram =  9, gun_metal =  7 },
        WEAPON_BULLPUPRIFLE            = { time = 20, forge = 21, wolfram = 10, gun_metal =  7 },
        WEAPON_ASSAULTRIFLE_MK2        = { time = 25, forge = 24, wolfram = 12, gun_metal =  9 },
        WEAPON_SPECIALCARBINE          = { time = 20, forge = 24, wolfram = 11, gun_metal =  9 },
        WEAPON_TACTICALRIFLE           = { time = 25, forge = 24, wolfram = 11, gun_metal =  9 },
        WEAPON_CARBINERIFLE            = { time = 20, forge = 25, wolfram = 11, gun_metal =  8 },
        WEAPON_MILITARYRIFLE           = { time = 25, forge = 26, wolfram = 12, gun_metal = 10 },
        WEAPON_ADVANCEDRIFLE           = { time = 20, forge = 27, wolfram = 13, gun_metal = 10 },
        WEAPON_CARBINERIFLE_MK2        = { time = 25, forge = 28, wolfram = 14, gun_metal = 12 },
        WEAPON_SPECIALCARBINE_MK2      = { time = 25, forge = 28, wolfram = 14, gun_metal = 12 },
        WEAPON_BULLPUPRIFLE_MK2        = { time = 25, forge = 29, wolfram = 14, gun_metal = 13 },
        WEAPON_HEAVYSHOTGUN            = { time = 25, forge = 20, wolfram =  9, gun_metal = 12 },
        WEAPON_AUTOSHOTGUN             = { time = 25, forge = 22, wolfram = 11, gun_metal = 13 },
        WEAPON_ASSAULTSHOTGUN          = { time = 20, forge = 24, wolfram = 12, gun_metal = 14 },
        WEAPON_COMBATSHOTGUN           = { time = 25, forge = 26, wolfram = 13, gun_metal = 17 },
        WEAPON_PUMPSHOTGUN             = { time = 20, forge = 31, wolfram = 14, gun_metal = 16 },
        WEAPON_BULLPUPSHOTGUN          = { time = 20, forge = 32, wolfram = 16, gun_metal = 17 },
        WEAPON_SAWNOFFSHOTGUN          = { time = 20, forge = 34, wolfram = 17, gun_metal = 19 },
        WEAPON_PUMPSHOTGUN_MK2         = { time = 25, forge = 37, wolfram = 18, gun_metal = 21 },
        WEAPON_DBSHOTGUN               = { time = 25, forge = 38, wolfram = 19, gun_metal = 24 },
        WEAPON_MARKSMANPISTOL          = { time = 25, forge =  9, wolfram =  4, gun_metal =  5 },
        WEAPON_MG                      = { time = 25, forge = 22, wolfram = 11, gun_metal = 16 },
        WEAPON_COMBATMG                = { time = 25, forge = 26, wolfram = 13, gun_metal = 18 },
        WEAPON_FLARE                   = { time = 10, forge = 26, wolfram = 12, gun_metal =  2 },
        WEAPON_COMBATMG_MK2            = { time = 25, forge = 30, wolfram = 15, gun_metal = 20 },
    },
}

-- materials needed for a weapon at a tier: { forge = n, wolfram = n, gun_metal = n }
function Crafting.CostFor(weapon, tier)
    local r = Crafting.weapons[weapon]
    if not r or not tier then return nil end
    local out = {}
    for _, mat in ipairs(Crafting.materialOrder) do
        local base = r[mat] or 0
        if base > 0 then out[mat] = math.max(1, math.ceil(base * tier.cost - 1e-9)) end
    end
    return out
end

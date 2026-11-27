-- ============================================================================
-- Unique_inventory | shared/weapon-life.lua
-- Weapon lifetime: expiry date, wear per shot (health %), breaking, cleaning.
-- Numbers follow the original server (maxShots = 500).
-- ============================================================================
WeaponLife = {
    -- Lifetime of a weapon that shows up WITHOUT being crafted (admin, shop, loot ...), counted from
    -- the first time the system sees it. Crafted weapons get the duration the player picked.
    --   WeaponLife.days['WEAPON_X'] = 30     30 days
    --   WeaponLife.days['WEAPON_X'] = false  permanent
    -- anything not listed follows its group below, then `defaultDays`.
    defaultDays = 7,
    groupDays = {
        melee   = false,   -- permanent
        pistol  = 7,
        smg     = 7,
        rifle   = 7,
        shotgun = 7,
        sniper  = 7,
        other   = 7,
    },
    days = {},

    -- serial prefixes that never expire (this server: DOJ- = police armory, GANG- = gang armory,
    -- LAW- = everything else)
    noExpirePrefixes = { 'DOJ-', 'GANG-' },

    -- crafting tiers: fewer days = cheaper. `cost` multiplies the permanent recipe (rounded up, min 1).
    -- Only short lifetimes exist: a temporary weapon cannot be put into an armory (see server/jobs.lua).
    tiers = {
        { id = 'permanent', days = nil, label = 'دائمی',   cost = 1.0 },
        { id = 'd7',        days = 7,   label = '۷ روزه',  cost = 0.7 },
        { id = 'd3',        days = 3,   label = '۳ روزه',  cost = 0.5 },
    },

    -- true: an expired weapon is removed from the player; false: it only shows as expired
    deleteExpired = true,

    -- shots from 100% to 0%
    maxShotsDefault = 500,
    maxShots = {
        -- ['WEAPON_MINIGUN'] = 1000,
    },
    -- at 0% the weapon cannot fire until it is cleaned
    brokenBlocksFiring = true,

    -- item that restores a weapon to 100% (the weapon in the player's hand)
    cleaner = { item = 'gun_cleaner', label = 'Gun Cleaner', weight = 0.3, seconds = 8 },

    -- how often the server checks expiry for everybody online
    sweepSeconds = 60,
}

function WeaponLife.MaxShots(name)
    return WeaponLife.maxShots[tostring(name or ''):upper()] or WeaponLife.maxShotsDefault
end

function WeaponLife.GroupOf(name)
    local n = tostring(name or ''):upper():gsub('^WEAPON_', '')
    local melee = { KNIFE=1, DAGGER=1, MACHETE=1, BAT=1, CROWBAR=1, HAMMER=1, KNUCKLE=1, NIGHTSTICK=1, GOLFCLUB=1,
        HATCHET=1, BATTLEAXE=1, POOLCUE=1, WRENCH=1, SWITCHBLADE=1, BOTTLE=1, FLASHLIGHT=1, STONE_HATCHET=1, CANDYCANE=1 }
    if melee[n] then return 'melee' end
    if n:find('SNIPER') or n:find('MARKSMAN') then return 'sniper' end
    if n:find('SHOTGUN') then return 'shotgun' end
    if n:find('PDW') or n:find('SMG') or n:find('MACHINEPISTOL') or n:find('GUSENBERG') then return 'smg' end
    if n:find('RIFLE') or n:find('CARBINE') or n:find('MUSKET') then return 'rifle' end
    if n:find('PISTOL') or n:find('REVOLVER') or n:find('DOUBLEACTION') or n:find('STUNGUN') then return 'pistol' end
    return 'other'
end

-- days a non-crafted weapon lives; nil = permanent
function WeaponLife.DaysFor(name)
    local key = tostring(name or ''):upper()
    local d = WeaponLife.days[key]
    if d == nil then d = WeaponLife.groupDays[WeaponLife.GroupOf(key)] end
    if d == nil then d = WeaponLife.defaultDays end
    if d == false or d == 0 then return nil end
    return d
end

function WeaponLife.TierById(id)
    for _, t in ipairs(WeaponLife.tiers) do
        if t.id == id then return t end
    end
end

function WeaponLife.NoExpire(serial)
    serial = tostring(serial or '')
    for _, prefix in ipairs(WeaponLife.noExpirePrefixes) do
        if serial:sub(1, #prefix) == prefix then return true end
    end
    return false
end

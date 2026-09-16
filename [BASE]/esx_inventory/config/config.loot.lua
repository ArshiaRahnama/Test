--╔════════════════════════════════════════════════════════════════════════════════╗
--  ██╗      ██████╗  ██████╗ ████████╗
--  ██║     ██╔═══██╗██╔═══██╗╚══██╔══╝
--  ██║     ██║   ██║██║   ██║   ██║
--  ██║     ██║   ██║██║   ██║   ██║
--  ███████╗╚██████╔╝╚██████╔╝   ██║
--  ╚══════╝ ╚═════╝  ╚═════╝    ╚═╝
--
--  Features #9 (per-ped-type loot tables) and #10 (real weapon loot).
--
--  Replaces the single flat Config.NPCLootTable. That old key is still
--  read as the fallback for any ped that doesn't match a category below,
--  so nothing breaks if you don't configure this file at all.
--╚════════════════════════════════════════════════════════════════════════════════╝

Config = Config or {}

-- Master switch for the categorised system. false = fall back to the old
-- flat Config.NPCLootTable behaviour for every ped.
Config.UsePedCategories = true

--─────────────────────────────────────────────────────────────────────────
-- #9 — PED CATEGORISATION
--
-- How a dead ped gets sorted into a category, in priority order:
--   1. Explicit model match in Config.PedCategoryModels (most specific)
--   2. GTA ped TYPE (GetPedType native) via Config.PedCategoryByType
--   3. Config.DefaultPedCategory
--
-- GetPedType return values that matter here:
--   1  = PED_TYPE_PLAYER (not used - dead players go through
--        server/apps/system/loot.lua, not this system)
--   4  = CIVMALE
--   5  = CIVFEMALE
--   6  = COP
--   19 = GANG_ALBANIAN     20 = GANG_1     21 = GANG_2
--   22 = GANG_CHINESE      23 = GANG_MEXICAN
--   27 = ARMY
--   28 = ANIMAL
--   29 = MEDIC / paramedic
--   30 = FIREMAN  (varies slightly by build)
--
-- ⚠️ GetPedType is a CLIENT native. The client sends the type along with
-- the loot request; the server does NOT blindly trust it - see
-- server/custom/corpse/corpse.lua, which re-derives the category from the
-- ped's MODEL (which the server can verify via the network id) and only
-- uses the client-reported type as a hint when the model is unknown.
--─────────────────────────────────────────────────────────────────────────

Config.DefaultPedCategory = 'civilian'

Config.PedCategoryByType = {
    [4]  = 'civilian',
    [5]  = 'civilian',
    [6]  = 'police',
    [19] = 'gang',
    [20] = 'gang',
    [21] = 'gang',
    [22] = 'gang',
    [23] = 'gang',
    [27] = 'army',
    [28] = 'animal',
    [29] = 'medic',
    [30] = 'medic',
}

-- Model-name overrides. Takes priority over ped type. Use this for models
-- GTA classifies oddly (a lot of "gang" models are actually CIVMALE), and
-- for your own streamed/custom peds.
--
-- Keys are lowercase model names. The server normalises before lookup, so
-- case here doesn't matter.
Config.PedCategoryModels = {
    -- security / armed civilians
    ['s_m_m_security_01']   = 'security',
    ['s_m_y_blackops_01']   = 'army',
    ['s_m_y_blackops_02']   = 'army',
    ['s_m_y_marine_01']     = 'army',
    ['s_m_y_marine_02']     = 'army',
    ['s_m_y_swat_01']       = 'police',

    -- police (some are typed COP already, listed for clarity/custom packs)
    ['s_m_y_cop_01']        = 'police',
    ['s_f_y_cop_01']        = 'police',
    ['s_m_y_sheriff_01']    = 'police',
    ['s_f_y_sheriff_01']    = 'police',
    ['s_m_y_hwaycop_01']    = 'police',
    ['s_m_m_snowcop_01']    = 'police',
    ['s_m_m_fibsec_01']     = 'police',

    -- gangs that GTA types as plain civilians
    ['g_m_y_ballasout_01']  = 'gang',
    ['g_m_y_ballaeast_01']  = 'gang',
    ['g_m_y_famca_01']      = 'gang',
    ['g_m_y_famdnf_01']     = 'gang',
    ['g_m_y_famfor_01']     = 'gang',
    ['g_m_y_lost_01']       = 'gang',
    ['g_m_y_mexgoon_01']    = 'gang',
    ['g_m_y_salvagoon_01']  = 'gang',
    ['g_m_y_korean_01']     = 'gang',
    ['g_m_m_chiboss_01']    = 'gang',

    -- medics / fire
    ['s_m_m_paramedic_01']  = 'medic',
    ['s_m_y_fireman_01']    = 'medic',

    -- homeless / low-value
    ['a_m_m_skater_01']     = 'civilian',
    ['a_m_o_tramp_01']      = 'homeless',
    ['a_m_m_tramp_01']      = 'homeless',
    ['a_f_o_indian_01']     = 'homeless',

    -- wealthy targets
    ['a_m_y_business_01']   = 'business',
    ['a_m_y_business_02']   = 'business',
    ['a_m_m_business_01']   = 'business',
    ['a_f_y_business_01']   = 'business',
    ['a_f_y_business_02']   = 'business',
}

--─────────────────────────────────────────────────────────────────────────
-- THE LOOT TABLES
--
-- Per category:
--   cash    = {chance =, min =, max =}  rolled once
--   items   = list of {name =, label =, chance =, min =, max =}
--             each rolled INDEPENDENTLY (chances don't have to sum to 100)
--   weapons = list of {name =, chance =, ammo = {min =, max =}}
--             see #10 below
--   maxItemRolls = optional cap on how many distinct item entries can
--             succeed on one body, so a lucky roll can't drop everything
--             at once. nil = uncapped.
--
-- ⚠️ ONLY put item names that actually exist in your `items` table. An
-- invalid name silently gives nothing (same as anywhere else in ESX).
-- Everything below is commented out by default for exactly that reason -
-- I can't know your item list. Uncomment and rename to match yours.
--─────────────────────────────────────────────────────────────────────────

Config.PedLootTables = {

    ['civilian'] = {
        cash = {chance = 70, min = 5, max = 90},
        maxItemRolls = 2,
        items = {
            -- {name = 'phone',    label = 'Phone',    chance = 15, min = 1, max = 1},
            -- {name = 'bread',    label = 'Bread',    chance = 20, min = 1, max = 2},
            -- {name = 'water',    label = 'Water',    chance = 20, min = 1, max = 2},
        },
        weapons = {},
    },

    ['homeless'] = {
        cash = {chance = 40, min = 1, max = 15},
        maxItemRolls = 1,
        items = {
            -- {name = 'bread',    label = 'Bread',    chance = 25, min = 1, max = 1},
        },
        weapons = {},
    },

    ['business'] = {
        cash = {chance = 90, min = 150, max = 800},
        maxItemRolls = 2,
        items = {
            -- {name = 'phone',      label = 'Phone',      chance = 40, min = 1, max = 1},
            -- {name = 'gold_watch', label = 'Gold Watch', chance = 8,  min = 1, max = 1},
        },
        weapons = {},
    },

    ['police'] = {
        cash = {chance = 50, min = 20, max = 120},
        maxItemRolls = 3,
        items = {
            -- {name = 'handcuffs', label = 'Handcuffs', chance = 30, min = 1, max = 1},
            -- {name = 'radio',     label = 'Radio',     chance = 35, min = 1, max = 1},
            -- {name = 'bandage',   label = 'Bandage',   chance = 25, min = 1, max = 2},
        },
        -- #10: a dead cop can actually be carrying their sidearm.
        weapons = {
            {name = 'WEAPON_PISTOL',     chance = 35, ammo = {min = 6,  max = 24}},
            {name = 'WEAPON_STUNGUN',    chance = 15, ammo = {min = 1,  max = 1}},
            {name = 'WEAPON_NIGHTSTICK', chance = 20, ammo = {min = 1,  max = 1}},
        },
    },

    ['gang'] = {
        cash = {chance = 85, min = 50, max = 400},
        maxItemRolls = 2,
        items = {
            -- {name = 'weed_pooch', label = 'Weed',   chance = 25, min = 1, max = 3},
            -- {name = 'lockpick',   label = 'Lockpick', chance = 15, min = 1, max = 1},
        },
        weapons = {
            {name = 'WEAPON_PISTOL',        chance = 25, ammo = {min = 3, max = 15}},
            {name = 'WEAPON_MICROSMG',      chance = 10, ammo = {min = 8, max = 30}},
            {name = 'WEAPON_SAWNOFFSHOTGUN',chance = 8,  ammo = {min = 2, max = 8}},
            {name = 'WEAPON_KNIFE',         chance = 20, ammo = {min = 1, max = 1}},
        },
    },

    ['army'] = {
        cash = {chance = 40, min = 30, max = 150},
        maxItemRolls = 2,
        items = {
            -- {name = 'bandage',  label = 'Bandage',  chance = 40, min = 1, max = 3},
        },
        weapons = {
            {name = 'WEAPON_ASSAULTRIFLE', chance = 20, ammo = {min = 10, max = 60}},
            {name = 'WEAPON_CARBINERIFLE', chance = 15, ammo = {min = 10, max = 60}},
            {name = 'WEAPON_COMBATPISTOL', chance = 30, ammo = {min = 6,  max = 24}},
        },
    },

    ['security'] = {
        cash = {chance = 60, min = 20, max = 100},
        maxItemRolls = 1,
        items = {},
        weapons = {
            {name = 'WEAPON_PISTOL', chance = 30, ammo = {min = 4, max = 16}},
        },
    },

    ['medic'] = {
        cash = {chance = 50, min = 15, max = 80},
        maxItemRolls = 3,
        items = {
            -- {name = 'bandage',  label = 'Bandage',  chance = 60, min = 1, max = 4},
            -- {name = 'medikit',  label = 'Medikit',  chance = 25, min = 1, max = 1},
        },
        weapons = {},
    },

    -- Animals carry nothing. Present so they resolve to an empty table
    -- rather than falling through to the civilian one.
    ['animal'] = {
        cash = {chance = 0, min = 0, max = 0},
        items = {},
        weapons = {},
    },
}

--─────────────────────────────────────────────────────────────────────────
-- #10 — WEAPON LOOT RULES
--─────────────────────────────────────────────────────────────────────────
Config.CorpseWeapons = {
    enabled = true,

    -- Only drop a weapon if the ped was ACTUALLY armed when it died.
    -- Strongly recommended: it means "I shot an armed gangster, I get his
    -- gun" rather than random pistols materialising out of unarmed
    -- pedestrians. The client reports the ped's held weapon hash at time
    -- of looting; the server cross-checks it against the category's
    -- allowed weapon list, so a spoofed hash can only ever produce a
    -- weapon that category could legitimately drop anyway.
    requireArmed = true,

    -- If requireArmed is true and the ped WAS armed, prefer dropping the
    -- exact weapon it was holding (looked up against the category list)
    -- over rolling a random one.
    preferHeldWeapon = true,

    -- Max weapons a single body can yield, regardless of how many entries
    -- pass their chance roll.
    maxPerCorpse = 1,

    -- Serial prefix for weapons that come off an NPC. Keeps them
    -- immediately distinguishable in the chain-of-custody log (#7) from
    -- LAW- (shop), DOJ- (police armory) and GANG- (gang armory) serials.
    serialPrefix = 'STRT',

    -- Looted NPC weapons are flagged illegal on a police scan regardless
    -- of Config.WeaponLegality, since they have no legitimate paper
    -- trail. Set false to use the normal per-weapon legality instead.
    alwaysIllegal = true,
}

--─────────────────────────────────────────────────────────────────────────
-- #11 — UNLOOTED CORPSE GLOW
--─────────────────────────────────────────────────────────────────────────
Config.CorpseGlow = {
    enabled = true,

    -- Distance (m) at which the glow starts rendering. Keep this modest -
    -- the marker loop scans the local ped pool, and a large radius on a
    -- busy street is wasted work.
    drawDistance = 20.0,

    -- Only render the glow when the player is close enough to actually
    -- interact. Avoids lighting up every corpse across the map after a
    -- big shootout, which looks like a cheat menu.
    onlyWhenLootable = true,

    -- 'outline' uses SetEntityDrawOutline (clean, needs no per-frame
    -- marker draw, but is a hard-edged shader outline).
    -- 'marker' draws a soft marker above the body.
    -- 'both' does both.
    style = 'marker',

    outlineColor = {r = 255, g = 190, b = 60, a = 180},

    marker = {
        type = 27,          -- flat ring on the ground
        scale = 0.55,
        heightOffset = 0.05,
        color = {r = 255, g = 190, b = 60, a = 90},
        bobUpAndDown = false,
        rotate = true,
    },

    -- Fade the glow out over the last N seconds of the corpse's lootable
    -- window, so players get a visual warning it's about to expire rather
    -- than it vanishing with no notice.
    fadeOutSeconds = 30,
}

-- ScriptPack / change world settings (loaded by both client and server)
CWConfig = {}

-- Minimum users.permission_level that may open the world manager and enter ANY world.
CWConfig.AdminPermission = 8

-- Allowed world ids for created worlds. 0 is always the real world.
CWConfig.MinWorldId = 1
CWConfig.MaxWorldId = 99999

-- Where a player is put back if their return position was lost (e.g. world set by another script).
CWConfig.ReturnFallback = { x = 632.23, y = -10.65, z = 82.78, h = 0.0 }

-- Keep ambient peds/traffic off inside worlds.
CWConfig.PopulationInWorlds = false

-- Key that opens the in-world tools menu (players can rebind it in GTA settings).
CWConfig.MenuKey = 'F9'

-- Tools available in a world unless the admin overrides them per world in the manager.
CWConfig.DefaultFlags = {
    menu    = true, -- in-world tools menu
    vehicle = true, -- spawn / delete vehicle
    tp      = true, -- teleport to waypoint
    revive  = true, -- self revive
    weapon  = true, -- refill ammo of the held weapon
    armor   = true, -- full armor
    peds    = true, -- change ped model
    skins   = true, -- saved outfits of the world (/worldskin)
}

-- Ped preview pictures shown in the "Change ped" menu (%s = model name).
CWConfig.PedImageUrl = 'https://docs.fivem.net/peds/%s.webp'

-- Short commands that work inside a world (same tools as the F9 menu).
-- /spawn <model>  /dveh  /revme  /ctp  /armorme  /cgetmaxammo  /openmenu
CWConfig.LegacyCommands = true

-- Streamer entrance: players whose users.`group` matches may use /cw [id] near the hub to
-- move themselves (or another player) into the streamer world, and /bw to come back.
CWConfig.Streamer = {
    enabled = true,
    group   = 'streamer',
    world   = 90,
    radius  = 20.0,
    hub     = { x = 632.2348, y = -10.6546, z = 82.779, h = 0.0 },
}

-- Max vehicles one player can have spawned through the menu at once.
CWConfig.MaxSpawnedVehicles = 3

-- Ped models offered by "Change ped". Add or remove freely.
CWConfig.Peds = {
    { label = 'Male', list = {
        { label = 'Beach',      model = 'a_m_m_beach_01' },
        { label = 'Business',   model = 'a_m_m_business_01' },
        { label = 'Hipster',    model = 'a_m_y_hipster_01' },
        { label = 'Soldier',    model = 's_m_y_marine_01' },
        { label = 'Swat',       model = 's_m_y_swat_01' },
        { label = 'Cop',        model = 's_m_y_cop_01' },
    } },
    { label = 'Female', list = {
        { label = 'Beach',      model = 'a_f_m_beach_01' },
        { label = 'Business',   model = 'a_f_m_business_02' },
        { label = 'Hipster',    model = 'a_f_y_hipster_01' },
        { label = 'Cop',        model = 's_f_y_cop_01' },
    } },
    { label = 'Animal', list = {
        { label = 'Cat',        model = 'a_c_cat_01' },
        { label = 'Dog',        model = 'a_c_shepherd' },
        { label = 'Deer',       model = 'a_c_deer' },
    } },
}

-- Optional Discord webhook for join/leave/admin logs. Prefer the convar so the secret stays out of git:
--   set unique_changeworld_webhook "https://discord.com/api/webhooks/..."

-- Worlds that exist only in this file (no database row, nobody can /joinworld them).
-- They give an id its own tools, label, outfits and optional spawn point. World 90 is the streamer world.
CWConfig.StaticWorlds = {
    [90] = {
        label = 'Streamer world',
        flags = { menu = true, vehicle = true, tp = true, revive = true, weapon = true },
        -- spawn = { x = 0.0, y = 0.0, z = 0.0, h = 0.0 },
    },
}

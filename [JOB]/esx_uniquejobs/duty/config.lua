Config_duty = {}
Config_duty.Color = { r = 0, g = 255, b = 0 }
Config_duty.Size = { x = 0.7, y = 0.7, z = 0.7 }
Config_duty.Zones = {
  police = {Pos = {x = 629.1069, y = -6.22858, z = 82.779}},
 -- police2 = {Pos = { x = 629.1069, y = -6.22858, z = 82.779 }},

  ambulance = {Pos = { x = 311.5020, y = -594.080, z = 43.284 }},

  mechanic = {Pos = { x = -347.086, y = -151.197, z = 44.585 }},

  sheriff = {Pos = { x = 1852.137, y = 3690.703, z = 34.286 }},

  taxi = {Pos = { x = 899.2251, y = -159.519, z = 74.147 }},

  weazel = {Pos = { x = -585.961, y = -934.131, z = 23.815 }},

  fbi = {Pos = { x = 117.45, y = -750.2, z = 45.75 }},
  mt = {Pos = { x = -2345.57, y = 3268.801, z = 32.810 }},

  -- Department Of Justice: placeholder coords near the FBI federal building
  -- (same building as FBI, offset a few meters apart) - adjust in-game as you like.
  cid     = {Pos = { x = 121.45, y = -750.2, z = 45.75 }},
  cia     = {Pos = { x = 125.45, y = -750.2, z = 45.75 }},
  marshal = {Pos = { x = 129.45, y = -750.2, z = 45.75 }},
  judge   = {Pos = { x = 133.45, y = -750.2, z = 45.75 }},
  doa     = {Pos = { x = 137.45, y = -750.2, z = 45.75 }},

  -- Holding 1 (uniquecafejobs): all 17 businesses + Meridian/Blacktide/CrateCarry
  -- + Holding 2 (Turf Wars). PLACEHOLDER coords, same ones used inside
  -- uniquecafejobs' own shared/cafes.lua / shared/corp.lua / shared/turfco.lua.
  uwucafe = {Pos = {x = -581.831, y = -1064.56, z = 22.347}},
  obsidian = {Pos = {x = -1223.0, y = -906.0, z = 12.33}},
  voltage = {Pos = {x = 442.9, y = -1750.0, z = 29.5}},
  ember = {Pos = {x = -1391.0, y = -583.0, z = 30.3}},
  anchor = {Pos = {x = -1850.0, y = -1230.0, z = 13.0}},
  crimson = {Pos = {x = -278.0, y = -720.0, z = 33.0}},
  flourish = {Pos = {x = -1100.0, y = 260.0, z = 69.0}},
  goldcrust = {Pos = {x = 150.0, y = -1300.0, z = 29.0}},
  static = {Pos = {x = -1385.0, y = -600.0, z = 30.5}},
  nightjar = {Pos = {x = -560.0, y = 290.0, z = 82.5}},
  firebrick = {Pos = {x = -710.0, y = -915.0, z = 19.2}},
  slice = {Pos = {x = -47.0, y = -1750.0, z = 29.5}},
  frostbite = {Pos = {x = -820.0, y = 180.0, z = 71.5}},
  sundae = {Pos = {x = -1090.0, y = -390.0, z = 36.7}},
  koi = {Pos = {x = -560.0, y = -1250.0, z = 17.6}},
  wasabi = {Pos = {x = -1210.0, y = -450.0, z = 36.9}},
  carwash = {Pos = {x = -207.0, y = -1330.0, z = 31.0}},
  meridian = {Pos = {x = -75.3, y = -818.3, z = 243.8}},
  blacktide = {Pos = {x = 1207.0, y = -3129.0, z = 5.9}},
  cratecarry = {Pos = {x = 1210.0, y = -3050.0, z = 5.0}},
  turfco = {Pos = {x = 2565.0, y = 2585.0, z = 37.9}},
}

Config_duty.Webhooks = {
  police = GetConvar('unique_config_police', ''),
  ambulance = GetConvar('unique_config_ambulance', ''),
  mechanic = GetConvar('unique_config_mechanic', ''),
  sheriff = GetConvar('unique_config_sheriff', ''),
  taxi = GetConvar('unique_config_taxi', ''),
  weazel = GetConvar('unique_config_weazel', ''),
  fbi = GetConvar('unique_config_fbi', ''),
  mt = GetConvar('unique_config_mt', ''),

  -- Department Of Justice: placeholder webhooks so PerformHttpRequest never gets a nil
  -- URL (which would error). Swap the "changeme" part for your real Discord webhook
  -- when you make one for each - until then these just fail silently, no crash.
  cid     = "https://discord.com/api/webhooks/CID_WEBHOOK_ID/CID_WEBHOOK_TOKEN",
  cia     = "https://discord.com/api/webhooks/CIA_WEBHOOK_ID/CIA_WEBHOOK_TOKEN",
  marshal = "https://discord.com/api/webhooks/MARSHAL_WEBHOOK_ID/MARSHAL_WEBHOOK_TOKEN",
  judge   = "https://discord.com/api/webhooks/JUDGE_WEBHOOK_ID/JUDGE_WEBHOOK_TOKEN",
  doa     = "https://discord.com/api/webhooks/DOA_WEBHOOK_ID/DOA_WEBHOOK_TOKEN",

  -- Holding 1 businesses + all 4 holdings
  uwucafe = "https://discord.com/api/webhooks/UWUCAFE_WEBHOOK_ID/UWUCAFE_WEBHOOK_TOKEN",
  obsidian = "https://discord.com/api/webhooks/OBSIDIAN_WEBHOOK_ID/OBSIDIAN_WEBHOOK_TOKEN",
  voltage = "https://discord.com/api/webhooks/VOLTAGE_WEBHOOK_ID/VOLTAGE_WEBHOOK_TOKEN",
  ember = "https://discord.com/api/webhooks/EMBER_WEBHOOK_ID/EMBER_WEBHOOK_TOKEN",
  anchor = "https://discord.com/api/webhooks/ANCHOR_WEBHOOK_ID/ANCHOR_WEBHOOK_TOKEN",
  crimson = "https://discord.com/api/webhooks/CRIMSON_WEBHOOK_ID/CRIMSON_WEBHOOK_TOKEN",
  flourish = "https://discord.com/api/webhooks/FLOURISH_WEBHOOK_ID/FLOURISH_WEBHOOK_TOKEN",
  goldcrust = "https://discord.com/api/webhooks/GOLDCRUST_WEBHOOK_ID/GOLDCRUST_WEBHOOK_TOKEN",
  static = "https://discord.com/api/webhooks/STATIC_WEBHOOK_ID/STATIC_WEBHOOK_TOKEN",
  nightjar = "https://discord.com/api/webhooks/NIGHTJAR_WEBHOOK_ID/NIGHTJAR_WEBHOOK_TOKEN",
  firebrick = "https://discord.com/api/webhooks/FIREBRICK_WEBHOOK_ID/FIREBRICK_WEBHOOK_TOKEN",
  slice = "https://discord.com/api/webhooks/SLICE_WEBHOOK_ID/SLICE_WEBHOOK_TOKEN",
  frostbite = "https://discord.com/api/webhooks/FROSTBITE_WEBHOOK_ID/FROSTBITE_WEBHOOK_TOKEN",
  sundae = "https://discord.com/api/webhooks/SUNDAE_WEBHOOK_ID/SUNDAE_WEBHOOK_TOKEN",
  koi = "https://discord.com/api/webhooks/KOI_WEBHOOK_ID/KOI_WEBHOOK_TOKEN",
  wasabi = "https://discord.com/api/webhooks/WASABI_WEBHOOK_ID/WASABI_WEBHOOK_TOKEN",
  carwash = "https://discord.com/api/webhooks/CARWASH_WEBHOOK_ID/CARWASH_WEBHOOK_TOKEN",
  meridian = "https://discord.com/api/webhooks/MERIDIAN_WEBHOOK_ID/MERIDIAN_WEBHOOK_TOKEN",
  blacktide = "https://discord.com/api/webhooks/BLACKTIDE_WEBHOOK_ID/BLACKTIDE_WEBHOOK_TOKEN",
  cratecarry = "https://discord.com/api/webhooks/CRATECARRY_WEBHOOK_ID/CRATECARRY_WEBHOOK_TOKEN",
  turfco = "https://discord.com/api/webhooks/TURFCO_WEBHOOK_ID/TURFCO_WEBHOOK_TOKEN",
}


-- ---------------------------------------------------------------------------
-- Extra duty points: several points per job, each point lists every job that may
-- use it (the same layout the sunset duty list uses). Config_duty.Zones above
-- stays the one-point-per-job base list (the job manager edits it live) and
-- these are ADDED on top. A point within 1m of a Zones point is merged into it,
-- so you never get two markers on top of each other.
-- Job names are the ones that exist on this server ('judge' = sunset's 'justice';
-- 'detective' does not exist here so it is left out).
-- ---------------------------------------------------------------------------
Config_duty.InteractRadius = 2.0   -- how close you must stand to press E
Config_duty.DrawDistance   = 10.0  -- markers are drawn within this distance
Config_duty.Cooldown       = 15000 -- ms between two manual toggles (anti spam)
Config_duty.ServerMaxDist  = 15.0  -- server rejects going ON duty farther than this from every allowed point

local LE   = { police = true, sheriff = true, mt = true }
local BLUE   = { r = 0,   g = 0,   b = 255 }
local YELLOW = { r = 204, g = 204, b = 0 }
local RED    = { r = 255, g = 0,   b = 0 }

Config_duty.Locations = {
  -- Police / Sheriff / MT
  { label = 'PD 2',    Pos = { x = 628.93,  y = -5.87,    z = 82.78 }, Type = 20, Color = BLUE, job = LE },
  { label = 'PD 3',    Pos = { x = -56.45,  y = -2505.81, z = 7.39  }, Type = 20, Color = BLUE, job = LE },
  { label = 'Army',    Pos = { x = -2354.38, y = 3259.08, z = 32.81 }, Type = 20, Color = BLUE, job = LE },
  { label = 'Sandy',   Pos = { x = 1830.5,  y = 3683.59,  z = 34.33 }, Type = 20, Color = BLUE, job = LE },
  { label = 'Paleto',  Pos = { x = -437.34, y = 6002.07,  z = 31.72 }, Type = 20, Color = BLUE, job = LE },

  -- Mechanic
  { label = 'Mechanic New City', Pos = { x = 620.93, y = 628.05, z = 128.97 }, Type = 20, Color = YELLOW,
    job = { mechanic = true } },

  -- Ambulance
  { label = 'MD Central', Pos = { x = 1147.64,  y = -1546.3, z = 35.38 }, Type = 21, Color = RED, job = { ambulance = true } },
  { label = 'MD 2',       Pos = { x = -1855.15, y = -335.0,  z = 49.25 }, Type = 21, Color = RED, job = { ambulance = true } },

  -- Taxi
  { label = 'Taxi Center', Pos = { x = 357.64, y = -1590.6, z = 29.29 }, Type = 20, Color = YELLOW, job = { taxi = true } },

  -- FBI building: shared point for the federal / emergency jobs
  { label = 'FBI Shared', Pos = { x = 123.71, y = -769.7, z = 242.15 }, Type = 20, Color = YELLOW,
    job = { fbi = true, police = true, sheriff = true, mt = true, judge = true, taxi = true, ambulance = true, mechanic = true } },

  -- Justice (judge)
  { label = 'Justice',   Pos = { x = -548.54, y = -182.18, z = 38.22 }, Type = 20, Color = YELLOW, job = { judge = true } },
  { label = 'Justice 2', Pos = { x = 216.94,  y = -413.66, z = 47.98 }, Type = 20, Color = YELLOW, job = { judge = true } },
}

-- Shared helpers (this file loads on both client and server).
-- Every duty point as { x, y, z, jobs = {job=true}, Type, Color }, with points <1m apart merged.
function Config_duty.BuildPoints()
  local points = {}
  local function add(pos, jobs, mType, color, size)
    for i = 1, #points do
      local p = points[i]
      local dx, dy, dz = p.x - pos.x, p.y - pos.y, p.z - pos.z
      if (dx * dx + dy * dy + dz * dz) < 1.0 then
        for j in pairs(jobs) do p.jobs[j] = true end
        return
      end
    end
    local set = {}
    for j in pairs(jobs) do set[j] = true end
    points[#points + 1] = { x = pos.x, y = pos.y, z = pos.z, jobs = set,
      Type = mType or 20, Color = color or Config_duty.Color, Size = size or Config_duty.Size }
  end
  for k, v in pairs(Config_duty.Zones) do
    if v.Pos then add(v.Pos, { [k] = true }) end
  end
  for _, v in ipairs(Config_duty.Locations) do
    add(v.Pos, v.job, v.Type, v.Color, v.Size)
  end
  return points
end

-- Is `job` (base name, without the "off" prefix) a job that can go on/off duty at all?
function Config_duty.IsDutyJob(job)
  if not job then return false end
  if Config_duty.Zones[job] then return true end
  for _, v in ipairs(Config_duty.Locations) do
    if v.job[job] then return true end
  end
  return false
end

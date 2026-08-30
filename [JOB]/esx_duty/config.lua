Config = {}
Config.Color = { r = 0, g = 255, b = 0 }
Config.Size = { x = 0.7, y = 0.7, z = 0.7 }
Config.Zones = {
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

Config.Webhooks = {
  police = "https://discord.com/api/webhooks/1351594068060147803/HF7USgv_tEpd5vmnyzz6yAQccPMJ21lXWi2GRfOZCi8gOasK_C4XC0PjEdoecszuhL6_",
  ambulance = "https://discord.com/api/webhooks/1351594449079111711/5flSOJHJ-NBengDg6_kU1junlxfMp00fL7MXd_opIpcTZ_4aRi2MlZYcfWnLf3KpzNb-",
  mechanic = "https://discord.com/api/webhooks/1351594683704541267/3GcyQVpaKGP9qtNXeaDrAKWworjAy3TlHjriPo0OEf8Hg58d29kwZJjPLXfRsNeYW8PB",
  sheriff = "https://discord.com/api/webhooks/1294855345348415560/vr2gCQfGahZ8gyJ73jIqgMhI4yXozB_5gVlWV-2WVf5wBcphR8QU8-ady4nzAOXmiiu_",
  taxi = "https://discord.com/api/webhooks/1351596286067085424/385vJnZym9ae_0dz6wYInlmaub-c5557N9qBvg6kNIaANX4RA7lFojI8QArmqO0PsNel",
  weazel = "https://discord.com/api/webhooks/1351597690483376265/UYKhRNRmbk3EM0qLthJ6LmTODPbNmPhGKEUEEDsS5t6VHhzecufbeHbwjexiRI7Ofs1l",
  fbi = "https://discord.com/api/webhooks/1351598126384943236/B8I_R_7tTjGgTF3wCFeku8U4pEVpvEFlur73qaG-AsBAWsDRY1uwm1zXky2QFiRADk44",
  mt = "https://discord.com/api/webhooks/1354116433759440996/jnAD8JKzeppib0svD6RF1CwfX_WGV3HWRjvVOafY5eCGdu1_9aBAnLiMpqje2VmcSiJw",

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

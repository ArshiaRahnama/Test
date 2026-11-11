Config = {}

---------------------------------------------------------------------------
-- General
---------------------------------------------------------------------------
Config.Item        = 'radio'   -- inventory item that opens the radio
Config.RequireItem = true      -- server also refuses channels to players without the item

Config.MinFrequency = 1        -- standard range
Config.MaxFrequency = 2500

Config.ToggleCooldown    = 3000   -- ms, E on/off
Config.FrequencyCooldown = 5000   -- ms, changing frequency / Shift+N channels
Config.PanicCooldown     = 59000  -- ms
Config.GPSCooldown       = 5000   -- ms
Config.GPSDuration       = 60000  -- ms blips stay on the map
Config.AlertDuration     = 60000  -- ms panic blip stays on the map

---------------------------------------------------------------------------
-- Who may use a radio (rule: no job / basic job and no gang = no radio)
---------------------------------------------------------------------------
Config.RestrictBasicJobs = true
Config.BasicJobs  = { nojob = true }
Config.NoGangNames = { [''] = true, nogang = true, none = true }
Config.GangMinGrade = 1           -- gang members need grade > this to use gang frequencies

Config.AllAccessJobs = { government = true }   -- may join every restricted frequency

---------------------------------------------------------------------------
-- Frequencies
-- Config.JobFrequencies: job -> frequencies that job may join.
-- Every frequency that appears here (or is in ReservedFrequencies) is PRIVATE,
-- every other frequency is public. Admins can edit access live with /radiomanager
-- (saved to access.json, which then replaces these defaults).
---------------------------------------------------------------------------
Config.JobFrequencies = {
    police     = { 1, 901, 900, 911 },
    sheriff    = { 2, 902, 900, 911 },
    fbi        = { 3, 904, 900, 911 },
    dadgostari = { 4, 912, 900, 911 },
    ambulance  = { 5, 905, 911 },
    artesh     = { 30, 911 },
    mechanic   = { 29, 906 },
    taxi       = { 36, 907 },
    weazel     = { 908 },
    mt         = { 903, 900 },
    cid        = { 909, 900 },
    cia        = { 910, 900 },
    marshal    = { 911, 900 },
    judge      = { 912, 900 },
    doa        = { 913, 900 },
}

Config.ReservedFrequencies = { from = 1, to = 20 }   -- locked unless a job lists them above

Config.FrequencyNames = {
    [1] = 'Police', [2] = 'Sheriff', [3] = 'FBI', [4] = 'Dadgostari', [5] = 'Ambulance',
    [29] = 'Mechanic', [30] = 'Artesh', [36] = 'Taxi',
    [900] = 'Joint', [911] = 'Shared',
}

-- Shift + 1..8 while the radio is ON: first entry = Shift+1, second = Shift+2 ...
Config.QuickChannels = {
    police     = { 1, 911, 901, 900 },
    sheriff    = { 2, 911, 902, 900 },
    fbi        = { 3, 911, 904, 900 },
    dadgostari = { 4, 911, 912, 900 },
    ambulance  = { 5, 911, 905 },
    government = { 5, 911 },
    artesh     = { 30, 911 },
    mechanic   = { 29, 906 },
    taxi       = { 36, 907 },
    weazel     = { 908 },
    mt         = { 903, 900 },
    cid        = { 909, 900 },
    cia        = { 910, 900 },
    marshal    = { 911, 900 },
    judge      = { 912, 900 },
    doa        = { 913, 900 },
}

---------------------------------------------------------------------------
-- Radio list (top-left), names, chat messages
---------------------------------------------------------------------------
Config.ShowNamesInList = true      -- false = "[id]" only (ids only)
Config.ShowSelfInList  = true      -- true = you also appear in your own list (handy for testing; false = others only)
Config.NameMaxLength   = 24
Config.ResetCustomNameOnExit = true

-- Jobs that do NOT get "joined / left the frequency" chat messages
Config.QuietJobs = {
    police = true, sheriff = true, mt = true, fbi = true, cid = true, cia = true,
    marshal = true, doa = true, judge = true, dadgostari = true,
}

-- Jobs that already have their own map blips (no teammate blips from the radio)
Config.NoBlipJobs = {
    police = true, sheriff = true, mt = true, fbi = true, cid = true, cia = true,
    marshal = true, doa = true, judge = true, dadgostari = true,
    ambulance = true, taxi = true, mechanic = true, weazel = true,
}

-- Jobs that use the "radio chatter" animation while transmitting (everyone else holds it to the ear like a phone)
Config.ChatterJobs = {
    police = true, sheriff = true, mt = true, fbi = true, cid = true, cia = true,
    marshal = true, doa = true, judge = true, dadgostari = true, ambulance = true, artesh = true,
}

---------------------------------------------------------------------------
-- Commands / admin
---------------------------------------------------------------------------
Config.AdminGroups = { superadmin = true, admin = true, _dev = true }   -- or ace: Unique_Radio.manage
Config.CheckFreqDistance = 2.0
Config.CheckFreqExpire   = 120000  -- ms

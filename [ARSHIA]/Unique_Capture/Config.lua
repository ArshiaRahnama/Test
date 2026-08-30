Config = {}

Config.KillersWebhook = GetConvar('unique_config_config_killerswebhook', '')
Config.GangsWebhook = GetConvar('unique_config_config_killerswebhook', '')

Config.EnableDetailedLogging = true
Config.LogUsername = "Unique Capture System"
Config.LogAvatarUrl = ""

Config.Webhooks = {
    RoundStart  = "",
    RoundEnd    = "",
    ZoneCapture = "",
    Kills       = "",
    Season      = "",
    Medals      = "",
    Admin       = "",
}

Config.getSharedObjectTrigger = "esx:getSharedObject"
Config.CaptureWorld = 50
Config.ReviveTrigger = "esx_ambulancejob:revivex"

Config.GangsTable = "gangs_data"
Config.GangsNameColumn = "gang_name"
Config.GangsBossColumn = "boss"
Config.GangsLogoColumn = "logo"
Config.DefaultGangLogo = "defaultlogo"

Config.GangLogoUrlTemplate = "nui://gangmenu/img/logos/%s.png"

Config.UsersTable = "users"
Config.UsersIdentifierColumn = "identifier"
Config.UsersProfilePicColumn = "Profile_Pic"

Config.PlayerPhotoUrlTemplate = "%s"
Config.DefaultPlayerPhoto = "imgs/no_photo.png"
Config.SplitZonesKillLog = false

Config.CommandPerm = 10
Config.JoinCaptureCommand = "joinCap"
Config.StartCaptureCommand = "startCap"
Config.EndCaptureCommand = "endCap"
Config.EditCaptureCommand = "editCap"
Config.LeaveCaptureCommand = "leaveCap"
Config.ReSpawnCaptureCommand = "reCap"
Config.HistoryCommand = "captureHistory"
Config.StatsCommand = "captureStats"

Config.AllTimeScoreWeights = {
    Kills = 2,
    GangPoints = 1,
    DeathPenalty = 1
}
Config.AllTimeRefreshInterval = 15

Config.RankThresholds = {
    {Name = "Bronze", Min = 0},
    {Name = "Silver", Min = 50},
    {Name = "Gold", Min = 150},
    {Name = "Legend", Min = 400},
}

Config.LeaveZonePenaltySeconds = 180

Config.SeasonResetCommand = "captureSeasonReset"
Config.SeasonHistoryCommand = "captureSeasons"
Config.SeasonAutoResetDays = 30

Config.BackupBeforeSeasonReset = true
Config.BackupFolder = "backups"

Config.zToAutoTeleport = 300.0
Config.ZoneSize = 150.0
Config.ParchuteSpawnHeight = 700.0
Config.ParchuteSpawnDistance = {min = 50.0, max = 100.0}
Config.OutOfZoneDamage = 15
Config.TimeToCaptureZone = 10

Config.ZoneMarkerColor = {
    Default = {R = 0, G = 255, B = 0, Alpha = 60},
    Owned = {R = 0, G = 255, B = 0, Alpha = 60}
}
Config.CapturePointMarkerColor = {
    Default = {R = 255, G = 0, B = 0, Alpha = 20},
    Owned = {R = 255, G = 255, B = 0, Alpha = 20}
}

Config.ThemeCommand = "captureTheme"
Config.ActiveTheme = "Default"
Config.Themes = {
    Default = {
        Zone = {Default = {R = 0, G = 255, B = 0, Alpha = 60}, Owned = {R = 0, G = 255, B = 0, Alpha = 60}},
        Point = {Default = {R = 255, G = 0, B = 0, Alpha = 20}, Owned = {R = 255, G = 255, B = 0, Alpha = 20}},
    },
    Halloween = {
        Zone = {Default = {R = 255, G = 100, B = 0, Alpha = 70}, Owned = {R = 128, G = 0, B = 200, Alpha = 70}},
        Point = {Default = {R = 255, G = 60, B = 0, Alpha = 30}, Owned = {R = 150, G = 0, B = 220, Alpha = 30}},
    },
    Christmas = {
        Zone = {Default = {R = 220, G = 0, B = 0, Alpha = 65}, Owned = {R = 0, G = 200, B = 60, Alpha = 65}},
        Point = {Default = {R = 220, G = 0, B = 0, Alpha = 25}, Owned = {R = 255, G = 255, B = 255, Alpha = 25}},
    },
    Bloodmoon = {
        Zone = {Default = {R = 180, G = 0, B = 0, Alpha = 80}, Owned = {R = 255, G = 0, B = 0, Alpha = 80}},
        Point = {Default = {R = 150, G = 0, B = 0, Alpha = 35}, Owned = {R = 255, G = 0, B = 0, Alpha = 35}},
    },
}

Config.ZoneBlip = {
    Color = 37,
    Alpha = 50
}
Config.CapturePointBlip = {
    Model = 310,
    Color = 1,
}

Config.DefaultZones = {
    ["Bime"] = vector3(-1085.34, -253.7799, 37.76331),
    ["Shekar Gah"] = {x = -673.389, y = 5646.052, z = 30.31661},
    ["Mineri"] = vector3(2954.27, 2787.458, 41.49114),
    ["Sherkat Naft"] = vector3(2751.597, 1551.137, 24.50097),
    ["Bandar"] = vector3(959.5748, -3097.387, 5.90076),
    ["Paleto"] = vector3(73.2504, 6573.741, 28.4357),
    ["Airport"] = vector3(-898.6442, -2491.075, 14.54905),
}
Config.DefaultTime = 60

Config.UsePersonalWeapons = true
Config.Weapons = {
    {
        Names = {"WEAPON_CARBINERIFLE","WEAPON_PISTOL50"},
        access = nil
    },
    {
        Names = {"WEAPON_COMBATPISTOL","WEAPON_APPISTOL"},
        access = nil
    },
    {
        Names = {"WEAPON_MACHINEPISTOL","WEAPON_HEAVYPISTOL"},
        access = "vip"
    },
    {
        Names = {"WEAPON_MILITARYRIFLE","WEAPON_PISTOL_MK2"},
        access = "vip+"
    },
    {
        Names = {"WEAPON_PISTOL_MK2","WEAPON_SNSPISTOL_MK2"},
        access = "vip+"
    }
}

Config.DefaultArmor = 100
Config.UseGroupForArmor = false
Config.Armor = {
    ["user"] = 50,
    ["vip"] = 70,
    ["vip+"] = 100,
}

Config.EnableDryRun = true
Config.DryRunCommand = "captureDryRun"

Config.EnableSeasonWarning = true
Config.SeasonWarningHoursBefore = 24

Config.EnableAdminRateLimit = true
Config.AdminCommandCooldown = 5

Config.EnableHealthCheck = true
Config.HealthCheckCommand = "captureHealth"

Config.EnableExternalZonesFile = false
Config.ZonesFileName = "zones.json"
Config.ExportZonesCommand = "captureExportZones"
Config.ImportZonesCommand = "captureImportZones"

Config.EnablePublicAPI = false
Config.PublicAPIPath = "/uniquecapture/status"

Config.EnableLeagueMode = false
Config.StandingsCommand = "captureStandings"
Config.EnablePlayoffs = false
Config.PlayoffResultCommand = "capturePlayoffResult"

Config.EnableScarcityEngine = true
Config.ScarceMedalName = "Legend Medal"
Config.ScarceMedalRank = "Legend"
Config.ScarceMedalSupplyPerSeason = 100
Config.ScarcityStatusCommand = "captureMedals"
Config.MyMedalsCommand = "mymedals"

Config.DashboardCommand = "capture"

Config.EnableHallOfFame = true
Config.HallOfFameInactivityDays = 60
Config.HallOfFameCommand = "hallOfFame"

Config.EnableAcademy = true
Config.AcademyCommand = "captureAcademy"
Config.AcademyLeaveCommand = "leaveAcademy"
Config.AcademyWorld = 51
Config.AcademyCoord = vector3(0.0, 0.0, 72.0)
-- How many NPCs are actively hunting you scales with total kills — starts
-- small (no instant swarm) and ramps up the more you clear, but is hard-capped.
Config.AcademyStartNPCCount = 1   -- active NPCs when you first walk in
Config.AcademyMaxNPCCount = 4     -- absolute cap, no matter how many kills you rack up
Config.AcademyNPCCountStep = 8    -- +1 active NPC every this many total kills
Config.AcademyNPCModel = "g_m_y_lost_01"
Config.AcademyWeapon = "WEAPON_CARBINERIFLE"
Config.AcademyKillCheckInterval = 500

Config.AcademyDifficultyStep = 5
Config.AcademyBaseAccuracy = 20
Config.AcademyMaxAccuracy = 80
Config.AcademyBaseArmor = 0
Config.AcademyMaxArmor = 100

-- Your max health is boosted while training (restored to normal on exit) and
-- never allowed to drop below this % of it — NPCs can genuinely never finish
-- you off, no matter how much they land on you.
Config.AcademyPlayerMaxHealth = 500
Config.AcademyDefaultPlayerMaxHealth = 200 -- vanilla GTA default, restored when you leave
Config.AcademyHealthFloorPercent = 0.12

Config.AcademyEntryPoints = {
    vector4(441.9, -981.4, 30.69, 90.0), -- outside Mission Row PD — real, solid ground, easy to find
}
Config.AcademyEntryRadius = 10.0
Config.AcademyInstructorPedModel = "s_m_y_cop_01"

Config.AcademyBlip = {
    Sprite = 267,       -- shooting range icon
    Color = 5,          -- yellow
    Scale = 0.85,
    Display = 4,
    ShortRange = true,
    Label = "Training Academy",
}

Config.AcademyTutorialPointOffset = vector3(10.0, 10.0, 0.0)

-- Safe zone is centered on the exact spot you spawn at when you enter (Config.AcademyCoord),
-- so you land inside it and NPCs leave you alone until you actually walk out of it.
Config.AcademySafeZoneOffset = vector3(0.0, 0.0, 0.0)
Config.AcademySafeZoneRadius = 8.0

Config.AcademyMilestones = {
    {Kills = 100,  Title = "Sharpshooter"},
    {Kills = 500,  Title = "Marksman Elite"},
    {Kills = 1000, Title = "Academy Legend"},
}

Config.AcademyTimeLimitMinutes = 20
Config.AcademyReminderIntervalMinutes = 20

Config.EnableSpectate = true
Config.SpectateCommand = "captureSpectate"
Config.SpectateLeaveCommand = "leaveSpectate"
Config.SpectateSpeed = 1.0
-- xPlayer.permission_level must be ABOVE this to use /captureSpectate.
-- Defaults to the same threshold as the other admin commands (Config.CommandPerm).
-- Set it lower (e.g. 0) to let everyone spectate again.
Config.SpectatePermLevel = Config.CommandPerm

-- Locked-on ("watch this player") chase-cam settings for Spectator Mode.
Config.SpectateLockDistance = 4.5
Config.SpectateLockHeight = 0.7
Config.SpectateVitalsRefreshMs = 300
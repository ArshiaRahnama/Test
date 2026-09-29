CapConfig = {}

CapConfig.KillersWebhook = GetConvar('unique_config_config_killerswebhook', '')
CapConfig.GangsWebhook = GetConvar('unique_config_config_killerswebhook', '')

CapConfig.EnableDetailedLogging = true
CapConfig.LogUsername = "Unique Capture System"
CapConfig.LogAvatarUrl = ""

CapConfig.Webhooks = {
    RoundStart  = "",
    RoundEnd    = "",
    ZoneCapture = "",
    Kills       = "",
    Season      = "",
    Medals      = "",
    Admin       = "",
}

CapConfig.getSharedObjectTrigger = "esx:getSharedObject"
CapConfig.CaptureWorld = 50
CapConfig.ReviveTrigger = "esx_ambulancejob:revivex"

CapConfig.GangsTable = "gangs_data"
CapConfig.GangsNameColumn = "gang_name"

-- روی این سرور جدول gangs_data ستون لوگو/عکس نداره (فقط ستون flag داره که
-- برای مارکر فیزیکی پرچم توی دنیای بازیه، نه عکس). برای همین این لوکاپ
-- غیرفعاله و همیشه از DefaultGangLogo استفاده میشه - دیگه خطای
-- "Unknown column 'logo'" تکرار نمیشه. اگه بعداً یه ستون واقعی برای
-- لوگو/عکس گنگ اضافه کردی، اینو true کن و اسم ستونش رو تو
-- GangsLogoColumn بذار.
CapConfig.EnableGangLogoLookup = false
CapConfig.GangsBossColumn = "boss"
CapConfig.GangsLogoColumn = "logo"
CapConfig.DefaultGangLogo = "defaultlogo"

CapConfig.GangLogoUrlTemplate = "nui://gangmenu/img/logos/%s.png"

CapConfig.UsersTable = "users"
CapConfig.UsersIdentifierColumn = "identifier"
CapConfig.UsersProfilePicColumn = "Profile_Pic"

CapConfig.PlayerPhotoUrlTemplate = "%s"
CapConfig.DefaultPlayerPhoto = "imgs/no_photo.png"
CapConfig.SplitZonesKillLog = false

CapConfig.CommandPerm = 10
CapConfig.JoinCaptureCommand = "joinCap"
CapConfig.StartCaptureCommand = "startCap"
CapConfig.EndCaptureCommand = "endCap"
CapConfig.EditCaptureCommand = "editCap"
CapConfig.LeaveCaptureCommand = "leaveCap"
CapConfig.ReSpawnCaptureCommand = "reCap"
CapConfig.HistoryCommand = "captureHistory"
CapConfig.StatsCommand = "captureStats"

CapConfig.AllTimeScoreWeights = {
    Kills = 2,
    GangPoints = 1,
    DeathPenalty = 1
}
CapConfig.AllTimeRefreshInterval = 15

CapConfig.RankThresholds = {
    {Name = "Bronze", Min = 0},
    {Name = "Silver", Min = 50},
    {Name = "Gold", Min = 150},
    {Name = "Legend", Min = 400},
}

CapConfig.LeaveZonePenaltySeconds = 180

CapConfig.SeasonResetCommand = "captureSeasonReset"
CapConfig.SeasonHistoryCommand = "captureSeasons"
CapConfig.SeasonAutoResetDays = 30

CapConfig.BackupBeforeSeasonReset = true
CapConfig.BackupFolder = "backups"

CapConfig.zToAutoTeleport = 300.0
CapConfig.ZoneSize = 150.0
CapConfig.ParchuteSpawnHeight = 700.0
CapConfig.ParchuteSpawnDistance = {min = 50.0, max = 100.0}
CapConfig.OutOfZoneDamage = 15
CapConfig.TimeToCaptureZone = 10

CapConfig.ZoneMarkerColor = {
    Default = {R = 0, G = 255, B = 0, Alpha = 60},
    Owned = {R = 0, G = 255, B = 0, Alpha = 60}
}
CapConfig.CapturePointMarkerColor = {
    Default = {R = 255, G = 0, B = 0, Alpha = 20},
    Owned = {R = 255, G = 255, B = 0, Alpha = 20}
}

CapConfig.ThemeCommand = "captureTheme"
CapConfig.ActiveTheme = "Default"
CapConfig.Themes = {
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

CapConfig.ZoneBlip = {
    Color = 37,
    Alpha = 50
}
CapConfig.CapturePointBlip = {
    Model = 310,
    Color = 1,
}

CapConfig.DefaultZones = {
    ["Bime"] = vector3(-1085.34, -253.7799, 37.76331),
    ["Shekar Gah"] = {x = -673.389, y = 5646.052, z = 30.31661},
    ["Mineri"] = vector3(2954.27, 2787.458, 41.49114),
    ["Sherkat Naft"] = vector3(2751.597, 1551.137, 24.50097),
    ["Bandar"] = vector3(959.5748, -3097.387, 5.90076),
    ["Paleto"] = vector3(73.2504, 6573.741, 28.4357),
    ["Airport"] = vector3(-898.6442, -2491.075, 14.54905),
}
CapConfig.DefaultTime = 60

CapConfig.UsePersonalWeapons = true
CapConfig.Weapons = {
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

CapConfig.DefaultArmor = 100
CapConfig.UseGroupForArmor = false
CapConfig.Armor = {
    ["user"] = 50,
    ["vip"] = 70,
    ["vip+"] = 100,
}

CapConfig.EnableDryRun = true
CapConfig.DryRunCommand = "captureDryRun"

CapConfig.EnableSeasonWarning = true
CapConfig.SeasonWarningHoursBefore = 24

CapConfig.EnableAdminRateLimit = true
CapConfig.AdminCommandCooldown = 5

CapConfig.EnableHealthCheck = true
CapConfig.HealthCheckCommand = "captureHealth"

CapConfig.EnableExternalZonesFile = false
CapConfig.ZonesFileName = "zones.json"
CapConfig.ExportZonesCommand = "captureExportZones"
CapConfig.ImportZonesCommand = "captureImportZones"

CapConfig.EnablePublicAPI = false
CapConfig.PublicAPIPath = "/uniquecapture/status"

CapConfig.EnableLeagueMode = false
CapConfig.StandingsCommand = "captureStandings"
CapConfig.EnablePlayoffs = false
CapConfig.PlayoffResultCommand = "capturePlayoffResult"

CapConfig.EnableScarcityEngine = true
CapConfig.ScarceMedalName = "Legend Medal"
CapConfig.ScarceMedalRank = "Legend"
CapConfig.ScarceMedalSupplyPerSeason = 100
CapConfig.ScarcityStatusCommand = "captureMedals"
CapConfig.MyMedalsCommand = "mymedals"

CapConfig.DashboardCommand = "capture"

CapConfig.EnableHallOfFame = true
CapConfig.HallOfFameInactivityDays = 60
CapConfig.HallOfFameCommand = "hallOfFame"

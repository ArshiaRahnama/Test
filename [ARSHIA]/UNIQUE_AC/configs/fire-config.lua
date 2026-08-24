

UNIQUE_AC              = {}

UNIQUE_AC.Version      = "9.6.0"

UNIQUE_AC.ServerConfig = {
    Name  = "YOUR SERVER NAME",

    Port  = "30120",

    Linux = false
}

UNIQUE_AC.Branding = {
    PanelName     = "UNIQUE_AC",
    FooterCredit  = "Developed by Arshia · arshiahub.ir",
    BuildLabel    = ""
}

UNIQUE_AC.ACE = {
    Enable = false,
    Admin = "UNIQUE_AC.Admin",
    Whitelist = "UNIQUE_AC.Whitelist",
    Unban = "UNIQUE_AC.Unban"
}

UNIQUE_AC.ChatSettings             = {
    Enable      = true,
    PrivateWarn = true
}

UNIQUE_AC.ScreenShot               = {
    Enable  = true,
    Format  = "PNG",
    Quality = 1
}

UNIQUE_AC.EvidenceBurst = {
    Enable      = true,
    ShotCount   = 4,
    IntervalMs  = 1500
}

UNIQUE_AC.AimbotWatch = {
    Enable            = true,
    MinSampleHits     = 8,
    HeadshotRatio     = 0.75,
    SnapAngleDegrees  = 35.0,
    SnapWindowMs      = 150,
    NotifyAdminsOnFlag = true
}

UNIQUE_AC.BehavioralClustering = {
    Enable      = true,
    WindowMs    = 300000,
    MinPlayers  = 2
}

UNIQUE_AC.ResourceMonitor = {
    Enable          = true,
    BaselineDelayMs = 25000,
    NotifyAdminsOnFlag = true,
    IgnoreList      = {}
}

UNIQUE_AC.ConfigBackup = {
    Enable = true,
    Keep   = 20
}

UNIQUE_AC.KnownConflicts = {
    Enable = true,
    Resources = {
        "esx_aduty",
    }
}

UNIQUE_AC.Connection               = {
    AntiBlackListName = true,
    AntiVPN           = false,
    HideIP            = true,

    UseDeferrals      = true,
    DeferralMode      = "card",
    DeferralDelayMs   = 1200,
    DeferralStepMs    = 120,
    AdaptiveCard      = true,

    ShowConnectUI     = true,
    ShowProblemCard   = true,
    ProblemOnlyMode   = false,

    PresentCardOnce   = false,
    PresentCardHoldMs = 900,
    CardTitle         = "UNIQUE_AC SECURITY",
    VisualStepMs      = 320,
    ConnectHoldMs     = 1200
}

UNIQUE_AC.ServerRuntime            = {
    EntityCreatedMonitor = false,
    EntityCreatedDelayMs = 750
}

UNIQUE_AC.Detection = {
    RequirePlayerSpawned = true,
    RequireFrameworkLoaded = true,
    ReadyMaxWaitMs = 120000,
    MinimumClientReadyMs = 12000,
    ResourceRestartAssumeSpawnedMs = 8000,

    SpawnGraceMs = 20000,
    PostSpawnSettleMs = 18000,
    PostReadyGraceMs = 20000,
    FrameworkLoadGraceMs = 12000,
    RespawnGraceMs = 15000,
    PedChangeGraceMs = 12000,
    CameraGraceMs = 3500,
    GodmodeAfterReadyMs = 12000,

    EvidenceThreshold = 3,
    EvidenceWindowMs = 15000,
    GodmodeSamples = 6,
    ClientReportCooldownMs = 10000,
    ServerReportWindowMs = 10000,
    ServerReportLimit = 6
}

UNIQUE_AC.Message                  = {
    Kick = "",
    Ban  = "",
}

UNIQUE_AC.Language = "en"

UNIQUE_AC.Locales = {
    en = {
        kick = "⚡️ You've been kicked from the server protection by UNIQUE_AC®. Avoid cheating on this server.",
        ban = "⛔️ You've been banned from the server. Please create a support ticket for assistance.",
        quarantine = "You have been flagged for a security review. An admin will check your case shortly.",
        quarantine_released = "You have been released from security review. Play fair.",
        status_good = "Good standing",
        status_mid = "Under light review — nothing to worry about, just keep playing fair",
        status_low = "Flagged — please avoid anything that looks like cheating",
    },
    fa = {
        kick = "⚡️ شما به دلیل نقض قوانین امنیتی UNIQUE_AC از سرور اخراج شدید. از تقلب پرهیز کنید.",
        ban = "⛔️ شما از سرور بن شدید. برای پیگیری یک تیکت پشتیبانی باز کنید.",
        quarantine = "حساب شما برای بررسی امنیتی علامت‌گذاری شد. یک ادمین به‌زودی بررسی می‌کند.",
        quarantine_released = "شما از بررسی امنیتی آزاد شدید. منصفانه بازی کنید.",
        status_good = "وضعیت خوب",
        status_mid = "در حال بررسی سبک — نگران نباشید، فقط منصفانه بازی کنید",
        status_low = "علامت‌گذاری شده — از هر کاری که شبیه تقلب باشد پرهیز کنید",
    },
    ar = {
        kick = "⚡️ تم طردك من حماية الخادم بواسطة UNIQUE_AC. تجنب الغش في هذا الخادم.",
        ban = "⛔️ تم حظرك من الخادم. يرجى فتح تذكرة دعم للمساعدة.",
        quarantine = "تم وضع علامة على حسابك للمراجعة الأمنية. سيقوم المشرف بمراجعة حالتك قريبًا.",
        quarantine_released = "تم إطلاق سراحك من المراجعة الأمنية. العب بنزاهة.",
        status_good = "وضع جيد",
        status_mid = "قيد المراجعة الخفيفة — لا داعي للقلق، فقط استمر باللعب بنزاهة",
        status_low = "تم وضع علامة — يرجى تجنب أي شيء يبدو كالغش",
    },
}

UNIQUE_AC.AdminMenu                = {
    Enable         = true,
    MenuPunishment = "BAN"
}

UNIQUE_AC.FrameworkPermission = {
    Enable            = true,
    Table             = "users",
    IdentifierColumn  = "identifier",
    PermissionColumn  = "permission_level",
    MinLevel          = 1
}

UNIQUE_AC.AntiHealthHack           = true
UNIQUE_AC.MaxHealth                = 200
UNIQUE_AC.HealthPunishment         = "BAN"

UNIQUE_AC.AntiArmorHack            = true
UNIQUE_AC.MaxArmor                 = 100
UNIQUE_AC.ArmorPunishment          = "BAN"

UNIQUE_AC.AntiBlacklistTasks       = false
UNIQUE_AC.TasksPunishment          = "BAN"

UNIQUE_AC.AntiBlacklistAnims       = true
UNIQUE_AC.AnimsPunishment          = "BAN"

UNIQUE_AC.AntiInfinityAmmo         = true

UNIQUE_AC.AntiSpectate             = true
UNIQUE_AC.SpactatePunishment       = "BAN"
UNIQUE_AC.SpectatePunishment       = UNIQUE_AC.SpactatePunishment

UNIQUE_AC.AntiBlackListWeapon      = true
UNIQUE_AC.AntiAddWeapon            = false
UNIQUE_AC.AntiRemoveWeapon         = false
UNIQUE_AC.WeaponPunishment         = "BAN"

UNIQUE_AC.AntiGodMode              = true
UNIQUE_AC.GodPunishment            = "BAN"

UNIQUE_AC.AntiInvisible            = true
UNIQUE_AC.InvisiblePunishment      = "KICK"

UNIQUE_AC.AntiChangeSpeed          = true
UNIQUE_AC.SpeedPunishment          = "KICK"

UNIQUE_AC.AntiFreeCam              = false
UNIQUE_AC.CamPunishment            = "BAN"

UNIQUE_AC.AntiRainbowVehicle       = true
UNIQUE_AC.RainbowPunishment        = "BAN"

UNIQUE_AC.AntiPlateChanger         = true
UNIQUE_AC.AntiBlackListPlate       = true
UNIQUE_AC.PlatePunishment          = "BAN"

UNIQUE_AC.AntiNightVision          = true
UNIQUE_AC.AntiThermalVision        = true
UNIQUE_AC.VisionPunishment         = "BAN"

UNIQUE_AC.AntiSuperJump            = true
UNIQUE_AC.JumpPunishment           = "BAN"

UNIQUE_AC.AntiTeleport             = true
UNIQUE_AC.MaxFootDistance          = 200
UNIQUE_AC.MaxVehicleDistance       = 600
UNIQUE_AC.TeleportPunishment       = "BAN"

UNIQUE_AC.AntiNoclip               = false
UNIQUE_AC.NoclipPunishment         = "KICK"

UNIQUE_AC.AntiPedChanger           = true
UNIQUE_AC.PedChangePunishment      = "BAN"

UNIQUE_AC.AntiInfiniteStamina      = false
UNIQUE_AC.InfinitePunishment       = "WARN"

UNIQUE_AC.AntiTinyPed              = true
UNIQUE_AC.PedFlagPunishment        = "BAN"

UNIQUE_AC.AntiSuicide              = false
UNIQUE_AC.SuicidePunishment        = "WARN"

UNIQUE_AC.AntiPickupCollect        = false
UNIQUE_AC.PickupPunishment         = "BAN"

UNIQUE_AC.AntiSpamChat             = true
UNIQUE_AC.MaxMessage               = 10
UNIQUE_AC.CoolDownSec              = 3
UNIQUE_AC.ChatPunishment           = "BAN"

UNIQUE_AC.AntiBlackListCommands    = true
UNIQUE_AC.CMDPunishment            = "BAN"

UNIQUE_AC.AntiWeaponDamageChanger  = true
UNIQUE_AC.DamagePunishment         = "BAN"

UNIQUE_AC.AntiBlackListWord        = true
UNIQUE_AC.WordPunishment           = "KICK"

UNIQUE_AC.AntiBringAll             = false
UNIQUE_AC.BringAllPunishment       = "BAN"

UNIQUE_AC.AntiBlackListTrigger     = false
UNIQUE_AC.AntiSpamTrigger          = true
UNIQUE_AC.TriggerPunishment        = "BAN"

UNIQUE_AC.AntiClearPedTasks        = false
UNIQUE_AC.MaxClearPedTasks         = 5
UNIQUE_AC.CPTPunishment            = "BAN"

UNIQUE_AC.AntiTazePlayers          = true
UNIQUE_AC.MaxTazeSpam              = 3
UNIQUE_AC.TazePunishment           = "KICK"

UNIQUE_AC.AntiInject               = false
UNIQUE_AC.InjectPunishment         = "BAN"

UNIQUE_AC.AntiExplosionSpam        = true
UNIQUE_AC.MaxExplosion             = 10
UNIQUE_AC.ExplosionSpamPunishment  = "BAN"

UNIQUE_AC.AntiBlackListObject      = true
UNIQUE_AC.AntiBlackListPed         = true
UNIQUE_AC.AntiBlackListBuilding    = true
UNIQUE_AC.AntiBlackListVehicle     = true
UNIQUE_AC.EntityPunishment         = "BAN"

UNIQUE_AC.AntiSpamVehicle          = true
UNIQUE_AC.MaxVehicle               = 10

UNIQUE_AC.AntiSpamPed              = true
UNIQUE_AC.MaxPed                   = 4

UNIQUE_AC.AntiSpamObject           = true
UNIQUE_AC.MaxObject                = 15

UNIQUE_AC.SpamPunishment           = "KICK"

UNIQUE_AC.AntiChangePerm           = false
UNIQUE_AC.PermPunishment           = "BAN"

UNIQUE_AC.AntiPlaySound            = true
UNIQUE_AC.SoundPunishment          = "KICK"

UNIQUE_AC.AntiWeaponComponent      = true
UNIQUE_AC.ComponentPunishment      = "BAN"

UNIQUE_AC.AntiUnderground          = true
UNIQUE_AC.UndergroundTolerance     = 6.0
UNIQUE_AC.UndergroundPunishment    = "KICK"

UNIQUE_AC.UndergroundSafeZones     = {}

UNIQUE_AC.AntiVehicleGodMode       = true
UNIQUE_AC.VehicleGodPunishment     = "BAN"

UNIQUE_AC.AntiMacroFire            = true
UNIQUE_AC.MacroFirePunishment      = "KICK"
UNIQUE_AC.MacroFireMinShots        = 6
UNIQUE_AC.MacroFireMaxVarianceMs   = 9

UNIQUE_AC.AimbotPunishment         = "KICK"

UNIQUE_AC.TrustScore = {
    Enable        = true,
    Start         = 100,
    DeductWeight  = 20,
    RecoverOnRelease = 60
}

UNIQUE_AC.SandboxMode = {
    Enable        = false,
    NotifyAdmins  = true
}

UNIQUE_AC.PunishmentLadder = {
    Enable = true,
    Steps = {
        { threshold = 70, action = "WARN", message = "Your recent activity looks suspicious. Play fair — further flags may get you kicked or reviewed." },
        { threshold = 40, action = "KICK", message = "Kicked as a precaution due to repeated suspicious activity. You may rejoin." },
    }
}

UNIQUE_AC.Quarantine = {
    Enable = true
}

UNIQUE_AC.Integrity = {
    Enable       = true,
    IntervalMs   = 300000,
    Files        = {
        "src/fire-server.lua",
        "src/fire-client.lua",
        "src/fire-menu.lua",
        "configs/fire-config.lua"
    }
}

UNIQUE_AC.PersistentTrust = {
    Enable   = true,
    SaveEveryMs = 60000
}

UNIQUE_AC.PlayerTransparency = {
    Enable  = true,
    Command = "mystatus"
}

UNIQUE_AC.TrustRecognition = {
    Enable    = true,
    Threshold = 90
}

UNIQUE_AC.RiskScore = {
    Enable              = true,
    WeightLowTrust      = 0.45,
    WeightFlagCount     = 6,
    WeightQuarantine    = 12,
    WeightNewAccount    = 15,
    NewAccountHours     = 6,
    WeightRapidReconnect = 10,
    RapidReconnectWindowMs = 120000
}

UNIQUE_AC.PlayerNotes = {
    Enable = true,
    MaxLength = 500
}

UNIQUE_AC.AdminLog = {
    Enable = true,
    Keep   = 500
}

UNIQUE_AC.ConfirmBan = {
    Enable = true
}

UNIQUE_AC.Appeals = {
    Enable = true,
    NotifyAdminsOnNew = true
}

UNIQUE_AC.CentralHub = {
    Enable              = false,
    URL                 = "https://your-domain.example/central-hub",
    LicenseKey          = "",
    ServerName          = "",
    HeartbeatIntervalMs = 60000,
    NotifyOnQuarantine  = true,
    ShareBans           = false,
    ShareHeatmap        = false
}

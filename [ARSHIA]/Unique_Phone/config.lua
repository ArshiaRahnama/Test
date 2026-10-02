Config = {}

-- EXPANSION: the in-game RP phone number (used for contacts/calls/
-- WhatsApp/Twitter within Unique_Phone) now looks like a real Iranian
-- mobile number instead of a generic "052-XXXXXXXX" placeholder — pick
-- from real Iranian mobile operator prefixes for immersion. This is
-- SEPARATE from the real phone number players type into Unique_Login for
-- SMS verification — that one must stay a real, working number and is
-- never touched here.
Config.PhoneNumberPrefixes = {
    "0911", "0912", "0913", "0914", "0915", "0916", "0917", "0918", "0919", -- Hamrah-e Avval
    "0901", "0902", "0903", "0905",                                        -- Hamrah-e Avval (newer)
    "0930", "0933", "0935", "0936", "0937", "0938", "0939",                -- Irancell
    "0920", "0921", "0922",                                                -- RighTel
}
Config.RepeatTimeout = 500
Config.CallRepeats = 120
Config.OpenPhone = 288

-- EXPANSION: single source of truth for "who counts as Law Enforcement /
-- Department of Justice" — matches the same 3-organization split used in
-- the Services app (html/js/polices.js JOB_CATEGORIES). Used to:
--   1. Gate the MEOS app icon so only these jobs see it (client, app.js)
--   2. Decide who gets a real MEOS alert pushed when a Services dispatch
--      goes out (server, SendJobMessage)
-- Loaded on both client and server (config.lua is in both script lists).
Config.MeosAccessJobs = {
    "police", "sheriff", "mt",                          -- Law Enforcement
    "fbi", "cid", "cia", "marshal", "judge", "doa",      -- Department Of Justice
}

Config.Language = 'en'
Config.webhooksscreenshot = "https://discord.com/api/webhooks/1324462146993520752/-m1nDasTidW9-WDKDCJGQ-dy_D5mEwyb65zE3Xk4wVVyrqKm_YmtSvqjC_NIAbWYGep6"
Config.Tokovoip = false
Config.Job = ''
Config.UseESXLicense = true
Config.UseESXBilling = true

Config.Languages = {
    ['en'] = {
        ["NO_VEHICLE"] = "Hich vasile naghliyei dar atrof nist!",
        ["NO_ONE"] = "Hich kasi dar atrof nist!",
        ["ALLFIELDS"] = "Hame field-ha bayad por shavand!",

        ["RACE_TITLE"] = "Mosabeghe",

        ["WHATSAPP_TITLE"] = "Whatsapp",
        ["WHATSAPP_NEW_MESSAGE"] = "Payame jadid az",
        ["WHATSAPP_MESSAGE_TOYOU"] = "Payame jadid darid",
        ["WHATSAPP_LOCATION_SET"] = "Moghiyat tanzim shod!",
        ["WHATSAPP_SHARED_LOCATION"] = "Moghiyat be eshterak gozashte shod",
        ["WHATSAPP_BLANK_MSG"] = "Nemitooni payam khali ersal koni!",

        ["MAIL_TITLE"] = "Email",
        ["MAIL_NEW"] = "Shoma ye email jadid daryaft kardid az: ",

        ["ADVERTISEMENT_TITLE"] = "Safahat Zard",
        ["ADVERTISEMENT_NEW"] = "Ye agahi jadid dar safahat zard montasher shod!",
        ["ADVERTISEMENT_EMPY"] = "Bayad ye payam vared konid!",

        ["TWITTER_TITLE"] = "Twitter",
        ["TWITTER_NEW"] = "Tweet jadid",
        ["TWITTER_POSTED"] = "Tweet ersal shod!",
        ["TWITTER_GETMENTIONED"] = "Shoma dar ye tweet mention shodid!",
        ["MENTION_YOURSELF"] = "Nemitooni khodet ro mention koni!",
        ["TWITTER_ENTER_MSG"] = "Bayad ye payam vared koni!",

        ["PHONE_DONT_HAVE"] = "Shoma goshi nadarid!",
        ["PHONE_TITLE"] = "Rahnama",
        ["PHONE_CALL_END"] = "Tamas payan yaft",
        ["PHONE_NOINCOMING"] = "Hich tamas voroodi nadarid!",
        ["PHONE_STARTED_ANON"] = "Ye tamas nashenas aghaz kardid!",
        ["PHONE_BUSY"] = "Shoma dar hal hazer mashghool hastid!",
        ["PHONE_PERSON_TALKING"] = "In shakhs dar hal sohbat hast!",
        ["PHONE_PERSON_UNAVAILABLE"] = "In shakhs dar dastres nist!",
        ["PHONE_YOUR_NUMBER"] = "Nemitooni be khodet zang bezani!",
        ["PHONE_MSG_YOURSELF"] = "Nemitooni be khodet payam bedi!",

        ["CONTACTS_REMOVED"] = "In mokhatab hazf shod!",
        ["CONTACTS_NEWSUGGESTED"] = "Ye mokhatab pishnahadi jadid dari!",
        ["CONTACTS_EDIT_TITLE"] = "Virayesh Mokhatab",
        ["CONTACTS_ADD_TITLE"] = "Rahnam",

        ["BANK_TITLE"] = "Bank",
        ["BANK_DONT_ENOUGH"] = "Shoma pool kafi nadarid!",
        ["BANK_NOIBAN"] = "Hich IBAN baraye in shakhs sabt nashode ast!",

        ["CRYPTO_TITLE"] = "Crypto",

        ["GPS_SET"] = "Moghiyat GPS tanzim shod: ",

        ["NUI_SYSTEM"] = "System",
        ["NUI_NOT_AVAILABLE"] = "Dar dastres nist!",
        ["NUI_MYPHONE"] = "Shomare telefon",
        ["NUI_INFO"] = "Ettela'at",

        ["SETTINGS_TITLE"] = "Tanzimat",
        ["PROFILE_SET"] = "Aks profile tanzim shod!",
        ["POFILE_DEFAULT"] = "Aks profile be halat pishfarz bazneshani shod!",
        ["BACKGROUND_SET"] = "Paszamine tanzim shod!",

        ["MEOS_TITLE"] = "MEOS",
        ["MEOS_CLEARED"] = "Hame notification-ha hazf shodand!",
        ["MEOS_GPS"] = "In payam moghiyat GPS nadarad!",
        ["MEOS_NORESULT"] = "Natijei yaft nashod!"

	},

}

Config.PhoneApplications = {
    ["phone"] = {
        app = "phone",
        color = "#04b543",
        icon = "fa fa-phone-alt",
        tooltipText = "Phone",
        tooltipPos = "top",
        job = false,
        blockedjobs = {},
        slot = 1,
        Alerts = 0,
    },
    ["whatsapp"] = {
        app = "whatsapp",
        color = "#25d366",
        icon = "fab fa-whatsapp",
        tooltipText = "Whatsapp",
        tooltipPos = "top",
        style = "font-size: 2.8vh";
        job = false,
        blockedjobs = {},
        slot = 2,
        Alerts = 0,
    },
    ["bank"] = {
        app = "bank",
        color = "#9c88ff",
        icon = "fas fa-university",
        tooltipText = "Bank",
        tooltipPos = "top",
        job = false,
        blockedjobs = {},
        slot = 3,
        Alerts = 0,
    },
    ["settings"] = {
        app = "settings",
        color = "#636e72",
        icon = "fa fa-cog",
        tooltipText = "Settings",
        tooltipPos = "top",
        style = "padding-right: .08vh; font-size: 2.3vh";
        job = false,
        blockedjobs = {},
        slot = 4,
        Alerts = 0,
    },
    ["garage"] = {
        app = "garage",
        color = "#575fcf",
        icon = "fas fa-warehouse",
        tooltipText = "Vehicles",
        tooltipPos = "top",
        job = false,
        blockedjobs = {},
        slot = 5,
        Alerts = 0,
    },
    ["gallery"] = {
        app = "gallery",
        color = "#AC1D2C",
        icon = "fas fa-images",
        tooltipText = "Gallery",

        tooltipPos = "top",
        job = false,
        blockedjobs = {},
        slot = 7,
        Alerts = 0,
    },
    ["camera"] = {
        app = "camera",
        color = "#AC1D2C",
        icon = "fas fa-camera",
        tooltipText = "Camera",
        tooltipPos = "top",
        job = false,
        blockedjobs = {},
        slot = 8,
        Alerts = 0,
    },

    ["security"] = {
        app = "security",
        color = "#00c9a7",
        icon = "fas fa-shield-alt",
        tooltipText = "Security",
        tooltipPos = "top",
        job = false,
        blockedjobs = {},
        slot = 9,
        Alerts = 0,
    },

    ["browser"] = {
        app = "browser",
        color = "#4285F4",
        icon = "fas fa-globe",
        tooltipText = "Browser",
        tooltipPos = "top",
        job = false,
        blockedjobs = {},
        slot = 10,
        Alerts = 0,
    },

    -- EXPANSION: Discord app — server/channel text chat, persisted in the
    -- DB and pushed live to other online members (see sql/discord.sql,
    -- client/main.lua and server/main.lua for the "Discord:" handlers).
    ["discord"] = {
        app = "discord",
        color = "#5865F2",
        icon = "fab fa-discord",
        tooltipText = "Discord",
        tooltipPos = "top",
        job = false,
        blockedjobs = {},
        slot = 11,
        Alerts = 0,
    },









































































}

-- EXPANSION: Discord account verification. First time someone opens
-- Discord they must link + verify a mailbox on arshiahub.ir/mail before
-- they can use it (see server/main.lua's Discord_SendLoginCode). Adjust
-- the field names below to match that site's real API contract — this
-- was built without access to its documentation, so the request shape
-- is a best-effort guess and MUST be checked against the real API.
Config.DiscordMailAPI = {
    url = "https://arshiahub.ir/mail/api.php",
    siteUrl = "https://arshiahub.ir/mail", -- shown to the player so they know where to look for their code
    method = "POST",
    bodyFormat = "json", -- "json" or "form"
    fieldMailbox = "to",
    fieldCode = "code",
    fieldSubject = "subject",
    subjectText = "Discord Verification Code",
    -- Extra static fields to send every time (e.g. an API key), if the
    -- site needs one: { key = "your-api-key" }
    extraFields = {},
}


-- ==========================================================================
-- Discord app v7 (server/discord_ext.lua, client/discord_ext.lua,
-- html/js/discord_ext.js). Run sql/discord_v7.sql once.
-- ==========================================================================
Config.DiscordExt = {

    -- All money features (boost, VIP) are charged from this ESX account.
    MoneyAccount = 'bank',

    -- ---- Automatic servers ------------------------------------------------
    AutoServers = {
        SyncInterval = 120, -- seconds between full re-syncs (also synced right after job/gang changes)

        -- One private server per gang. Members = every character whose
        -- users.<UserColumn> equals the gang name; the top grade is the owner.
        Gangs = {
            Enabled     = true,
            GangsTable  = 'gangs',        -- table with `name`, `label`
            UserColumn  = 'gang',         -- users.gang
            GradeColumn = 'gang_grade',   -- users.gang_grade
            Exclude     = { 'nogang' },
            IconColor   = '#ED4245',
        },

        -- One official (verified-tick) server per job. Members = everyone
        -- with that job, on or off duty; the top grade gets Admin.
        Jobs = {
            Enabled       = true,
            OffDutyPrefix = 'off',        -- esx_service style: 'offpolice' still belongs to 'police'
            -- Leave empty ( {} ) to create a server for EVERY job except Exclude.
            Include = { 'police', 'sheriff', 'mt', 'ambulance', 'fbi', 'cid', 'cia', 'marshal', 'judge', 'doa',
                        'mechanic', 'taxi' },
            Exclude = { 'unemployed' },
            IconColor = '#5865F2',
            Colors = { -- optional per-job icon colour
                police = '#3B82F6', sheriff = '#A16207', ambulance = '#EF4444', mechanic = '#F59E0B', taxi = '#EAB308',
            },
        },
    },

    -- ---- Rich presence ----------------------------------------------------
    Presence = {
        Enabled = true,
        -- Jobs that show "On duty · <label>" (off-duty = job name starts with OffDutyPrefix above)
        DutyJobs = { 'police', 'sheriff', 'mt', 'ambulance', 'fbi', 'cid', 'cia', 'marshal', 'judge', 'doa', 'mechanic', 'taxi' },
        Places = { -- the client reports the index of the nearest place inside its radius
            { label = 'At the bank',      coords = vector3(149.9, -1040.5, 29.4),  radius = 30.0 },
            { label = 'At the bank',      coords = vector3(-1212.9, -330.8, 37.8), radius = 30.0 },
            { label = 'At the hospital',  coords = vector3(298.0, -584.0, 43.3),   radius = 45.0 },
            { label = 'At the police HQ', coords = vector3(441.0, -981.0, 30.7),   radius = 45.0 },
            { label = 'At Legion Square', coords = vector3(195.2, -934.6, 30.7),   radius = 60.0 },
        },
        DrivingText = 'Driving',
        RidingText  = 'Riding in a vehicle',
        CheckEveryMs = 5000,
    },

    -- ---- Server Boost -----------------------------------------------------
    Boost = {
        Price = 15000,          -- per boost
        Days = 30,              -- a boost lasts this long
        MaxPerPlayerPerServer = 2,
        BaseEmojiSlots = 0,     -- custom reaction emoji slots with no boost
        Levels = {              -- boosts needed -> perks (cumulative, checked highest first)
            { boosts = 2,  emojiSlots = 3,  name = 'Level 1' },
            { boosts = 5,  emojiSlots = 8,  name = 'Level 2' },
            { boosts = 10, emojiSlots = 15, name = 'Level 3' },
        },
    },

    -- ---- Paid VIP (Featured / VIP tab) ------------------------------------
    VIP = {
        Plans = {
            { id = 'week',  label = '7 days',  days = 7,  price = 25000 },
            { id = 'month', label = '30 days', days = 30, price = 80000 },
        },
    },

    -- ---- Moderation -------------------------------------------------------
    Moderation = {
        TimeoutMinutes = { 5, 10, 60, 1440, 10080 }, -- choices shown in the UI (max 7 days)
        AutoTimeoutAtWarns = 3,        -- reaching this many warns auto-timeouts the member (0 = off)
        AutoTimeoutMinutes = 60,
        ReportCooldownSeconds = 20,
    },
    AutoMod = {
        Enabled = true,
        GlobalWords = { },             -- e.g. { 'badword1', 'badword2' } applied on every server
        MaxWordsPerServer = 40,
    },

    -- ---- XP / levels ------------------------------------------------------
    XP = {
        CooldownSeconds = 20, -- a message only earns XP if the previous XP message was this long ago
        Min = 15, Max = 25,
        BaseToLevel = 100,    -- XP needed to go from level L to L+1 = BaseToLevel + Step * L
        Step = 50,
    },

    -- ---- Badges -----------------------------------------------------------
    Badges = {
        founder      = { icon = '👑', label = 'Server founder' },
        first_member = { icon = '🥇', label = 'First member' },
        top_chatter  = { icon = '💬', label = 'Top chatter of the month' },
        booster      = { icon = '💎', label = 'Server booster' },
        veteran      = { icon = '🎖️', label = 'Level 10' },
        legend       = { icon = '🏆', label = 'Level 25' },
    },
    LevelBadges = { [10] = 'veteran', [25] = 'legend' },
    TopChatterMinMessages = 10,

    -- ---- Share from gallery/camera ---------------------------------------
    Share = { MaxCaptionLength = 200 },

    -- ---- v8: invites / vanity / templates ---------------------------------
    Invites = {
        MaxUses = { 0, 1, 5, 10, 25, 100 },          -- 0 = unlimited
        ExpireMinutes = { 0, 60, 1440, 10080 },      -- 0 = never
        MaxActive = 20,
    },
    Vanity = {                                        -- who may set discord.gg/<name>
        MinBoostLevel = 2,
        AllowVerified = true,
        AllowFeatured = false,
    },
    Templates = { MaxPerPlayer = 5 },

    -- ---- v9: government bridge (esx_uniquejobs) ---------------------------
    Gov = {
        -- Extra read-only channels created inside the official job servers.
        ExtraChannels = {
            judge  = { { name = 'court-docket', locked = true } },
            police = { { name = 'warrants', locked = true } },
        },
        ExportDays = 30,           -- how far back a warrant export looks
        ExportMaxMessages = 300,
    },
}

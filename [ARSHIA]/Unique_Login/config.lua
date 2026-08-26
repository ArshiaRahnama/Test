

Config = {}

Config.SMS = {
    ApiUrl    = "https://api.sms.ir/v1/send/verify",



    ApiKey    = "v16gfSyyi7z23aw74j4GsQRrdgMvwVLUCepqyqBMPEGVQIIY",
    TemplateId = 461982,
}

-- How many SMS codes a single phone number / connecting IP can request
-- before being told to wait. Protects your sms.ir balance from being
-- drained by spam and stops phone-number bombing.
Config.SmsRateLimit = {
    MaxPerPhonePerHour = 3,
    MaxPerIpPerHour     = 5,
}

-- Username/password brute-force lockout.
Config.LoginLockout = {
    MaxAttempts  = 5,   -- failed attempts before locking
    LockMinutes  = 15,  -- how long the username stays locked
}

-- SECURITY FIX: sending was already rate-limited, but GUESSING a code that
-- had already been sent was not -- a phone's 6-digit code could be tried
-- as many times as fit in its 2-minute validity window (register step 2
-- AND forgot-password step 2, since both share this limit). This caps
-- guesses per code; exceeding it invalidates the code and forces a resend.
Config.CodeVerifyLockout = {
    MaxAttempts = 5,
}

-- EXPANSION: how many DISTINCT new devices, within how many seconds, before
-- an account is put on security_hold (see sql/install.sql comment). Only
-- a successful SMS-OTP password reset clears the hold.
Config.SuspiciousDeviceLock = {
    MaxNewDevices = 3,
    WindowSeconds = 600, -- 10 minutes
}

-- EXPANSION: login_audit grows forever otherwise. Rows older than this get
-- deleted automatically once a day. Set to 0 to disable cleanup entirely.
Config.AuditLogRetentionDays = 90

-- EXPANSION: built-in connection queue — replaces the separate
-- ServerTest-Queue resource, which independently hooked playerConnecting
-- and raced with this resource over the same shared `deferrals` object
-- (confirmed cause of a real hang in production — see README). Having the
-- queue live HERE means only one resource ever touches deferrals for a
-- connecting player, so this class of conflict can't happen again.
--
-- This is intentionally simple (FIFO, no priority/donor-rank/temp-priority
-- tiers like the old resource had) — just "wait your turn when the server
-- is full". Ask if you need priority slots added back.
Config.Queue = {
    Enabled = true,
    -- nil = use the sv_maxclients convar automatically. Set a number to
    -- override (e.g. reserve a few slots for staff by setting this lower
    -- than sv_maxclients).
    MaxSlots = nil,
    -- How often (ms) a queued player's position message refreshes.
    UpdateIntervalMs = 1500,
}

-- EXPANSION: Discord webhook for security-relevant events (new device
-- login, password reset). Leave SecurityAlerts empty ("") to disable —
-- everything still gets written to the login_audit table either way.
-- Create your own webhook in a private admin channel; don't reuse a
-- webhook from another resource here.
Config.DiscordWebhook = {
    SecurityAlerts = "",
}

-- EXPANSION: username registration blacklist. Checked as a case-insensitive
-- SUBSTRING match, so "xAdminx" and "Owner123" get caught too, not just
-- exact matches. Add your own server-specific staff role names here.
Config.UsernameBlacklist = {
    "admin", "administrator", "owner", "founder", "support", "staff",
    "moderator", "mod", "gm", "developer", "dev", "system", "unique_rp",
    "uniquerp", "helper", "management", "ceo",
}

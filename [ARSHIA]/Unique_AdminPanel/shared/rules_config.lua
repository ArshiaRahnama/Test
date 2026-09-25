-- Server rules enforced by the panel: New Life Rule (NLR) and anti-VDM.
-- Shared by client + server. Everything here is safe to tweak.

NLRConfig = {
    Duration        = 30 * 60,   -- seconds the New Life restriction lasts after a death
    WarnRadius      = 200.0,     -- entering this radius shows the warning
    CoreRadius      = 100.0,     -- inside this radius admins are alerted

    SelfWarnCooldown   = 60,     -- s between warning messages to the player
    AdminAlarmCooldown = 30,     -- s between "player near his death spot" admin alerts

    ViolationSeconds   = 45,     -- s spent inside CoreRadius before the client files a violation
    ViolationCooldown  = 60,

    -- SERVER-SIDE enforcement (cannot be bypassed by editing the client)
    ServerCheckInterval = 5000,  -- ms
    ServerCheckLimit    = 6,     -- consecutive checks inside CoreRadius -> violation (6 x 5s = 30s)
    AutoFlagStrikes     = 3,     -- violations that auto-flag the player in the admin panel (0 = off)

    PollDeath = false,           -- also detect deaths on the server (health poll) if a client never reports one

    Blip = { Colour = 1, Alpha = 90 },
    Hud  = true,

    Revive = {
        Duration = 5 * 60,       -- s of revive protection
        Mode     = 'ragdoll',    -- 'ragdoll' (running/attacking ragdolls you) or 'block' (blocks the controls)
        Ragdoll  = 10000,        -- ms
    },

    Text = {
        Warn = "شما در حال نزدیک شدن به مکان مرگ خود هستید\nجهت جلوگیری از زیر پا گذاشتن قانون نیو لایف سریعا از این منطقه فاصله بگیرید\n\nاخطار آخر درصورت دور نشدن با شما برخورد خواهد شد",
        GameMessage = "Az makan new life khod fasele begirid\nDar gheyr in surat punishment e'emal mishavad",
    },
}

VDMConfig = {
    Enabled = true,

    -- detection is done by the SERVER (it reads the victim's cause/source of death itself).
    -- The victim's client may also report; the server re-checks everything before acting.
    ServerPoll   = true,
    PollInterval = 1000,         -- ms
    ClientReport = true,

    MaxDistance  = 40.0,         -- the killer's vehicle must be this close to the victim
    ExemptJobs   = {},           -- e.g. { 'police' } if your rules allow police to hit suspects
    OnlyMainWorld = true,        -- ignore kills inside other routing buckets (events/instances)

    ReviveDelay  = 1200,         -- ms after the kill before the victim is revived
    ClearNewLife = true,         -- a VDM victim does NOT get the New Life restriction
    ProtectSeconds = 4,          -- invincibility after the revive (so they aren't hit twice)
    DeleteVehicle  = true,       -- remove the vehicle (like /dv)

    Strikes = {
        Window   = 30 * 60,      -- s: kills inside this window count together
        FlagAt   = 3,            -- auto-flag in the admin panel at this many (0 = off)
        AlertAdmins = true,      -- chat line + toast to on-duty admins on EVERY incident
    },

    ToastDuration = 8000,        -- ms
}

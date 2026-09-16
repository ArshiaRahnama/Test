--╔════════════════════════════════════════════════════════════════════════════════╗
--  ███████╗███████╗ ██████╗██╗   ██╗██████╗ ██╗████████╗██╗   ██╗
--  ██╔════╝██╔════╝██╔════╝██║   ██║██╔══██╗██║╚══██╔══╝╚██╗ ██╔╝
--  ███████╗█████╗  ██║     ██║   ██║██████╔╝██║   ██║    ╚████╔╝
--  ╚════██║██╔══╝  ██║     ██║   ██║██╔══██╗██║   ██║     ╚██╔╝
--  ███████║███████╗╚██████╗╚██████╔╝██║  ██║██║   ██║      ██║
--  ╚══════╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝   ╚═╝      ╚═╝
--
-- Anti-dupe / rate-limit / anomaly / integrity layer.
-- See server/custom/security/*.lua.
--
-- ⚠️ IMPORTANT: this file is loaded by `config/*.lua` in fxmanifest, which
-- means it is a SHARED script - it also runs on the client. The signing
-- secret therefore must NOT live here (a shared script is downloadable by
-- any connected client). It's read from a server convar instead, see
-- Config.Security.secretConvar below.
--╚════════════════════════════════════════════════════════════════════════════════╝

Config = Config or {}
Config.Security = Config.Security or {}

-- ── Master switch ────────────────────────────────────────────────────────
-- Turn the whole layer off in one place (useful when debugging something
-- unrelated and you don't want the guard rejecting your test commands).
Config.Security.enabled = true

-- Print every rejection to the server console. Very noisy on a live
-- server - leave false in production, the Discord webhook + the flag
-- table are the real reporting channels.
Config.Security.verbose = false

--─────────────────────────────────────────────────────────────────────────
-- #20/#21 — INTEGRITY (HMAC serial signing + item hash)
--─────────────────────────────────────────────────────────────────────────
-- Name of the server convar holding the HMAC secret. Set it in server.cfg
-- with `set inv_hmac_secret "some-long-random-string"` — NOT in any .lua
-- file, and never in a shared_script.
--
-- ⚠️ Changing this secret invalidates every signature already in the DB.
-- Run the re-sign command (`/inv_resign`, admin only) after changing it,
-- or every existing weapon will be flagged as tampered on next load.
Config.Security.secretConvar = 'inv_hmac_secret'

-- What to do when a weapon serial's signature doesn't verify on load.
--   'flag'    = log + webhook, let the item through (safest to start with -
--               run in this mode for a week to catch false positives from
--               legacy pre-signature rows before switching)
--   'strip'   = log + remove the signature so it re-signs cleanly next save
--   'confiscate' = log + delete the weapon from the loadout
Config.Security.onBadSignature = 'flag'

-- Legacy rows (created before signing existed) have no signature at all.
-- `true` = silently sign them on first load instead of flagging them.
-- Leave true until you've fully migrated, then set false so an unsigned
-- serial becomes suspicious in its own right.
Config.Security.signLegacyOnLoad = true

--─────────────────────────────────────────────────────────────────────────
-- #18 — RATE LIMIT
--─────────────────────────────────────────────────────────────────────────
-- Per-player sliding-window limits. `window` is in seconds, `max` is how
-- many of that action are allowed inside the window.
--
-- These are deliberately generous: they exist to stop scripted spam
-- (dupe loops fire hundreds of events per second), NOT to inconvenience
-- someone quickly splitting a stack. Tune down only if you actually see
-- abuse getting through.
Config.Security.rateLimits = {
    ['give']     = { window = 10, max = 12 },
    ['remove']   = { window = 10, max = 20 },
    ['drop']     = { window = 10, max = 15 },
    ['pickup']   = { window = 10, max = 25 },
    ['stash']    = { window = 10, max = 30 },
    ['trunk']    = { window = 10, max = 30 },
    ['loot']     = { window = 10, max = 20 },
    ['scan']     = { window = 10, max = 8  },
    ['default']  = { window = 10, max = 25 },
}

-- What happens when someone blows through a limit.
--   'ignore' = silently drop the request (recommended - a cheater's script
--              gets no feedback about what tripped)
--   'notify' = drop the request AND tell the player
Config.Security.onRateLimit = 'ignore'

-- Trip this many rate limits inside `repeatWindow` seconds and it escalates
-- to a full anomaly flag (below) rather than staying a silent drop.
Config.Security.rateLimitEscalation = { count = 5, repeatWindow = 60 }

--─────────────────────────────────────────────────────────────────────────
-- #19 — ANOMALY DETECTOR
--─────────────────────────────────────────────────────────────────────────
-- Heuristics for "this transfer pattern doesn't look like a human playing".
-- Each rule that trips adds its `score`; once a player's rolling score
-- crosses `threshold` inside `decayWindow`, they get flagged.
--
-- A flag is a REPORT, not a punishment. Nothing here bans, kicks or
-- deletes anything by itself — it writes to `inv_security_flags` and hits
-- the webhook so a human can look. That's deliberate: every heuristic
-- below has some legitimate scenario that trips it (a gang doing a real
-- mass handover, an admin restocking, a new player dumping their starter
-- kit on a friend), and auto-punishing on a heuristic is how you ban
-- innocent players.
Config.Security.anomaly = {
    enabled = true,
    threshold = 100,
    decayWindow = 300, -- seconds; score fully decays over this period

    rules = {
        -- Same item, same target, over and over in a short window.
        repeatedGive      = { score = 25, count = 6,  window = 60 },
        -- One player receiving from many different players fast (classic
        -- "mule" account collecting a dupe run).
        manySources       = { score = 30, count = 8,  window = 120 },
        -- Giving away more of an item than realistically obtainable.
        hugeStack         = { score = 40, amount = 500 },
        -- Money transfers above this in a single give.
        hugeMoney         = { score = 35, amount = 5000000 },
        -- Two transfers less than this many ms apart (humans can't).
        inhumanSpeed      = { score = 45, minIntervalMs = 120 },
        -- Weight went UP without a matching add (dupe signature).
        weightMismatch    = { score = 60 },
        -- A serial appearing on two players at once.
        duplicateSerial   = { score = 100 },
    },
}

-- Items/accounts the anomaly detector should ignore entirely (e.g. a
-- server-shop NPC identifier, an admin account). Keyed by identifier.
Config.Security.anomalyWhitelist = {
    -- ['license:xxxxxxxxxxxxxxxx'] = true,
}

--─────────────────────────────────────────────────────────────────────────
-- #22 — TWO-STEP CONFIRMATION FOR HIGH-VALUE TRANSFERS
--─────────────────────────────────────────────────────────────────────────
-- A transfer is "high value" if EITHER the item is named in
-- `highValueItems`, OR the total declared value crosses `valueThreshold`.
-- Both sides then have to confirm before anything moves.
Config.Security.confirm = {
    enabled = true,

    -- Seconds before an unconfirmed pending transfer expires.
    timeout = 30,

    -- Require the RECEIVER to accept too, not just the giver to re-confirm.
    -- Strongly recommended: it's what stops "accidental" transfers and
    -- makes a scammed handover provable in logs.
    requireReceiverConfirm = true,

    -- Account transfers at or above this trigger confirmation.
    valueThreshold = 250000,

    -- Per-item override: any of these always require confirmation
    -- regardless of quantity or value.
    highValueItems = {
        ['gold_bar']    = true,
        ['diamond']     = true,
        ['WEAPON_RPG']  = true,
    },

    -- Any weapon whose legality is `false` in Config.WeaponLegality also
    -- requires confirmation (an illegal-weapon handover is exactly the kind
    -- of thing you want a paper trail for).
    illegalWeaponsAlwaysConfirm = true,
}

--─────────────────────────────────────────────────────────────────────────
-- #17 — ANTI-DUPE TRANSFER VALIDATION
--─────────────────────────────────────────────────────────────────────────
Config.Security.transfer = {
    -- Max distance (m) between giver and receiver. Set to 0 to disable the
    -- check entirely. The client already shows a nearby-players list, so a
    -- request from further than this is definitionally forged.
    maxDistance = 5.0,

    -- Re-read the giver's inventory from the player object immediately
    -- before AND after the removal, and abort if the delta isn't exactly
    -- what was asked for. Catches a dupe that races two give events into
    -- the same tick.
    verifyDelta = true,

    -- Serialize all transfers per-player through a lock so two concurrent
    -- events can't both pass the "do you have enough" check against the
    -- same pre-removal state. This is THE fix for the classic dupe, the
    -- rest is defence in depth.
    lockPerPlayer = true,

    -- Refuse a transfer to yourself (a surprisingly common dupe vector
    -- when combined with a desync'd second session).
    blockSelfTransfer = true,
}

-- Discord webhook for security events. Falls back to the existing
-- webhooks table if left empty.
Config.Security.webhook = {
    url = '',
    color = 15105570, -- amber
}

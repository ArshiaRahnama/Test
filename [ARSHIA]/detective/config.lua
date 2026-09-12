Config = {}

-- TEMPORARILY true for solo testing — enables /kqtestcorpse, /kqtestautopsy
-- and /kqtestforensics (see server/forensics.lua + client/forensics.lua).
-- Set back to false before going live.
Config.debug = true


--- SETTINGS FOR ESX
-- This server runs essentialmode with the ESX compatibility bridge
-- (see [BASE]/essentialmode/server/common.lua + client/common.lua, which
-- expose 'esx:getSharedObject'), so ESX mode is what we want enabled.
Config.esxSettings = {
    enabled = true,
}

--- SETTINGS FOR QBCORE
-- Not used on this server.
Config.qbSettings = {
    enabled = false,
    useNewQBExport = true,
    deadPlayerRefreshTime = 15000,
}


-- 'doa' is your dedicated coroner/morgue job (esx_uniquejobs/server/doa_main.lua,
-- own society_doa/society_doj account, and part of Config_cs.DOJJobs in the
-- CAD system) — the most fitting job to examine bodies, so it's included here.
Config.whitelist = {
    enabled = true,
    jobs = {
        'police',
        'ambulance',
        'doa',
    }
}

Config.target = {
    enabled = true,
    -- ox_target ships a built-in qtarget compatibility layer
    -- ([BASE]/ox_target/client/compat/qtarget.lua, `provide 'qtarget'`),
    -- so exports['qtarget']:AddTargetEntity(...) is transparently handled
    -- by ox_target. No need to point this at 'ox_target' directly.
    system = 'qtarget'
}

-- Keybinds
Config.keybinds = {
    investigate = 'E'
}


-- Animations used while investigating
Config.animation = {
    enabled = true,
    dict = 'amb@medic@standing@tendtodead@idle_a',
    anim = 'idle_a',
}


-- ============================================================================
-- FORENSICS (fingerprints / ballistics) — only applies to murdered PLAYERS,
-- since the evidence is generated from the real killer at time of death.
-- ============================================================================
Config.forensics = {
    enabled = true,

    -- % chance evidence is left behind when a player is murdered.
    printChance = 35,   -- fingerprint, tied to the killer's character identifier
    casingChance = 60,  -- shell casing, tied to the killer's REAL weapon serial
                         -- (see ESX.GenerateWeaponSerial in essentialmode/server/common.lua —
                         -- the same LAW-/DOJ-/GANG- serials your armories already hand out)

    -- lc-inventory items police/ambulance receive when they collect evidence.
    -- Add these to your `items` table — see sql/kq_detective_forensics.sql.
    printItem = 'evidence_print',
    casingItem = 'evidence_casing',

    -- Usable item that analyzes the most recently collected evidence.
    kitItem = 'kit_azmayeshi',
}


-- ============================================================================
-- AUTOPSY MINIGAME — only for jobs in `jobs` (coroner/ambulance), and only
-- when investigating a murdered PLAYER (NPCs skip straight to the notepad).
-- On full success it unlocks the exact shot distance and a precise time of
-- death instead of the rounded "N minutes ago" everyone else sees.
-- ============================================================================
Config.autopsy = {
    enabled = true,
    jobs = { 'doa', 'ambulance' }, -- 'doa' is the real coroner job on this server

    stages = {
        { label = 'Checking vitals...',          duration = 4000 },
        { label = 'Estimating time of death...', duration = 5000 },
        { label = 'Extracting projectile...',    duration = 6000 },
    },
}


-- ============================================================================
-- BODY CLEANUP ("collect body") — 'doa' picks up a dead NPC's corpse for a
-- cash reward, same convention as Config_ambulance.reviveReward in
-- ambulance_main.lua (straight xPlayer.addMoney + an esx_society:logAction
-- entry, so it shows up wherever your existing job logs already go).
--
-- Deliberately NPC-only: this deletes the ped entity, which is never safe to
-- do to a real connected player's character. A downed PLAYER still goes
-- through the normal esx_ambulancejob:revivex flow, not this.
-- ============================================================================
Config.cleanup = {
    enabled = true,
    jobs = { 'doa' },
    reward = 150,
    cooldownMs = 3000,   -- per-officer anti-spam guard on the payout
    bagDuration = 4000,  -- ms the black body bag prop stays on the corpse before it's removed
    bagProp = 'prop_body_bag_01',
}


-- ============================================================================
-- DOJ CASE INTEGRATION — uses esx_uniquejobs' own external-export API
-- (server/doj_cases.lua: CreateExternalCase / AddExternalCharge /
-- SetExternalCaseStatus, plus two small additions of the same shape —
-- AddExternalNote / AddExternalSuspect — see the doj_cases.lua patch
-- delivered alongside this resource). Nothing here touches DOJ's database
-- directly; it's all through that export surface, same as esx_drugs does.
--
-- Flow:
--   1. A real player murder (killer identified) -> a case is opened
--      automatically the moment it happens (no command).
--   2. Evidence collected (print/casing) -> a note is added to that case.
--   3. Kit Azmayeshi reveals a match -> the suspect is added to the case
--      AND (optionally) pushed into your CAD (Unique_Cad/DuckMdt) as
--      wanted, via the exact same TriggerEvent('DuckMdt:UpdateCharacterStatus', ...)
--      your own cad/server/crimescene.lua uses.
--   4. If the victim bleeds out unrevived -> a note is added noting that,
--      alongside the existing green map blip.
-- ============================================================================
Config.dojIntegration = {
    enabled = true,
    casePriority = 'high',       -- 'low' | 'medium' | 'high'
    openedByJob = 'doa',         -- job name shown as the case's opener
    pushCadStatus = true,        -- also mark the suspect wanted in Unique_Cad/DuckMdt
    cadWantedLevel = 'wanted',   -- must match one of Config_cs.CadWantedLevels
}


-- ============================================================================
-- FINAL DEATH BLIP — when a downed player bleeds out completely and can no
-- longer be revived, a green body blip is broadcast AUTOMATICALLY (no
-- command needed) to everyone currently in DOJ + Law Enforcement.
--
-- "Bled out completely" is mirrored from Config_ambulance.BleedoutTimer
-- (esx_uniquejobs/client/config_ambulance.lua = 5 minutes) WITHOUT touching
-- that file: kq_detective already knows the instant someone dies. If that
-- same player is still recorded as dead once the same duration has passed,
-- they were never revived in time — the exact moment ambulance_main.lua's
-- own timer force-respawns them at the hospital.
--
-- notifyJobs mirrors Config_cs.DOJJobs + Config_cs.LawEnforcementJobs from
-- esx_uniquejobs/cad/config_crimescene.lua. Keep this list in sync if you
-- edit those.
-- ============================================================================
Config.finalDeath = {
    enabled = true,
    bleedoutMs = 5 * 60000, -- must match Config_ambulance.BleedoutTimer
    notifyJobs = {
        'cid', 'cia', 'marshal', 'fbi', 'judge', 'doa', -- DOJ
        'police', 'sheriff', 'mt',                      -- Law Enforcement
    },
    blipSprite = 280,             -- GTA's built-in "dead body" blip icon
    blipColor = 2,                -- green
    blipScale = 1.0,
    blipLifetimeMs = 10 * 60000,  -- auto-removed after 10 minutes
}


-- ============================================================================
-- DISCORD LOGGING — self-contained (doesn't touch [SCRIPT]/logs), so this is
-- the only place you need to paste a webhook URL for kq_detective's own logs.
-- ============================================================================
Config.discordWebhook = 'WEBHOOK_LINK_HERE'

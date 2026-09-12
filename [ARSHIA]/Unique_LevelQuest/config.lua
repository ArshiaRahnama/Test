-- ================================================================= --
-- Unique_LevelQuest — merged config (XP_Level_System + QuestSystem)
-- ================================================================= --
-- NOTE ON WHICH QUESTS ARE "ACTIVE":
-- The original QuestSystem/Config.lua listed ~50 quests (police, sheriff,
-- metropolitan, ambulance, mechanic, taxi, gang robberies, a full mining/
-- wool/wood/chicken "jobcenter" chain...) but almost none of those trigger
-- names were ever actually fired by any script on this server — they were
-- copy-pasted from a generic template. Firing a quest for an event that
-- never happens means the quest can NEVER be completed.
--
-- I went through the actual job/drug resources on this server
-- (esx_drugs, esx_organserver's ambulance/mechanic/taxi jobs, essentialmode
-- paycheck, esx_lscustom) and only kept/enabled quests that map to a REAL
-- event that already fires (see server/bridges.lua + client/bridges.lua).
-- Everything else is kept below but commented out, so you can re-enable
-- it later once you add the matching TriggerEvent/TriggerServerEvent call
-- at the right spot in the relevant script (or ask me to do it).
-- ================================================================= --

-- ===== XP / Level curve (unchanged from XP_Level_System) ===== --
config = {}
config.Levels = {
[1]=30,[2]=40,[3]=50,[4]=60,[5]=70,[6]=80,[7]=90,[8]=100,[9]=110,[10]=120,
[11]=130,[12]=140,[13]=150,[14]=160,[15]=170,[16]=180,[17]=190,[18]=200,[19]=210,[20]=220,
[21]=230,[22]=240,[23]=250,[24]=260,[25]=270,[26]=280,[27]=290,[28]=300,[29]=310,[30]=320,
[31]=330,[32]=340,[33]=350,[34]=360,[35]=370,[36]=380,[37]=390,[38]=400,[39]=410,[40]=420,
[41]=430,[42]=440,[43]=450,[44]=460,[45]=470,[46]=480,[47]=490,[48]=500,[49]=510,[50]=520,
[51]=530,[52]=540,[53]=550,[54]=560,[55]=570,[56]=580,[57]=590,[58]=600,[59]=610,[60]=620,
[61]=630,[62]=640,[63]=650,[64]=660,[65]=670,[66]=680,[67]=690,[68]=700,[69]=710,[70]=720,
[71]=730,[72]=740,[73]=750,[74]=760,[75]=770,[76]=780,[77]=790,[78]=800,[79]=810,[80]=820,
[81]=830,[82]=840,[83]=850,[84]=860,[85]=870,[86]=880,[87]=890,[88]=900,[89]=910,[90]=920,
[91]=930,[92]=940,[93]=950,[94]=960,[95]=970,[96]=980,[97]=990,[98]=1000,[99]=1100,[100]=1200,
}

-- ===== Admin permission required for /addxp /removexp ===== --
config.AdminXPPermission = 10

-- ===== Quests ===== --
Config = {}

-- Minimum quests to try to generate per player (capped to pool size so it
-- can never infinite-loop when a pool has fewer options than this). This
-- is only how many quests are OFFERED (shown in the Quests tab to choose
-- from) — how many can be ACCEPTED at once is Config.MaxActiveQuests below.
Config.QuestsPerDay = 6

-- How many quests a player can have ACCEPTED (in progress) at the same
-- time. Finishing or cancelling an accepted quest frees a slot right
-- away — no need to wait for the next day's reset.
Config.MaxActiveQuests = 1

-- ===== Coin system (merged in from the standalone CoinSystem resource
-- so it can be deleted; nothing else references it externally except
-- esx_status, which still works unchanged — see server/coin.lua) ===== --
Config.CoinAdminPermission = 8       -- minimum permission_level for /setcoin and the AddCoin/RemoveCoin/SetCoin events
Config.CoinMaxValue        = 1000000 -- hard ceiling so no absurd/overflow values can be written
Config.CoinItem            = false   -- false: coin lives in users.coin column. true: coin is an inventory item (not used on this server)

Config.JobQuests = {

    ["police"] = {
        {name = "Onduty", description = "Daryaft Salary Onduty", trigger = "quest-police:onduty", requiredTrigger = 6, XP = 10, coin = 0.04},
    },

    ["sheriff"] = {
        {name = "Onduty", description = "Daryaft Salary Onduty", trigger = "quest-sheriff:onduty", requiredTrigger = 6, XP = 10, coin = 0.04},
    },

    -- NOTE: table key here is xPlayer.job.name, and Metropolitan's real
    -- internal job name is `mt` (see `[BASE]/database.sql`'s `jobs`
    -- table — label "Metropolitan"), not "metropolitan". Was wrong
    -- before, which meant this quest could never be assigned to any
    -- Metropolitan officer (GenerateQuests below never found a matching
    -- pool for job.name == "mt").
    ["mt"] = {
        {name = "Onduty", description = "Daryaft Salary Onduty", trigger = "quest-metropolitan:onduty", requiredTrigger = 6, XP = 10, coin = 0.04},
    },

    ["ambulance"] = {
        {name = "Onduty",         description = "Daryaft Salary Onduty",      trigger = "quest-ambulance:onduty",   requiredTrigger = 6, XP = 10, coin = 0.04},
        {name = "Revive Player",  description = "Revive 5 Player",            trigger = "quest-ambulance:revive",   requiredTrigger = 5, XP = 20, coin = 0.10},
        {name = "Accept Request", description = "Accept 5 Emergency Request", trigger = "quest-ambulance:acceptreq",requiredTrigger = 5, XP = 15, coin = 0.08},
    },

    ["mechanic"] = {
        {name = "Onduty",         description = "Daryaft Salary Onduty",   trigger = "quest-mechanic:onduty",    requiredTrigger = 6, XP = 10, coin = 0.04},
        {name = "Accept Request", description = "Accept 5 Repair Request", trigger = "quest-mechanic:acceptreq", requiredTrigger = 5, XP = 15, coin = 0.08},
    },

    ["taxi"] = {
        {name = "Onduty",         description = "Daryaft Salary Onduty", trigger = "quest-taxi:onduty",    requiredTrigger = 6, XP = 10, coin = 0.04},
        {name = "Accept Request", description = "Accept 5 Taxi Request", trigger = "quest-taxi:acceptreq", requiredTrigger = 5, XP = 15, coin = 0.08},
        -- NOTE: the ORIGINAL config had this whole section using the wrong
        -- trigger names (literally "quest:revive13".."quest:revive18",
        -- copy-paste leftovers from another job) so taxi quests never
        -- worked at all before.
    },
}

-- ===== uniquecafejobs — cafe/restaurant jobs (all 17 businesses) ===== --
-- Config.JobQuests is a direct job.name lookup, so with 17 separate cafe
-- job names (uwucafe, obsidian, voltage, ...) the only sane way to give
-- them all the same pool without hand-copying it 17 times is to build it
-- with a loop, right here in the config. Every trigger below is fired
-- directly from uniquecafejobs's own server code at the real success
-- point of that action (see server/crafting_sv.lua, server/main.lua,
-- server/market_server.lua) - none of them are guesses.
--
-- Onduty needs its own trigger PER cafe job (same reason police/sheriff/
-- mt/ambulance/mechanic/taxi each have their own "quest-X:onduty" instead
-- of sharing one) - client/bridges.lua's onDutyJobs table below maps
-- every one of these 17 job names to the matching "quest-cafe-onduty:<job>"
-- string, fired from essentialmode's REAL esx:givesalary tick (exactly
-- the same mechanism the other Onduty quests already use).
--
-- "Charge Customers" (Bill) needed special handling: esx_billing's own
-- confirm event fires with the CUSTOMER as the ambient source, not the
-- cafe employee who sent the bill - same attribution problem as
-- ambulance/taxi Ghabz above. Fixed with a small round-trip:
-- server/main.lua now tells the BILLER's own client to fire the quest
-- itself once the customer accepts (see client/functions.lua's new
-- uniquecafejobs:billQuest handler) - same pattern client/bridges.lua
-- already uses for onduty (client fires its own quest event, never
-- someone else's).
local uniqueCafeJobNames = {
    "uwucafe", "obsidian", "voltage", "ember", "anchor", "crimson",
    "flourish", "goldcrust", "carwash",
    "firebrick", "slice", "frostbite", "sundae",
    "static", "nightjar", "koi", "wasabi",
}
local sharedCafePool = {
    {name = "Barista Pro",     description = "20 Ta Item Craft Kon",                 trigger = "quest-cafe:craft",     requiredTrigger = 20, XP = 15, coin = 0.06},
    {name = "List on Market",  description = "10 Ta Item Too Market Bezar Befroosh", trigger = "quest-cafe:advertise", requiredTrigger = 10, XP = 15, coin = 0.06},
    {name = "Charge Customers",description = "10 Bar Az Moshtari Ghabz Bekesh",      trigger = "quest-cafe:bill",      requiredTrigger = 10, XP = 15, coin = 0.08},
}
for _, jobName in ipairs(uniqueCafeJobNames) do
    local pool = {}
    for _, q in ipairs(sharedCafePool) do table.insert(pool, q) end
    table.insert(pool, {name = "Onduty", description = "Daryaft Salary Onduty", trigger = "quest-cafe-onduty:" .. jobName, requiredTrigger = 6, XP = 10, coin = 0.04})
    Config.JobQuests[jobName] = pool
end

-- ===== uniquecafejobs — holdings (Meridian, Blacktide, Crate & Carry, TurfCo) ===== --
-- Same real-esx:givesalary mechanism as cafe Onduty above, but with 2
-- tiers per holding (quick one + a bigger "veteran" one) since a holding
-- job is held for much longer stretches than a single cafe shift.
local function onDutyTiers(jobName)
    return {
        {name = "Onduty",         description = "Daryaft Salary Onduty",   trigger = "quest-cafe-onduty:" .. jobName, requiredTrigger = 6,  XP = 10, coin = 0.04},
        {name = "Onduty Veteran", description = "20 Bar Salary Daryaft Kon",trigger = "quest-cafe-onduty:" .. jobName, requiredTrigger = 20, XP = 30, coin = 0.15},
    }
end
local holdingSharedPool = {
    {name = "Collect Franchise Fees", description = "5 Bar Franchise Fee Jam Kon", trigger = "quest-cafe:collectfee", requiredTrigger = 5, XP = 20, coin = 0.10},
    {name = "Rank Up a Business",     description = "3 Bar Business Ro Rank Up Kon", trigger = "quest-cafe:upgrade",   requiredTrigger = 3, XP = 25, coin = 0.12},
    {name = "Appoint a Manager",      description = "3 Nafar Ro Manager Kon",      trigger = "quest-cafe:hire",       requiredTrigger = 3, XP = 15, coin = 0.08},
}
local function extendPool(basePool, ...)
    local pool = {}
    for _, q in ipairs(basePool) do table.insert(pool, q) end
    for _, q in ipairs({...}) do table.insert(pool, q) end
    return pool
end
Config.JobQuests["meridian"]   = extendPool(holdingSharedPool, table.unpack(onDutyTiers("meridian")))
Config.JobQuests["turfco"]     = extendPool(holdingSharedPool, table.unpack(onDutyTiers("turfco")))
Config.JobQuests["blacktide"]  = extendPool(holdingSharedPool,
    -- Blacktide-only action (server/corp_server.lua: xPlayer.job.name must == Corp.Blacktide.Job)
    {name = "Launder Money", description = "10 Bar Pool Kasif Bosho", trigger = "quest-cafe:launder", requiredTrigger = 10, XP = 15, coin = 0.08},
    table.unpack(onDutyTiers("blacktide"))
)
Config.JobQuests["cratecarry"] = extendPool(holdingSharedPool,
    -- Crate & Carry-only action (server/corp_server.lua: xPlayer.job.name must == Corp.CrateCarry.Job)
    {name = "Wholesale Buyer", description = "5 Bar Az Wholesale Kharid Kon", trigger = "quest-cafe:wholesale", requiredTrigger = 5, XP = 15, coin = 0.08},
    table.unpack(onDutyTiers("cratecarry"))
)

--[[ ============ NOT WIRED — no real event exists for these =========
    Checked every relevant resource on this server; none of these have
    an event that fires distinctly enough to track (or the resource
    doesn't exist at all). Left out rather than shipping a quest that
    can never complete. If you add/point me to a real trigger point
    for any of these, I'll wire it in:

      police/sheriff/metropolitan: Jail, Fine, Impound, Accept Robbery,
        Cuff — esx_jailhandler's jail flow doesn't fire a distinct
        server event for a completed jailing, and esx_aduty's "fine" is
        an ADMIN-only command (perm 3), not a police officer action.

      ambulance: Heal Player, Ghabz — esx_organserver fires
        esx_ambulancejob:heal on the PATIENT's client (not the medic's),
        and the fine-payment event is likewise fired by the patient
        paying, not the medic collecting — no reliable way to credit
        the right player without editing esx_organserver itself.

      mechanic: Repair, Clean, Flatbed, Impound, Flip, Custom Car —
        esx_lscustom's buyMod fires for ANY player buying mods for
        their own car (not job-gated to mechanics), so it can't be
        used to credit mechanics specifically. No other distinct event
        exists for these actions.

      taxi: Ghabz — esx_taxijob:pay is fired by the PASSENGER paying,
        not the driver receiving the fare, same attribution problem
        as ambulance Ghabz above.

      gang: shop/bank robbery quests — esx_shop_robbery /
        esx_Bank_robbery don't exist as resources anywhere on this
        server at all.

      petrol / wool / fabric / clothe / wood / chicken chain — no
        matching resource exists on this server under any name.
======================================================================]]

Config.DefaultQuest = {
    -- Full drug chain. Every one of these maps to a "Task_System:*" event
    -- that esx_drugs ALREADY fires today (see client/bridges.lua) — it was
    -- simply never listened to by anything, so quest progress for drugs
    -- has never actually been tracked on this server until now.
    {name = "Farme Ephedra",     description = "50 Ta Ephedra Bardasht Kon", trigger = "quest-drug:ephedra",     requiredTrigger = 50,  XP = 10, coin = 0.04},
    {name = "Sakhte Ephedrine",  description = "100 Ta Ephedrine Besaz",     trigger = "quest-drug:ephedrine",   requiredTrigger = 50,  XP = 10, coin = 0.04},
    {name = "Sakhte Shishe",     description = "20 Ta Shishe Besaz",         trigger = "quest-drug:meth",        requiredTrigger = 20,  XP = 10, coin = 0.04},
    {name = "Foroshe Shishe",    description = "10 Ta Shishe Befrosh",       trigger = "quest-drug:sellmeth",    requiredTrigger = 10,  XP = 10, coin = 0.04},
    {name = "Farme Shahdane",    description = "100 Ta Shahdane Bardasht Kon",trigger = "quest-drug:cannabis",   requiredTrigger = 100, XP = 10, coin = 0.04},
    {name = "Sakhte Marijuana",  description = "500 Ta Marijuana Besaz",     trigger = "quest-drug:marijuana",   requiredTrigger = 100, XP = 10, coin = 0.04},
    {name = "Forosh Marijuana",  description = "250 Ta Marijuana Beforsh",   trigger = "quest-drug:sellmarjuana",requiredTrigger = 250, XP = 10, coin = 0.04},
    {name = "Farme Tokme Cocaine",description = "50 Ta Coca Bardasht Kon",   trigger = "quest-drug:coca",        requiredTrigger = 50,  XP = 10, coin = 0.04},
    {name = "Sakhte Cocaine",    description = "20 Ta Cocaine Besaz",        trigger = "quest-drug:cocaine",     requiredTrigger = 20,  XP = 10, coin = 0.04},
    {name = "Foroshe Cocaine",   description = "10 Ta Cocaine Befrosh",      trigger = "quest-drug:sellcocaine", requiredTrigger = 10,  XP = 10, coin = 0.04},
    {name = "Sakhte Crack",      description = "10 Ta Crack Besaz",          trigger = "quest-drug:crack",       requiredTrigger = 10,  XP = 10, coin = 0.04},
    {name = "Foroshe Crack",     description = "10 Ta Crack Befrosh",        trigger = "quest-drug:sellcrack",   requiredTrigger = 10,  XP = 10, coin = 0.04},
    {name = "Farme Khash Khaash",description = "50 Ta Khashkhash Bardasht Kon",trigger = "quest-drug:poppy",     requiredTrigger = 50,  XP = 10, coin = 0.04},
    {name = "Sakhte Teryak",     description = "25 Ta Teryak Besaz",         trigger = "quest-drug:opium",       requiredTrigger = 25,  XP = 10, coin = 0.04},
    {name = "Sakhte Heroine",    description = "10 Ta Heroine Besaz",        trigger = "quest-drug:heroine",     requiredTrigger = 10,  XP = 10, coin = 0.04},
    {name = "Foroshe Heroine",   description = "10 Ta Heroine Befrosh",      trigger = "quest-drug:sellheroine", requiredTrigger = 10,  XP = 10, coin = 0.04},
    {name = "Bardashte Gharch",  description = "50 Ta Gharch Bardasht Kon",  trigger = "quest-drug:mushroom",    requiredTrigger = 50,  XP = 10, coin = 0.04},
    {name = "Foroshe Gharchh",   description = "10 Ta Gharch Befrosh",       trigger = "quest-drug:sellmushroom",requiredTrigger = 10,  XP = 10, coin = 0.04},

    -- Mining chain (esx_minerjob — this resource has NO job requirement,
    -- anyone can mine, which is exactly why it belongs here alongside
    -- the drug side-hustles instead of in a job-restricted pool). Maps
    -- to real "TaskSystem:*" hooks esx_minerjob already fires, plus one
    -- I added a bridge for (MeltItems has no hook of its own upstream).
    {name = "Farme Sang Ma'dan",  description = "20 Bar Sang Dakhele Kamion Bezar", trigger = "quest-jobcenter:stonemine", requiredTrigger = 20, XP = 10, coin = 0.04},
    {name = "Foroshe Sang",       description = "10 Bar Sang Befrosh",              trigger = "quest-jobcenter:sellstone", requiredTrigger = 10, XP = 10, coin = 0.04},
    {name = "Gharbale Sang",      description = "10 Bar Sang Ro Bekesh",            trigger = "quest-jobcenter:washstone", requiredTrigger = 10, XP = 10, coin = 0.04},
    {name = "Zob Ahan",           description = "5 Ta Ahan Zob Kon",                trigger = "quest-jobcenter:zobahan",   requiredTrigger = 5,  XP = 15, coin = 0.06},
    {name = "Zob Tala",           description = "5 Ta Tala Zob Kon",                trigger = "quest-jobcenter:zobtala",   requiredTrigger = 5,  XP = 15, coin = 0.06},

    -- uniquecafejobs — open to everyone, not job-gated (any player can buy
    -- from a cafe counter, the player marketplace, or Crate & Carry's
    -- resale shop). Same real-success-point rule as everything else here.
    {name = "Cafe Regular",   description = "20 Ta Item Az Cafe Bekhar", trigger = "quest-cafe:sell",      requiredTrigger = 20, XP = 10, coin = 0.04},
    {name = "Market Shopper", description = "10 Ta Item Az Market Bekhar", trigger = "quest-cafe:marketbuy", requiredTrigger = 10, XP = 10, coin = 0.04},
    {name = "Bargain Hunter", description = "5 Ta Item Az Resale Shop Bekhar", trigger = "quest-cafe:resale", requiredTrigger = 5,  XP = 10, coin = 0.05},

    -- Petrol / wool / fabric / clothe / wood / chicken chain from the
    -- original config: no matching resource exists ANYWHERE on this
    -- server (not under a different name either — I searched the whole
    -- repo). Left out entirely; there's nothing to wire this to unless
    -- you install a resource for it.
}

Config.GangQuest = {
    -- References esx_shop_robbery / esx_Bank_robbery, neither of which
    -- exists anywhere in this server's resources, so left disabled.
}

-- ===== Skill tab (also drives which jobs get a Duty tab — server/duty.lua) ===== --
-- Real, honest tracking: every ~15 minutes a player spends ON DUTY in
-- one of these jobs (driven by the same esx:givesalary tick already
-- used for the Onduty quest — essentialmode's own paycheck interval is
-- 15 minutes), that job's skill minutes go up. No fake/instant progress.
Config.SkillTargetMinutes = 3000 -- 50 hours of on-duty time = 100%

-- Keys MUST be the job's internal `name` (jobs.name / xPlayer.job.name),
-- not its display label — checked against `[BASE]/database.sql`'s
-- `jobs` table. `metropolitan` here used to be wrong (the real internal
-- name is `mt` — label "Metropolitan") which meant Metropolitan never
-- actually got Skill tracking, fixed below alongside adding the rest of
-- DOJ/LAW/Organ Services.
Config.TrackedJobs = {
    -- Department Of Justice
    cid     = "CID",
    cia     = "CIA",
    marshal = "Marshal",
    fbi     = "FBI",
    judge   = "Judge",
    doa     = "DOA",

    -- Law Enforcement
    police  = "Police",
    sheriff = "Sheriff",
    mt      = "Metropolitan",

    -- Organ Services
    taxi      = "Taxi",
    mechanic  = "Mechanic",
    ambulance = "Medic", -- internal job name is `ambulance`; label shown is "Medic" per notejobserver.txt
    weazel    = "Weazel",
}

-- Coin rewards paid once when a skill first crosses each threshold —
-- same idea as quest rewards, granted through the same CoinSystem
-- export, tracked per-job so each milestone only ever pays out once.
Config.SkillMilestones = {
    { percent = 25,  coin = 0.10 },
    { percent = 50,  coin = 0.20 },
    { percent = 75,  coin = 0.35 },
    { percent = 100, coin = 0.75 },
}

-- ===== Paycheck countdown ===== --
-- FiveM resources can't read each other's Config table directly, so
-- this MUST be kept in sync by hand with essentialmode's own
-- Config.PaycheckInterval (essentialmode/config.lua). Confirmed value
-- on this server: 15 * 60000 ms = 15 minutes.
Config.PaycheckIntervalMinutes = 15

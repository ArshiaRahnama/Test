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
        -- Real esx:requestarrestpd action (server/police_main.lua, shared
        -- by police/sheriff/mt), job-gated, `source` = the officer.
        {name = "Cuff Suspect", description = "Dastband Bezan Be 5 Suspect", trigger = "quest-police:cuff", requiredTrigger = 5, XP = 20, coin = 0.10},
        -- Real arshia_jail:sendto (Unique_Punishment/server/jail.lua,
        -- type == 'faction'), job-gated via that resource's own IsJobAllowed.
        {name = "Jail Suspect", description = "5 Nafar Ra Zendani Kon", trigger = "quest-police:jail", requiredTrigger = 4, XP = 20, coin = 0.10},
        -- Real esx_billing:send2Bill fine action, `source` = the officer.
        {name = "Fine Player", description = "Baraye 6 Nafar Jarime Bezan", trigger = "quest-police:fine", requiredTrigger = 6, XP = 15, coin = 0.08},
    },

    ["sheriff"] = {
        {name = "Onduty", description = "Daryaft Salary Onduty", trigger = "quest-sheriff:onduty", requiredTrigger = 6, XP = 10, coin = 0.04},
        {name = "Cuff Suspect", description = "Dastband Bezan Be 5 Suspect", trigger = "quest-sheriff:cuff", requiredTrigger = 5, XP = 20, coin = 0.10},
        {name = "Jail Suspect", description = "5 Nafar Ra Zendani Kon", trigger = "quest-sheriff:jail", requiredTrigger = 4, XP = 20, coin = 0.10},
        {name = "Fine Player", description = "Baraye 6 Nafar Jarime Bezan", trigger = "quest-sheriff:fine", requiredTrigger = 6, XP = 15, coin = 0.08},
    },

    -- NOTE: table key here is xPlayer.job.name, and Metropolitan's real
    -- internal job name is `mt` (see `[BASE]/database.sql`'s `jobs`
    -- table — label "Metropolitan"), not "metropolitan". Was wrong
    -- before, which meant this quest could never be assigned to any
    -- Metropolitan officer (GenerateQuests below never found a matching
    -- pool for job.name == "mt").
    ["mt"] = {
        {name = "Onduty", description = "Daryaft Salary Onduty", trigger = "quest-metropolitan:onduty", requiredTrigger = 6, XP = 10, coin = 0.04},
        {name = "Cuff Suspect", description = "Dastband Bezan Be 5 Suspect", trigger = "quest-mt:cuff", requiredTrigger = 5, XP = 20, coin = 0.10},
        {name = "Jail Suspect", description = "5 Nafar Ra Zendani Kon", trigger = "quest-mt:jail", requiredTrigger = 4, XP = 20, coin = 0.10},
        {name = "Fine Player", description = "Baraye 6 Nafar Jarime Bezan", trigger = "quest-mt:fine", requiredTrigger = 6, XP = 15, coin = 0.08},
    },

    ["ambulance"] = {
        {name = "Onduty",         description = "Daryaft Salary Onduty",      trigger = "quest-ambulance:onduty",   requiredTrigger = 6, XP = 10, coin = 0.04},
        {name = "Revive Player",  description = "Revive 5 Player",            trigger = "quest-ambulance:revive",   requiredTrigger = 5, XP = 20, coin = 0.10},
        {name = "Accept Request", description = "Accept 5 Emergency Request", trigger = "quest-ambulance:acceptreq",requiredTrigger = 5, XP = 15, coin = 0.08},
        -- Real esx_ambulancejob:blingrequest action, `source` = the medic
        -- requesting payment (NOT esx_billing:send2Bill2 -- see
        -- server/bridges.lua's long comment on why that one is unsafe here).
        {name = "Charge Patient", description = "Baraye 6 Bimar Ghabz Bezan", trigger = "quest-ambulance:bill", requiredTrigger = 6, XP = 15, coin = 0.08},
    },

    ["mechanic"] = {
        {name = "Onduty",         description = "Daryaft Salary Onduty",   trigger = "quest-mechanic:onduty",    requiredTrigger = 6, XP = 10, coin = 0.04},
        {name = "Accept Request", description = "Accept 5 Repair Request", trigger = "quest-mechanic:acceptreq", requiredTrigger = 5, XP = 15, coin = 0.08},
        -- Real esx_mechanicjob:reportRepair action (server/mechanic_main.lua
        -- -- new event, repair previously had no server round-trip at all).
        {name = "Repair Vehicle", description = "5 Vehicle Ra Repair Kon",  trigger = "quest-mechanic:repair",   requiredTrigger = 5, XP = 18, coin = 0.09},
        -- Real esx_mechanicjob:blingrequest action, `source` = the mechanic.
        {name = "Charge Customer",description = "Baraye 6 Moshtari Ghabz Bezan", trigger = "quest-mechanic:bill", requiredTrigger = 6, XP = 15, coin = 0.08},
    },

    ["taxi"] = {
        {name = "Onduty",         description = "Daryaft Salary Onduty", trigger = "quest-taxi:onduty",    requiredTrigger = 6, XP = 10, coin = 0.04},
        {name = "Accept Request", description = "Accept 5 Taxi Request", trigger = "quest-taxi:acceptreq", requiredTrigger = 5, XP = 15, coin = 0.08},
        -- Real esx_taxijob:blingrequest action, `source` = the driver
        -- requesting the fare (NOT esx_billing:send2Bill2/esx_taxijob:pay
        -- -- both of those fire from the PASSENGER's own client instead).
        {name = "Charge Fare", description = "Baraye 6 Mosafer Ghabz Bezan", trigger = "quest-taxi:bill", requiredTrigger = 6, XP = 15, coin = 0.08},
        -- NOTE: the ORIGINAL config had this whole section using the wrong
        -- trigger names (literally "quest:revive13".."quest:revive18",
        -- copy-paste leftovers from another job) so taxi quests never
        -- worked at all before.
    },

    -- ===== Department Of Justice — Jail + Fine cover all 9 of these jobs,
    -- since Unique_Punishment's faction jail and esx_billing's fines are
    -- shared, job-checked systems every one of them can use. =====
    ["cid"] = {
        {name = "Onduty", description = "Daryaft Salary Onduty", trigger = "quest-cid:onduty", requiredTrigger = 6, XP = 10, coin = 0.04},
        {name = "Jail Suspect", description = "5 Nafar Ra Zendani Kon", trigger = "quest-cid:jail", requiredTrigger = 4, XP = 20, coin = 0.10},
        {name = "Fine Player", description = "Baraye 6 Nafar Jarime Bezan", trigger = "quest-cid:fine", requiredTrigger = 6, XP = 15, coin = 0.08},
    },

    ["cia"] = {
        {name = "Onduty",         description = "Daryaft Salary Onduty", trigger = "quest-cia:onduty", requiredTrigger = 6, XP = 10, coin = 0.04},
        -- Real esx_cia_job:requestarrest action (server/cia_main.lua),
        -- job-gated. Bridged via esx_society:logAction, same technique
        -- already used for ambulance's Revive quest below.
        {name = "Arrest Suspect", description = "Arrest 5 Suspect",   trigger = "quest-cia:arrest", requiredTrigger = 5, XP = 20, coin = 0.10},
        {name = "Jail Suspect", description = "5 Nafar Ra Zendani Kon", trigger = "quest-cia:jail", requiredTrigger = 4, XP = 20, coin = 0.10},
        {name = "Fine Player", description = "Baraye 6 Nafar Jarime Bezan", trigger = "quest-cia:fine", requiredTrigger = 6, XP = 15, coin = 0.08},
    },

    ["marshal"] = {
        {name = "Onduty", description = "Daryaft Salary Onduty", trigger = "quest-marshal:onduty", requiredTrigger = 6, XP = 10, coin = 0.04},
        {name = "Jail Suspect", description = "5 Nafar Ra Zendani Kon", trigger = "quest-marshal:jail", requiredTrigger = 4, XP = 20, coin = 0.10},
        {name = "Fine Player", description = "Baraye 6 Nafar Jarime Bezan", trigger = "quest-marshal:fine", requiredTrigger = 6, XP = 15, coin = 0.08},
    },

    ["fbi"] = {
        {name = "Onduty",         description = "Daryaft Salary Onduty", trigger = "quest-fbi:onduty", requiredTrigger = 6, XP = 10, coin = 0.04},
        -- Real esx_fbi_job:requestarrest action (server/fbi_main.lua), same as CIA above.
        {name = "Arrest Suspect", description = "Arrest 5 Suspect",   trigger = "quest-fbi:arrest", requiredTrigger = 5, XP = 20, coin = 0.10},
        {name = "Jail Suspect", description = "5 Nafar Ra Zendani Kon", trigger = "quest-fbi:jail", requiredTrigger = 4, XP = 20, coin = 0.10},
        {name = "Fine Player", description = "Baraye 6 Nafar Jarime Bezan", trigger = "quest-fbi:fine", requiredTrigger = 6, XP = 15, coin = 0.08},
    },

    ["judge"] = {
        {name = "Onduty",         description = "Daryaft Salary Onduty", trigger = "quest-judge:onduty", requiredTrigger = 6, XP = 10, coin = 0.04},
        -- Real, judge-exclusive esx_uniquejobs:dojRecordVerdict action
        -- (server/court_docket.lua) -- the ONLY job allowed to call it
        -- (isJudge(...) check inside that handler rejects everyone else).
        {name = "Record Verdict", description = "Record 3 Verdict",   trigger = "quest-judge:verdict", requiredTrigger = 3, XP = 20, coin = 0.10},
        {name = "Jail Suspect", description = "5 Nafar Ra Zendani Kon", trigger = "quest-judge:jail", requiredTrigger = 4, XP = 20, coin = 0.10},
        {name = "Fine Player", description = "Baraye 6 Nafar Jarime Bezan", trigger = "quest-judge:fine", requiredTrigger = 6, XP = 15, coin = 0.08},
    },

    ["doa"] = {
        {name = "Onduty", description = "Daryaft Salary Onduty", trigger = "quest-doa:onduty", requiredTrigger = 6, XP = 10, coin = 0.04},
        -- doa_main.lua is a literal copy of judge_main.lua's generic
        -- armory/vehicle-lookup boilerplate with no DOA-exclusive action
        -- of its own on this server, but Jail + Fine below still apply
        -- (doa IS in Unique_Punishment's Config.AllowedJobs and does call
        -- esx_billing:send2Bill for fines, same as every job above).
        {name = "Jail Suspect", description = "5 Nafar Ra Zendani Kon", trigger = "quest-doa:jail", requiredTrigger = 4, XP = 20, coin = 0.10},
        {name = "Fine Player", description = "Baraye 6 Nafar Jarime Bezan", trigger = "quest-doa:fine", requiredTrigger = 6, XP = 15, coin = 0.08},
    },

    -- ===== Organ Services extra (weazel; taxi/mechanic/ambulance already above) =====
    ["weazel"] = {
        {name = "Onduty",   description = "Daryaft Salary Onduty", trigger = "quest-weazel:onduty",   requiredTrigger = 6, XP = 10, coin = 0.04},
        -- Real, job-gated esx_society:logAction('weazel', 'Camera Toggled')
        -- from server/weazel_cam_server.lua (broadcast camera on/off).
        {name = "Broadcast", description = "Estefade Az Camera 10 Bar", trigger = "quest-weazel:broadcast", requiredTrigger = 10, XP = 15, coin = 0.06},
    },

    -- esx_jobs (fueler/lumberjack/slaughterer/tailor/miner): these were
    -- listed below as "NOT WIRED -- no matching resource exists" because
    -- at the time nothing on this server fired a distinct, per-player
    -- event for these actions. esx_jobs now fires
    -- TriggerEvent('quest-<job>:produce' | ':deliver') itself (see
    -- server/main.lua's Work() function) for the 4 Config.Jobs-based
    -- jobs, and 'quest-miner:mine' / 'quest-miner:sell' from
    -- server/jobs/minerjob.lua for the miner job.
    ["fueler"] = {
        {name = "Refine", description = "Drill/Refine/Mix 20 times", trigger = "quest-fueler:produce", requiredTrigger = 20, XP = 15, coin = 0.05},
        {name = "Deliver", description = "Deliver 10 loads of gas", trigger = "quest-fueler:deliver", requiredTrigger = 10, XP = 20, coin = 0.08},
    },

    ["lumberjack"] = {
        {name = "Cut", description = "Cut/package wood 20 times", trigger = "quest-lumberjack:produce", requiredTrigger = 20, XP = 15, coin = 0.05},
        {name = "Deliver", description = "Deliver 10 board packages", trigger = "quest-lumberjack:deliver", requiredTrigger = 10, XP = 20, coin = 0.08},
    },

    ["slaughterer"] = {
        {name = "Process", description = "Catch/slaughter/package 20 times", trigger = "quest-slaughterer:produce", requiredTrigger = 20, XP = 15, coin = 0.05},
        {name = "Deliver", description = "Deliver 10 chicken trays", trigger = "quest-slaughterer:deliver", requiredTrigger = 10, XP = 20, coin = 0.08},
    },

    ["tailor"] = {
        {name = "Sew", description = "Gather wool/make fabric or clothes 20 times", trigger = "quest-tailor:produce", requiredTrigger = 20, XP = 15, coin = 0.05},
        {name = "Deliver", description = "Deliver 10 clothing orders", trigger = "quest-tailor:deliver", requiredTrigger = 10, XP = 20, coin = 0.08},
    },

    ["miner"] = {
        {name = "Mine", description = "Mine and load 30 rocks", trigger = "quest-miner:mine", requiredTrigger = 30, XP = 15, coin = 0.05},
        {name = "Sell", description = "Sell washed stone 10 times", trigger = "quest-miner:sell", requiredTrigger = 10, XP = 20, coin = 0.08},
    },

    -- Unemployed players (xPlayer.job.name == "nojob" on this server, not
    -- the more common "unemployed"). esx_jobs fires this the moment a
    -- nojob player picks any job at the Job Center (see server/main.lua's
    -- esx_jobs:setJob) -- as soon as they do, they stop being "nojob" and
    -- GenerateQuests picks up that job's own quests instead, so this is
    -- just the one-time nudge to go get a job in the first place.
    ["nojob"] = {
        {name = "Get a Job", description = "Set a job at the Job Center", trigger = "quest-nojob:getjob", requiredTrigger = 1, XP = 10, coin = 0.02},
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

      police/sheriff/metropolitan/cid/cia/marshal/fbi/judge/doa: Jail,
        Fine, Cuff (police/sheriff/mt only) are now wired above -- see
        server/bridges.lua for arshia_jail:sendto (Unique_Punishment)
        and esx_billing:send2Bill. Still not wired: Impound, Accept
        Robbery -- no distinct per-officer event exists for either.

      ambulance: Heal Player -- esx_ambulancejob:heal fires on the
        PATIENT's client, not the medic's, no reliable way to credit
        the medic without editing that flow. Charge Patient (Ghabz) IS
        now wired above via esx_ambulancejob:blingrequest.

      mechanic: Clean, Flatbed, Impound, Flip, Custom Car —
        esx_lscustom's buyMod fires for ANY player buying mods for
        their own car (not job-gated to mechanics), so it can't be
        used to credit mechanics specifically. No other distinct event
        exists for these actions. Repair and Charge Customer ARE now
        wired above (esx_mechanicjob:reportRepair / :blingrequest).

      taxi: Charge Fare is now wired above via esx_taxijob:blingrequest
        (NOT esx_taxijob:pay / esx_billing:send2Bill2, both of which
        fire from the PASSENGER's own client, not the driver's).

      gang: shop/bank robbery quests — esx_shop_robbery /
        esx_Bank_robbery don't exist as resources anywhere on this
        server at all.

      petrol / wool / fabric / clothe / wood / chicken chain — now wired,
        see the ["fueler"]/["lumberjack"]/["slaughterer"]/["tailor"]/
        ["miner"] entries above (esx_jobs fires the triggers itself).
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

-- ================================================================= --
-- Unique-style activity skills / rank bar / level perks (all optional)
-- ================================================================= --
-- Activity skills: every accepted action adds `addType[action]` percent to
-- the skill (0..100). At 100% the skill is "finished": the player gets a
-- one-time coin reward and work timers of the matching job get shorter
-- (Config.SkillFinishedTimeFactor), exactly like Unique's `time = {slow, fast}`.
Config.SkillFinishedTimeFactor = 0.70 -- finished skill => 30% faster work ticks
Config.SkillFinishCoin = 0.50         -- paid once, when a skill reaches 100%

Config.Skills = {
    miner_skill      = { label = 'Miner',       job = 'miner',       addType = { mine = 0.10, sell = 0.50, wash = 0.50, smelt = 1.00 } },
    chobbori_skill   = { label = 'Lumberjack',  job = 'lumberjack',  addType = { produce = 0.10, deliver = 0.50 } },
    palayeshgah_skill= { label = 'Refinery',    job = 'fueler',      addType = { produce = 0.10, deliver = 0.50 } },
    ghasab_skill     = { label = 'Slaughterer', job = 'slaughterer', addType = { produce = 0.10, deliver = 0.50 } },
    clothe_skill     = { label = 'Tailor',      job = 'tailor',      addType = { produce = 0.10, deliver = 0.50 } },
}

-- server-side events (already fired by esx_jobs / our bridges) -> skill action.
Config.SkillTriggers = {
    ['quest-miner:mine']            = { 'miner_skill', 'mine' },
    ['quest-miner:sell']            = { 'miner_skill', 'sell' },
    ['quest-jobcenter:washstone']   = { 'miner_skill', 'wash' },
    ['quest-jobcenter:zobahan']     = { 'miner_skill', 'smelt' },
    ['quest-jobcenter:zobtala']     = { 'miner_skill', 'smelt' },
    ['quest-lumberjack:produce']    = { 'chobbori_skill', 'produce' },
    ['quest-lumberjack:deliver']    = { 'chobbori_skill', 'deliver' },
    ['quest-fueler:produce']        = { 'palayeshgah_skill', 'produce' },
    ['quest-fueler:deliver']        = { 'palayeshgah_skill', 'deliver' },
    ['quest-slaughterer:produce']   = { 'ghasab_skill', 'produce' },
    ['quest-slaughterer:deliver']   = { 'ghasab_skill', 'deliver' },
    ['quest-tailor:produce']        = { 'clothe_skill', 'produce' },
    ['quest-tailor:deliver']        = { 'clothe_skill', 'deliver' },
}

-- GTA's native rank bar (the one that slides in when you earn RP) on every XP change.
Config.RankBar = {
    enabled    = true,
    showOnJoin = true,
    bar    = { r = 45,  g = 110, b = 185, a = 255 },
    circle = { r = 0,   g = 0,   b = 0,   a = 186 },
}

-- Level perks. EMPTY = disabled (nothing changes on your server). The highest
-- entry whose level <= player level applies. hp = extra max health on top of
-- 100, armor = max armour. Example:
--   Config.LevelPerks = { { level = 10, hp = 10, armor = 20 }, { level = 30, hp = 30, armor = 50 } }
Config.LevelPerks = {}

-- Minimum level to hold a weapon. EMPTY = disabled. Example: { WEAPON_RPG = 40, WEAPON_MINIGUN = 60 }
Config.WeaponMinLevel = {}


-- Achievements (Unique-style: points, hidden "first player to ..." badges).
-- kind = level (reach level `value`) | quests (complete `value` quests) |
--        skill (finish skill `key`) | skillFirst (first player on the server to finish `key`, hidden)
Config.Achievements = {
    level_10   = { label = 'Getting Started',  description = 'Reach level 10',  point = 10, kind = 'level', value = 10 },
    level_25   = { label = 'Rising Star',      description = 'Reach level 25',  point = 20, kind = 'level', value = 25 },
    level_50   = { label = 'Veteran',          description = 'Reach level 50',  point = 40, kind = 'level', value = 50 },
    level_100  = { label = 'Legend',           description = 'Reach level 100', point = 100, kind = 'level', value = 100 },
    quests_10  = { label = 'Errand Runner',    description = 'Complete 10 quests',  point = 10, kind = 'quests', value = 10 },
    quests_50  = { label = 'Quest Hunter',     description = 'Complete 50 quests',  point = 25, kind = 'quests', value = 50 },
    quests_200 = { label = 'Quest Master',     description = 'Complete 200 quests', point = 60, kind = 'quests', value = 200 },
    mining_skillup   = { label = 'Mining Connoisseur',   description = 'Max out the Miner skill',      point = 20, kind = 'skill', key = 'miner_skill' },
    chobbori_skillup = { label = 'Timber King',          description = 'Max out the Lumberjack skill', point = 20, kind = 'skill', key = 'chobbori_skill' },
    fueler_skillup   = { label = 'Refinery Expert',      description = 'Max out the Refinery skill',   point = 20, kind = 'skill', key = 'palayeshgah_skill' },
    ghasab_skillup   = { label = 'Chop Chop Champion',   description = 'Max out the Slaughterer skill', point = 20, kind = 'skill', key = 'ghasab_skill' },
    clothe_skillup   = { label = 'Tailoring Specialist', description = 'Max out the Tailor skill',    point = 20, kind = 'skill', key = 'clothe_skill' },
    first_mining     = { label = 'First Mining Connoisseur', description = 'First on the server to max the Miner skill',      point = 0, hidden = true, kind = 'skillFirst', key = 'miner_skill' },
    first_chobbori   = { label = 'First Timber King',        description = 'First on the server to max the Lumberjack skill', point = 0, hidden = true, kind = 'skillFirst', key = 'chobbori_skill' },
    first_fueler     = { label = 'First Refinery Expert',    description = 'First on the server to max the Refinery skill',   point = 0, hidden = true, kind = 'skillFirst', key = 'palayeshgah_skill' },
    first_ghasab     = { label = 'First Chop Chop Champion', description = 'First on the server to max the Slaughterer skill', point = 0, hidden = true, kind = 'skillFirst', key = 'ghasab_skill' },
    first_clothe     = { label = 'First Tailoring Specialist', description = 'First on the server to max the Tailor skill',  point = 0, hidden = true, kind = 'skillFirst', key = 'clothe_skill' },
}

-- Quest giver NPCs (Unique-style). Walk up, press E -> the menu opens on the QUESTS tab.
-- The coords below are only an EXAMPLE (Legion Square) - put your own.
Config.QuestNPCs = {
    { label = 'Quest Giver', model = 'a_m_m_business_01', coords = { x = 195.17, y = -933.77, z = 30.69, h = 144.0 }, blip = true },
}
Config.QuestNPCDistance = 2.0

-- Weekly quests (Unique-style): every player gets all of them, progress resets on Monday 00:00
-- (server time). Triggers are the same server-side quest-* events the daily quests use;
-- do NOT use the client-reachable ones (:onduty, :acceptreq, quest-cafe:bill) here.
Config.WeeklyQuests = {
    { name = 'Weekly Miner',       description = 'Mine 200 stones',          trigger = 'quest-jobcenter:stonemine', requiredTrigger = 200, XP = 400, coin = 3 },
    { name = 'Stone Washer',       description = 'Wash stone 100 times',     trigger = 'quest-jobcenter:washstone', requiredTrigger = 100, XP = 350, coin = 2 },
    { name = 'Timber Delivery',    description = 'Deliver lumber 50 times',  trigger = 'quest-lumberjack:deliver',  requiredTrigger = 50,  XP = 300, coin = 2 },
    { name = 'Refinery Delivery',  description = 'Deliver fuel 50 times',    trigger = 'quest-fueler:deliver',      requiredTrigger = 50,  XP = 300, coin = 2 },
}


-- ===== Unique level curve =====
-- Unique quest's table (config.Levels[n] there is "xp to go from level n-1 to n"),
-- mapped to this resource's convention (config.Levels[rank] = xp needed at `rank`
-- to reach rank+1). Levels 1-49 are Unique's exact numbers. Unique stops at 50; this
-- server goes to 100, so 50+ continue Unique's own +100-per-level pattern and
-- nobody's existing rank becomes invalid. Set to false to get the old curve back.
Config.UseUniqueLevels = true
if Config.UseUniqueLevels then
    local Unique = {
        100,200,200,200,300,300,300,300,400,400,400,400,500,500,600,700,800,900,1000,1100,
        1200,1300,1400,1500,1600,1700,1800,1900,2000,2100,2200,2300,2400,2500,2600,2700,2800,2900,3000,3100,
        3200,3300,3400,3500,3600,3700,3800,3900,4000,
    }
    for rank = 1, 100 do
        config.Levels[rank] = Unique[rank] or (4000 + (rank - 49) * 100)
    end
end

-- ===== Quest givers (Unique-style) =====
-- true  = quests can only be ACCEPTED / CLAIMED while standing at a quest giver NPC
--         (the I menu then only shows them). The server checks the distance.
Config.QuestAcceptOnlyAtNPC = true
Config.QuestNPCServerDistance = 8.0 -- metres, server-side check (needs OneSync; without it the check is skipped)

-- Reward choice: when a quest is finished the reward waits (until midnight, when the
-- daily quests reset) for the player to claim it at the NPC, choosing ONE option.
-- xpMul / coinMul multiply the quest's own XP / coin. Set enabled = false for instant rewards.
Config.QuestRewardChoice = {
    enabled = true,
    options = {
        { label = 'More XP',   xpMul = 1.5, coinMul = 0.5 },
        { label = 'More Coin', xpMul = 0.5, coinMul = 1.5 },
    },
}

-- ===== Unique level perks (HP / armour by level) =====
-- Unique's tables: max health = 100 + bonus where bonus = 99+lvl (lvl 1-10) / 100+lvl (11-50)
-- (200 at level 1 -> 250 at level 50); max armour = 50 + 2*lvl from level 26 (102 -> 150).
-- Level 50+ keeps the level-50 values (Unique stops at 50). Generated here so the table is
-- not 50 lines long. Set Config.UseUniquePerks = false to disable, or write Config.LevelPerks yourself.
Config.UseUniquePerks = true
if Config.UseUniquePerks then
    Config.LevelPerks = {}
    for lvl = 1, 50 do
        local perk = { level = lvl, hp = (lvl <= 10) and (99 + lvl) or (100 + lvl) }
        if lvl >= 26 then perk.armor = 50 + 2 * lvl end
        Config.LevelPerks[#Config.LevelPerks + 1] = perk
    end
end

-- ===== newbie restriction (Unique: level 1 cannot attack) =====
-- Players at level <= maxLevel can't shoot, aim, reload or melee. Jobs listed in
-- exemptJobs (and their off-duty 'off<job>' variant) are never restricted.
Config.NewbieRestriction = {
    enabled = true,
    maxLevel = 1,
    exemptJobs = { police = true, sheriff = true, metropolitan = true, ambulance = true },
    message = 'You must reach level 2 before you can fight',
}


-- ===== Weapon skills (Unique-style) =====
-- One skill per weapon, key = '<weapon name without WEAPON_>_skill' (same naming Unique uses, so
-- exports.Unique_LevelQuest:IsWeaponSkillFinished('WEAPON_PISTOL') maps straight onto it).
-- Progress comes from PLAYER kills made with that weapon: each kill adds `Config.WeaponSkillKill`
-- percent. Anti-farm: the victim must really be dead on the server (OneSync), and the same
-- killer/victim pair only counts once per `Config.WeaponSkillPairCooldown` seconds.
-- At 100% the weapon is "mastered": one-time coin reward (Config.SkillFinishCoin) + an
-- 'Unique_LevelQuest:skillFinished' event + the IsWeaponSkillFinished export for your own
-- shops/crafting (Unique gates its weapon factory on exactly this).
Config.WeaponSkillKill = 0.20
Config.WeaponSkillPairCooldown = 600
Config.WeaponSkillList = {
    { 'pistol', 'Pistol' },
    { 'pistol_mk2', 'Pistol Mk2' },
    { 'combatpistol', 'Combat Pistol' },
    { 'appistol', 'Ap Pistol' },
    { 'pistol50', 'Pistol.50' },
    { 'snspistol', 'SNS Pistol' },
    { 'snspistol_mk2', 'Sns Pistol Mk2' },
    { 'heavypistol', 'Heavy Pistol' },
    { 'vintagepistol', 'Vintage Pistol' },
    { 'doubleaction', 'Doubleaction' },
    { 'ceramicpistol', 'Ceramic Pistol' },
    { 'gadgetpistol', 'Gadget Pistol' },
    { 'marksmanpistol', 'Marksman Pistol' },
    { 'pistolxm3', 'Pistol XM3' },
    { 'revolver', 'Revolver' },
    { 'revolver_mk2', 'Revolver Mk2' },
    { 'navyrevolver', 'Navy Revolver' },
    { 'machinepistol', 'Machine Pistol' },
    { 'smg', 'Smg' },
    { 'smg_mk2', 'Smg Mk2' },
    { 'assaultsmg', 'Assault Smg' },
    { 'microsmg', 'Micro Smg' },
    { 'minismg', 'Mini SMG' },
    { 'tecpistol', 'Tactical SMG' },
    { 'combatpdw', 'CombatPDW' },
    { 'pumpshotgun', 'Pump Shotgun' },
    { 'pumpshotgun_mk2', 'Pump Shotgun Mk2' },
    { 'sawnoffshotgun', 'SawnOff Shotgun' },
    { 'assaultshotgun', 'Assault Shotgun' },
    { 'bullpupshotgun', 'Bullpup Shotgun' },
    { 'combatshotgun', 'Combat Shotgun' },
    { 'autoshotgun', 'Auto Shotgun' },
    { 'dbshotgun', 'DB Shotgun' },
    { 'heavyshotgun', 'Heavy Shotgun' },
    { 'assaultrifle', 'Assault Rifle' },
    { 'assaultrifle_mk2', 'Assault Rifle Mk2' },
    { 'carbinerifle', 'Carbine Rifle' },
    { 'carbinerifle_mk2', 'Carbine Rifle Mk2' },
    { 'advancedrifle', 'Advanced Rifle' },
    { 'specialcarbine', 'Special Carbine' },
    { 'specialcarbine_mk2', 'Special Carbine Mk2' },
    { 'bullpuprifle', 'Bullpup Rifle' },
    { 'bullpuprifle_mk2', 'Bullpup Rifle Mk2' },
    { 'compactrifle', 'Compact Rifle' },
    { 'militaryrifle', 'Military Rifle' },
    { 'tacticalrifle', 'Tactical Rifle' },
    { 'heavyrifle', 'Heavy Rifle' },
    { 'gusenberg', 'GusenBerg' },
    { 'combatmg', 'Combat MG' },
    { 'combatmg_mk2', 'Combat MG Mk2' },
    { 'mg', 'MG' },
}
for _, w in ipairs(Config.WeaponSkillList) do
    Config.Skills[w[1] .. '_skill'] = {
        label = w[2], weapon = true, weaponName = 'WEAPON_' .. w[1]:upper(),
        addType = { kill = Config.WeaponSkillKill },
    }
end


-- ===== Mastery skins (Unique-style weapon tints) =====
-- A weapon whose skill reached 100% unlocks skins for it. The player picks one in the
-- WEAPON SKILL tab (stored per weapon, applied every time that weapon is in the loadout).
-- Until they choose, the DEFAULT skin below is applied automatically.
-- Tint indices + names are Unique's own (factory-config.lua): standard weapons 0-7, Mk2 weapons 0-12.
Config.WeaponSkins = {
    enabled = true,
    defaultTint = 2,      -- Gold, for normal weapons
    defaultTintMk2 = 9,   -- Red Contrast, for *_MK2 weapons
    standard = { [0] = 'No skin', 'Green', 'Gold', 'Pink', 'Army', 'Blue', 'Orange', 'Platinum' },
    mk2 = { [0] = 'No skin', 'Gray', 'Two-Tone', 'White', 'Beige', 'Green', 'Blue', 'Earth', 'Brown & Black',
            'Red Contrast', 'Blue Contrast', 'Yellow Contrast', 'Orange Contrast' },
}

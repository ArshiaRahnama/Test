ConfigWashMoney = {}

ConfigWashMoney.PoliceNeededToWash = 2          -- min cops on duty required to start washing
ConfigWashMoney.ProcessDuration    = 20000      -- ms, must match the progress bar length
ConfigWashMoney.AlarmCooldown      = 20         -- seconds between police alarms per location

ConfigWashMoney.Locations = {
    {
        Name          = 'Vinewood',
        Pos           = vector3(1355.3375244141, -531.04150390625, 73.891670227051),
        BlackMoney    = 50000,
        PayoutPercent = {60, 60},
        ViewDistance  = 15.0,
    },
    {
        Name          = 'Sandy',
        Pos           = vector3(2851.5234375, 3439.033203125, 50.854198455811),
        BlackMoney    = 50000,
        PayoutPercent = {60, 60},
        ViewDistance  = 5.0,
    },
}

-- Jobs eligible to receive the government cut, but ONLY the ones whose boss
-- has enabled "wash money" from the esx_society boss-action menu (jobs.washmoney
-- column). Jobs sharing the same society account are automatically deduped, so
-- the shared pool is only paid once even if several of its jobs have the toggle
-- on. UPDATE: expanded from just {police, sheriff, mt, fbi, cia} to the full
-- Department Of Justice + Law Enforcement roster (esx_uniquejobs'
-- shared/departments.lua 'doj'+'le' departments), per request.
ConfigWashMoney.GovernmentJobs = {'police', 'sheriff', 'mt', 'cid', 'cia', 'marshal', 'fbi', 'judge', 'doa'}

-- Set-style lookup (O(1)) instead of looping an array every check
ConfigWashMoney.BlackListedJobs = {
    -- BUG FIX: this used to say `metropolitan`/`offmetropolitan` -- MT's real
    -- job name (see esx_uniquejobs/shared/departments.lua) is `mt`, not
    -- `metropolitan`, so this entry never matched anyone and MT officers were
    -- never actually blocked from laundering money themselves.
    police          = true,
    offpolice       = true,
    sheriff         = true,
    offsheriff      = true,
    mt              = true,
    offmt           = true,
    fbi             = true,
    offfbi          = true,
    -- FEATURE ADDED: the rest of DOJ (cid/cia/marshal/judge/doa) is now also
    -- eligible for the government cut above, so blacklisted from personally
    -- laundering too, for the same reason police/sheriff/mt/fbi already were
    -- -- a government job shouldn't be able to be both the launderer and the
    -- one collecting the cut on its own laundering.
    cid             = true,
    offcid          = true,
    cia             = true,
    offcia          = true,
    marshal         = true,
    offmarshal      = true,
    judge           = true,
    offjudge        = true,
    doa             = true,
    offdoa          = true,
    ambulance       = true,
    mechanic        = true,
    taxi            = true,
    -- add more restricted jobs here
}

-- FEATURE ADDED: lets other resources (esx_society's boss-action menu) ask
-- "is this job actually one of the ones the wash-money government cut
-- applies to?" without keeping their own separate copy of GovernmentJobs in
-- sync by hand. Defined here since washmoney_config.lua already loads on
-- both sides (see fxmanifest.lua's client_scripts/server_scripts), so this
-- registers as both a client and a server export automatically.
function IsWashMoneyEligibleJob(jobName)
    for i = 1, #ConfigWashMoney.GovernmentJobs do
        if ConfigWashMoney.GovernmentJobs[i] == jobName then return true end
    end
    return false
end
exports('IsWashMoneyEligibleJob', IsWashMoneyEligibleJob)

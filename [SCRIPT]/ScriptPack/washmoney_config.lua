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
-- column). Jobs sharing the same society account (police/sheriff/mt -> society_law,
-- fbi/cia -> society_doj) are automatically deduped, so the shared pool is only
-- paid once even if several of its jobs have the toggle on.
ConfigWashMoney.GovernmentJobs = {'police', 'sheriff', 'mt', 'fbi', 'cia'}

-- Set-style lookup (O(1)) instead of looping an array every check
ConfigWashMoney.BlackListedJobs = {
    police          = true,
    offpolice       = true,
    sheriff         = true,
    offsheriff      = true,
    metropolitan    = true,
    offmetropolitan = true,
    fbi             = true,
    offfbi          = true,
    ambulance       = true,
    mechanic        = true,
    taxi            = true,
    -- add more restricted jobs here
}

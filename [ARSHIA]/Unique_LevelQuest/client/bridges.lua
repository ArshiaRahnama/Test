-- ================================================================= --
-- Bridges: client-side. These listen to events that OTHER resources
-- already fire (essentialmode's paycheck, esx_organserver's ambulance/
-- mechanic jobs) and forward the matching quest trigger to the server.
-- None of those other resources' files were modified.
-- ================================================================= --

local ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local onDutyJobs = {
    police    = 'quest-police:onduty',
    sheriff   = 'quest-sheriff:onduty',
    mt        = 'quest-metropolitan:onduty', -- internal job name is `mt`; event name kept as-is, just an identifier
    ambulance = 'quest-ambulance:onduty',
    mechanic  = 'quest-mechanic:onduty',
    taxi      = 'quest-taxi:onduty',

    -- uniquecafejobs: 17 cafe/restaurant jobs + 4 holdings, each with its
    -- own quest-cafe-onduty:<job> trigger (see config.lua's per-job Onduty
    -- entries) so they track independently just like every job above.
    uwucafe = 'quest-cafe-onduty:uwucafe', obsidian = 'quest-cafe-onduty:obsidian',
    voltage = 'quest-cafe-onduty:voltage', ember = 'quest-cafe-onduty:ember',
    anchor = 'quest-cafe-onduty:anchor', crimson = 'quest-cafe-onduty:crimson',
    flourish = 'quest-cafe-onduty:flourish', goldcrust = 'quest-cafe-onduty:goldcrust',
    carwash = 'quest-cafe-onduty:carwash', firebrick = 'quest-cafe-onduty:firebrick',
    slice = 'quest-cafe-onduty:slice', frostbite = 'quest-cafe-onduty:frostbite',
    sundae = 'quest-cafe-onduty:sundae', static = 'quest-cafe-onduty:static',
    nightjar = 'quest-cafe-onduty:nightjar', koi = 'quest-cafe-onduty:koi',
    wasabi = 'quest-cafe-onduty:wasabi',
    meridian = 'quest-cafe-onduty:meridian', blacktide = 'quest-cafe-onduty:blacktide',
    cratecarry = 'quest-cafe-onduty:cratecarry', turfco = 'quest-cafe-onduty:turfco',
}

-- Tracked for the paycheck countdown in the header (client/menu.lua).
-- Client-side globals, shared across files in this same resource.
-- LastPaycheckTime is only a GUESS until the first real esx:givesalary
-- event is observed (we have no way to read essentialmode's actual
-- internal cycle start time — resources can't read each other's
-- state), so PaycheckSynced tracks whether it's trustworthy yet.
LastPaycheckTime = GetGameTimer()
PaycheckSynced = false

-- essentialmode's paycheck.lua fires this client event on every salary
-- tick, for any player with a job (grade >= 0). We just filter it down
-- to the jobs our quest system tracks.
RegisterNetEvent('esx:givesalary')
AddEventHandler('esx:givesalary', function()
    LastPaycheckTime = GetGameTimer()
    PaycheckSynced = true

    if not ESX then return end
    local playerData = ESX.GetPlayerData()
    local job = playerData and playerData.job and playerData.job.name
    local trig = job and onDutyJobs[job]
    if trig then
        TriggerServerEvent(trig)
    end
    if job and Config.TrackedJobs[job] then
        TriggerServerEvent('skill-track:tick')
    end
end)

-- esx_organserver's ambulance/mechanic job scripts fire these on the
-- responder's client only when a request is genuinely accepted.
RegisterNetEvent('esx_ambulancejob:acceptreq')
AddEventHandler('esx_ambulancejob:acceptreq', function()
    TriggerServerEvent('quest-ambulance:acceptreq')
end)

RegisterNetEvent('esx_mechanicjob:acceptreq')
AddEventHandler('esx_mechanicjob:acceptreq', function()
    TriggerServerEvent('quest-mechanic:acceptreq')
end)

RegisterNetEvent('esx_taxijob:acceptreq')
AddEventHandler('esx_taxijob:acceptreq', function()
    TriggerServerEvent('quest-taxi:acceptreq')
end)

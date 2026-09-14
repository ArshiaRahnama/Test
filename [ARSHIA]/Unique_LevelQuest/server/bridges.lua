-- ================================================================= --
-- Bridges: server-side (this file adds ADDITIONAL handlers onto event
-- names that esx_drugs / esx_organserver already fire — FXServer allows
-- multiple resources to listen to the same event name, so none of
-- those resources' own files were touched).
-- ================================================================= --

local function bump(triggerName, source)
    TriggerEvent(triggerName, source)
end

-- The 9 jobs that Unique_Punishment/server/jail.lua (IsJobAllowed) and
-- every esx_billing:send2Bill fine call site in esx_uniquejobs have in
-- common -- shared here so both the jail and fine bridges below stay in
-- sync with each other by construction.
local JAILABLE_JOBS = {
    police = true, sheriff = true, mt = true,
    cid = true, cia = true, marshal = true, fbi = true, judge = true, doa = true,
}

-- ===== Drugs (esx_drugs) — pickups ===== --
AddEventHandler('esx_jk_drugs:pickedUpCannabis', function() TriggerEvent('quest-drug:cannabis') end)
AddEventHandler('esx_jk_drugs:pickedUpCocaPlant', function() TriggerEvent('quest-drug:coca') end)
AddEventHandler('esx_jk_drugs:pickedUpEphedra',   function() TriggerEvent('quest-drug:ephedra') end)
AddEventHandler('esx_jk_drugs:pickedUpmushroom',  function() TriggerEvent('quest-drug:mushroom') end)
AddEventHandler('esx_jk_drugs:pickedUpPoppy',     function() TriggerEvent('quest-drug:poppy') end)

-- ===== Drugs (esx_drugs) — processing ===== --
AddEventHandler('esx_jk_drugs:processCannabis',  function() TriggerEvent('quest-drug:marijuana') end)  -- cannabis -> marijuana
AddEventHandler('esx_jk_drugs:processCocaPlant', function() TriggerEvent('quest-drug:cocaine') end)    -- coca -> cocaine
AddEventHandler('esx_jk_drugs:processEphedra',   function() TriggerEvent('quest-drug:ephedrine') end)  -- ephedra -> ephedrine
AddEventHandler('esx_jk_drugs:processEphedrine', function() TriggerEvent('quest-drug:meth') end)       -- ephedrine -> meth
AddEventHandler('esx_jk_drugs:processCoke',      function() TriggerEvent('quest-drug:crack') end)      -- cocaine -> crack
AddEventHandler('esx_jk_drugs:processPoppy',     function() TriggerEvent('quest-drug:opium') end)      -- poppy -> opium
AddEventHandler('esx_jk_drugs:processOpium',     function() TriggerEvent('quest-drug:heroine') end)    -- opium -> heroine

-- ===== Drugs (esx_drugs) — selling ===== --
-- esx_drugs:sellDrug(itemName, amount) covers every drug through one
-- event, so route by itemName to the matching "sell" quest.
local sellQuestByItem = {
    marijuana = 'quest-drug:sellmarjuana',
    cocaine   = 'quest-drug:sellcocaine',
    crack     = 'quest-drug:sellcrack',
    heroine   = 'quest-drug:sellheroine',
    meth      = 'quest-drug:sellmeth',
    mushroom  = 'quest-drug:sellmushroom',
}
AddEventHandler('esx_drugs:sellDrug', function(itemName)
    local trig = sellQuestByItem[itemName]
    if trig then TriggerEvent(trig) end
end)

-- ===== Ambulance (esx_organserver) — revive ===== --
-- esx_organserver's ambulance revivex handler fires this local log event
-- only on a SUCCESSFUL revive, with `source` still equal to the medic who
-- performed it (nested same-tick TriggerEvent, no network hop).
--
-- CIA/FBI arrests below use the same global-`source` trust, because
-- esx_cia_job:requestarrest / esx_fbi_job:requestarrest are genuine
-- RegisterServerEvent handlers (network-triggered from the client), so
-- `source` is set correctly by the FX runtime for the whole nested call
-- chain -- same reasoning as the ambulance case.
--
-- Weazel's "Camera Toggled" is different: it comes from a RegisterCommand
-- (`/cam`), which -- like the /cs command bug fixed earlier in
-- Unique_Punishment -- never sets the ambient global `source` at all.
-- weazel_cam_server.lua now passes the real source explicitly as a 4th
-- arg for exactly that reason; read that instead of the global for it.
AddEventHandler('esx_society:logAction', function(job, action, _fields, explicitSource)
    if job == 'ambulance' and action == 'Player Revived' then
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        if xPlayer and xPlayer.job.name == 'ambulance' then
            TriggerEvent('quest-ambulance:revive', _source)
        end
    elseif job == 'cia' and action == 'Player Arrested' then
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        if xPlayer and xPlayer.job.name == 'cia' then
            TriggerEvent('quest-cia:arrest', _source)
        end
    elseif job == 'fbi' and action == 'Player Arrested' then
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        if xPlayer and xPlayer.job.name == 'fbi' then
            TriggerEvent('quest-fbi:arrest', _source)
        end
    elseif job == 'weazel' and action == 'Camera Toggled' then
        local xPlayer = ESX.GetPlayerFromId(explicitSource)
        if xPlayer and xPlayer.job.name == 'weazel' then
            TriggerEvent('quest-weazel:broadcast', explicitSource)
        end

    -- FEATURE ADDED: police/sheriff/mt cuffing. All three share ONE
    -- handler in esx_uniquejobs (server/police_main.lua's esx:requestarrestpd),
    -- which now fires this log right after a successful cuff, with
    -- `source` = the officer (genuine RegisterServerEvent, network-
    -- triggered from the officer's own client -- same trust basis as the
    -- CIA/FBI arrests above). FBI is deliberately NOT handled here: it
    -- logs 'Player Cuffed' from its own separate event and would double-
    -- count if it also matched this branch.
    elseif (job == 'police' or job == 'sheriff' or job == 'mt') and action == 'Player Cuffed' then
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        if xPlayer and xPlayer.job.name == job then
            TriggerEvent('quest-' .. job .. ':cuff', _source)
        end

    -- FEATURE ADDED: jailing. Unique_Punishment/server/jail.lua fires this
    -- from inside the `type == 'faction'` branch of arshia_jail:sendto (a
    -- genuine RegisterServerEvent), only after IsJobAllowed(...) already
    -- verified the officer's job -- covers all 9 jobs that resource allows
    -- to jail (mirrors its own Config.AllowedJobs list).
    elseif action == 'Player Jailed' and JAILABLE_JOBS[job] then
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        if xPlayer and xPlayer.job.name == job then
            TriggerEvent('quest-' .. job .. ':jail', _source)
        end

    -- FEATURE ADDED: mechanic repairs. See server/mechanic_main.lua's
    -- esx_mechanicjob:reportRepair for why this needed a brand new event
    -- (repair previously had no server round-trip at all) and its cooldown
    -- for why this is safe to trust at the same level as the rest of this
    -- job's client-reported actions.
    elseif job == 'mechanic' and action == 'Vehicle Repaired' then
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        if xPlayer and xPlayer.job.name == 'mechanic' then
            TriggerEvent('quest-mechanic:repair', _source)
        end
    end
end)

-- ===== Fines (esx_billing) — police/sheriff/mt/cid/cia/fbi/marshal/judge/doa ===== --
-- esx_billing:send2Bill(target, society, label, amount) is a genuine
-- RegisterServerEvent fired from the ISSUING OFFICER's own client menu in
-- every one of these jobs' client/*_main.lua (the citizen being fined
-- never touches this event at all) -- so `source` here is always the
-- officer. One universal hook covers all 9 jobs instead of duplicating
-- this per job.
local FINEABLE_JOBS = JAILABLE_JOBS -- same 9 jobs use esx_billing:send2Bill for fines
AddEventHandler('esx_billing:send2Bill', function(_target, _society, _label, _amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer and FINEABLE_JOBS[xPlayer.job.name] then
        TriggerEvent('quest-' .. xPlayer.job.name .. ':fine', _source)
    end
end)

-- ===== Service bills (taxi/ambulance/mechanic) ===== --
-- IMPORTANT: this deliberately does NOT hook esx_billing:send2Bill2.
-- Traced that event for all three jobs and its `source` is actually the
-- CUSTOMER confirming the bill in esx_{taxi,ambulance,mechanic}job:Open-
-- MenuDialog, not the driver/medic/mechanic -- bridging it directly would
-- silently hand quest credit to whichever passenger/patient/customer
-- happens to have a tracked job. The safe, provider-attributed point is
-- one step earlier: esx_{taxi,ambulance,mechanic}job:blingrequest, a
-- genuine RegisterNetEvent triggered by the provider's OWN client when
-- they request the charge (esx_uniquejobs already calls RegisterNetEvent
-- for all three in its own server files, so no need to repeat that here --
-- same reasoning as the drug-pickup bridges above).
AddEventHandler('esx_taxijob:blingrequest', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer and xPlayer.job.name == 'taxi' then
        TriggerEvent('quest-taxi:bill', _source)
    end
end)

AddEventHandler('esx_ambulancejob:blingrequest', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer and xPlayer.job.name == 'ambulance' then
        TriggerEvent('quest-ambulance:bill', _source)
    end
end)

AddEventHandler('esx_mechanicjob:blingrequest', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer and xPlayer.job.name == 'mechanic' then
        TriggerEvent('quest-mechanic:bill', _source)
    end
end)

-- ===== Judge (esx_uniquejobs) — record a verdict ===== --
-- esx_uniquejobs:dojRecordVerdict (server/court_docket.lua) is a genuine
-- RegisterServerEvent, and the ONLY job allowed to call it successfully
-- is judge (isJudge(...) check inside that handler rejects everyone
-- else and sends them an error notification instead) -- re-checked here
-- too since this fires before that handler's own async DB lookup
-- confirms the docket id was real.
local VALID_VERDICTS = { guilty = true, not_guilty = true, plea_deal = true }
AddEventHandler('esx_uniquejobs:dojRecordVerdict', function(docketId, verdict)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer and xPlayer.job.name == 'judge' and VALID_VERDICTS[verdict] then
        TriggerEvent('quest-judge:verdict', _source)
    end
end)

-- ===== Mining (esx_minerjob) — no job requirement, open to anyone ===== --
-- esx_minerjob already fires 'TaskSystem:FarmSang' / 'TaskSystem:FroshAjor'
-- / 'TaskSystem:GharbaleSang' as CLIENT events (to the source player), so
-- we can listen for the same underlying SERVER events it reacts to and
-- stay in sync without needing a client bridge for those three.
AddEventHandler('mining:PutStoneInVehicle', function() TriggerEvent('quest-jobcenter:stonemine') end)
AddEventHandler('mining:SellStone',         function() TriggerEvent('quest-jobcenter:sellstone') end)
AddEventHandler('mining:WashStonePieces',   function() TriggerEvent('quest-jobcenter:washstone') end)

-- mining:MeltItems has no hook of its own upstream; add one here, routed
-- by the same `type` argument esx_minerjob's own handler already uses.
AddEventHandler('mining:MeltItems', function(smeltType)
    if smeltType == 'iron_piece' then
        TriggerEvent('quest-jobcenter:zobahan')
    elseif smeltType == 'gold_piece' then
        TriggerEvent('quest-jobcenter:zobtala')
    end
end)

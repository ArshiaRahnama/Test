-- ================================================================= --
-- Bridges: server-side (this file adds ADDITIONAL handlers onto event
-- names that esx_drugs / esx_organserver already fire — FXServer allows
-- multiple resources to listen to the same event name, so none of
-- those resources' own files were touched).
-- ================================================================= --

local function bump(triggerName, source)
    TriggerEvent(triggerName, source)
end

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

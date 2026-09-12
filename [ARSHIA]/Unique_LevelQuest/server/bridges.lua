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
AddEventHandler('esx_society:logAction', function(job, action)
    if job == 'ambulance' and action == 'Player Revived' then
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        if xPlayer and xPlayer.job.name == 'ambulance' then
            TriggerEvent('quest-ambulance:revive', _source)
        end
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

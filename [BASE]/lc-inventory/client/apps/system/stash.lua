-------------------------------------------------------------------
-- Generic "stash" (shared/ground storage) client for lc-inventory.
--
-- lc-inventory doesn't ship a shared-storage container out of the box
-- (only player inventory, vehicle trunk, and player-to-player loot).
-- This adds one, exposed the same way the previous inventory did:
--
--     exports['lc-inventory']:stash(stashId, maxWeight, slot, label)
--
-- so external resources (e.g. Unique_ALLGangs' gang armories, see
-- Unique_ALLGangs/client/main.lua) don't need to change how they call
-- into the inventory resource - only which resource name they call.
--
-- Reuses the existing "trunk" second-inventory UI/NUI plumbing (weight
-- bar, drag/drop, PutIntoTrunk/TakeFromTrunk NUI callbacks) since it
-- already does everything a stash needs. CurrentStashId is the switch
-- client/apps/system/trunk.lua and client/main.lua check to tell a
-- real vehicle trunk apart from a stash session.
-------------------------------------------------------------------

CurrentStashId = nil
local StashData = { items = {}, weight = 0, maxWeight = 0, label = '' }

local function refreshStashUI()
    local weight = tonumber(StashData.weight) or 0
    local maxWeight = tonumber(StashData.maxWeight) or 0

    SendNUIMessage({
        action = "trunk:WeightBarText",
        weightTrunk = weight,
        maxWeightTrunk = maxWeight,
        textTrunk = weight .. " / " .. maxWeight .. Locales[Config.Language]['weight_unity'],
        plate = StashData.label or ''
    })

    SendNUIMessage({
        action = "setSecondInventoryItems",
        itemList = StashData.items or {}
    })
end

function LoadStashData(stashId, maxWeight, label, cb)
    TriggerServerCallback("lc-inventory:getStash", function(data)
        StashData = data or { items = {}, weight = 0, maxWeight = maxWeight, label = label }
        if CurrentStashId == stashId then
            refreshStashUI()
        end
        if cb then cb() end
    end, stashId, maxWeight, label)
end

function OpenStash(stashId, maxWeight, slot, label)
    if not stashId then return end
    if Inv.isInInventory or Inv.isInTrunk or Inv.openInvPlayer or Inv.isInProperty or CurrentStashId then
        return
    end

    CurrentStashId = stashId
    TriggerServerEvent('lc-inventory:stashViewer', stashId, true)

    LoadStashData(stashId, maxWeight, label, function()
        Inv.isInTrunk = true

        DisplayRadar(false)
        SetNuiFocus(true, true)

        loadPlayerInventory('trunk', nil, true, true)

        SendNUIMessage({
            action = "open:Inv",
            type = "trunk"
        })

        SetTimecycleModifier("Bloom")
        SetTimecycleModifierStrength(1.50)
        Inventaire:hideHUD()
        TriggerScreenblurFadeIn(0)
    end)
end

exports('stash', OpenStash)

RegisterNetEvent('lc-inventory:stashUpdated')
AddEventHandler('lc-inventory:stashUpdated', function(stashId)
    if CurrentStashId == stashId then
        LoadStashData(stashId, StashData.maxWeight, StashData.label)
    end
end)

-------------------------------------------------------------------
-- Called from client/apps/system/trunk.lua's PutIntoTrunk/TakeFromTrunk
-- NUI callbacks when CurrentStashId is set (i.e. this is a stash
-- session, not a real vehicle trunk).
-------------------------------------------------------------------

function HandleStashPut(data, cb)
    local item = data.item

    if item.type == 'item_weapon' then
        if not Config.WeaponNoGive[item.name] then
            local playerPed = PlayerPedId()
            local weaponHash = GetSelectedPedWeapon(playerPed)
            if GetWeapontypeModel(weaponHash) == item.name then
                SetCurrentPedWeapon(playerPed, 'WEAPON_UNARMED', true)
            end
            TriggerServerEvent('lc-inventory:stashDeposit', CurrentStashId, 'item_weapon', item.name, 1)
            Wait(150)
            LoadStashData(CurrentStashId, StashData.maxWeight, StashData.label)
        end
    elseif item.type == 'item_account' then
        KeyboardUtils.use(Locales[Config.Language]['quantite'], function(result)
            if result ~= nil and tonumber(result) then
                TriggerServerEvent('lc-inventory:stashDeposit', CurrentStashId, 'item_account', item.name, tonumber(result))
                Wait(150)
                LoadStashData(CurrentStashId, StashData.maxWeight, StashData.label)
            end
        end)
    elseif item.type == 'item_standard' then
        KeyboardUtils.use(Locales[Config.Language]['quantite'], function(result)
            if result ~= nil and tonumber(result) then
                TriggerServerEvent('lc-inventory:stashDeposit', CurrentStashId, 'item_standard', item.name, tonumber(result))
                Wait(150)
                LoadStashData(CurrentStashId, StashData.maxWeight, StashData.label)
            end
        end)
    end

    cb("ok")
end

function HandleStashTake(data, cb)
    local item = data.item

    if item.type == 'item_weapon' then
        if not Config.WeaponNoGive[item.name] then
            TriggerServerEvent('lc-inventory:stashWithdraw', CurrentStashId, 'item_weapon', item.name, 1)
            Wait(150)
            LoadStashData(CurrentStashId, StashData.maxWeight, StashData.label)
        end
    elseif item.type == 'item_account' then
        KeyboardUtils.use(Locales[Config.Language]['quantite'], function(result)
            if result ~= nil and tonumber(result) then
                TriggerServerEvent('lc-inventory:stashWithdraw', CurrentStashId, 'item_account', item.name, tonumber(result))
                Wait(150)
                LoadStashData(CurrentStashId, StashData.maxWeight, StashData.label)
            end
        end)
    elseif item.type == 'item_standard' then
        KeyboardUtils.use(Locales[Config.Language]['quantite'], function(result)
            if result ~= nil and tonumber(result) then
                TriggerServerEvent('lc-inventory:stashWithdraw', CurrentStashId, 'item_standard', item.name, tonumber(result))
                Wait(150)
                LoadStashData(CurrentStashId, StashData.maxWeight, StashData.label)
            end
        end)
    end

    cb("ok")
end

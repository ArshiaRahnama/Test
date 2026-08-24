--[[
    BRIDGE RESOURCE — essentialmode  ->  es_extended (fake)
    ---------------------------------------------------------
    essentialmode STAYS untouched. This resource only wraps its
    existing ESX shared object (already exposed via the classic
    "esx:getSharedObject" event that essentialmode fires) and
    patches on the few extra fields that ox_inventory expects
    from a real es_extended ('1.6.0'+):

        ESX.GetConfig().CustomInventory == 'ox'
        ESX.UseItem(source, itemName)
        xPlayer.getAccount(name)  -> { money = number }
        xPlayer.job.grade_name    -> already present in essentialmode

    Nothing here modifies essentialmode's own files.
]]

local ESX = nil

local function patchPlayer(xPlayer)
    if not xPlayer or xPlayer.__bridgePatched then return xPlayer end

    -- ox_inventory calls xPlayer.getAccount('bank') / ('black_money') / ('money')
    -- essentialmode only tracks self.money (cash) and self.bank directly on the player.
    xPlayer.getAccount = function(name)
        if name == 'bank' then
            return { money = xPlayer.bank or 0 }
        elseif name == 'money' or name == 'cash' then
            return { money = xPlayer.money or 0 }
        end
        -- unknown/legacy account types (black_money etc.) essentialmode doesn't track — default to 0
        return { money = 0 }
    end

    -- essentialmode doesn't track sex/dateofbirth by default; keep it from erroring if absent
    xPlayer.sex = xPlayer.sex or 'm'
    xPlayer.dateofbirth = xPlayer.dateofbirth or '01/01/1990'

    xPlayer.__bridgePatched = true
    return xPlayer
end

local bridgeReady = false

local function initBridge()
    -- Keep asking essentialmode for its shared object until it actually answers —
    -- don't assume any fixed startup delay.
    local attempts = 0
    while not ESX do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        if not ESX then
            attempts = attempts + 1
            if attempts % 20 == 0 then
                print('^3[es_extended bridge] still waiting on essentialmode\'s esx:getSharedObject...^0')
            end
            Wait(100)
        end
    end

    -- ESX.GetConfig() — ox_inventory checks Config.CustomInventory == 'ox'
    if not ESX.GetConfig then
        ESX.GetConfig = function()
            return { CustomInventory = 'ox' }
        end
    end

    -- ESX.UseItem(source, item) — routes into essentialmode's existing UsableItemsCallbacks table
    if not ESX.UseItem then
        ESX.UseItem = function(source, item)
            local cb = ESX.UsableItemsCallbacks and ESX.UsableItemsCallbacks[item]
            if cb then
                cb(source)
                return true
            end
            return false
        end
    end

    -- Wrap GetPlayerFromId so every xPlayer handed out already has getAccount/sex/dateofbirth
    local originalGetPlayerFromId = ESX.GetPlayerFromId
    ESX.GetPlayerFromId = function(source)
        local xPlayer = originalGetPlayerFromId(source)
        return patchPlayer(xPlayer)
    end

    -- Patch anyone already logged in when this resource (re)starts
    if ESX.Players then
        for _, xPlayer in pairs(ESX.Players) do
            patchPlayer(xPlayer)
        end
    end

    bridgeReady = true
    print('^2[es_extended bridge] Ready — essentialmode is now exposed as es_extended for ox_inventory.^0')
end

CreateThread(initBridge)

exports('getSharedObject', function()
    -- Block (synchronously, from the caller's perspective) until the bridge has
    -- actually finished wiring up ESX — never hand back nil.
    while not bridgeReady do
        Wait(50)
    end
    return ESX
end)
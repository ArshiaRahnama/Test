-- ================================================================= --
-- Backpack items: wearable, purchasable/findable, add carry capacity
-- while equipped (essentialmode/config.lua Config.BackpackWeight holds
-- the actual kg values and does the real max-weight math -
-- RecalculateMaxWeight there is the single source of truth). This file
-- just handles the inventory side: using one equips it (consuming the
-- item, like using a boombox does), and only one can be worn at a time
-- - using a second one swaps it, giving the first one back.
-- ================================================================= --

Config.BackpackItems = {
    ['backpack'] = true,
    ['backpack_medium'] = true,
    ['backpack_large'] = true,
}

local function equipBackpack(source, itemName)
    local xPlayer = GetPlayerFromId(source)
    if not xPlayer then return end

    local current = exports.essentialmode:GetPlayerBackpack(source)
    if current == itemName then
        showNotification(xPlayer, Locales[Config.Language]['already_have'] or 'Already wearing this.', 'error')
        return
    end

    RemoveItem(xPlayer, itemName, 1)

    if current then
        AddItem(xPlayer, current, 1)
    end

    exports.essentialmode:SetPlayerBackpack(source, itemName)

    -- #15: resize the dedicated backpack slot band to match the pack.
    -- #13: tell every client to attach the matching prop to this ped.
    if xPlayer.setBackpackSlots then xPlayer.setBackpackSlots(itemName) end
    if _G.PushInventoryGrid then _G.PushInventoryGrid(source) end
    TriggerClientEvent('esx_inventory:backpackChanged', source)
    TriggerClientEvent('esx_inventory:syncBackpackProp', -1, source, itemName)

    showNotification(xPlayer, Locales[Config.Language]['backpack_equipped'] or 'Backpack equipped.', 'success')
end

--- Broadcast every currently-worn pack to a client that just joined, so
--- a player who connects mid-session doesn't see everyone bare-backed
--- until they next swap packs.
RegisterNetEvent('esx_inventory:requestBackpackProps')
AddEventHandler('esx_inventory:requestBackpackProps', function()
    local target = source
    for _, playerId in ipairs(GetPlayers()) do
        local worn = exports.essentialmode:GetPlayerBackpack(tonumber(playerId))
        if worn then
            TriggerClientEvent('esx_inventory:syncBackpackProp', target, tonumber(playerId), worn)
        end
    end
end)

--═════════════════════════════════════════════════════════════════════
-- #14 — police search of a worn backpack
--
-- Shows ONLY what is sitting in the backpack band (Config.BackpackSlots
-- / slots 101+), not the player's whole inventory. That distinction is
-- the entire point of the feature: a pack search is narrower than a full
-- body search (/fouiller), which is what makes "hide the contraband in
-- your pockets instead" a real decision rather than a formality.
--═════════════════════════════════════════════════════════════════════

local function isPoliceJob(jobName)
    for _, allowed in ipairs(Config.PoliceJobs or {}) do
        if jobName == allowed then return true end
    end
    return false
end

RegisterServerCallback('esx_inventory:searchBackpack', function(source, cb, targetId)
    local xPlayer = GetPlayerFromId(source)
    local xTarget = GetPlayerFromId(tonumber(targetId))
    if not xPlayer or not xTarget then return cb(nil) end

    local job = GetJob(xPlayer)
    local jobName = type(job) == 'table' and job.name or job
    if not isPoliceJob(jobName) then
        showNotification(xPlayer, Locales[Config.Language]['scan_no_equipment'] or "You don't have the equipment.", 'error')
        return cb(nil)
    end

    -- Proximity is enforced here, not trusted from the client.
    local a, b = GetPlayerPed(source), GetPlayerPed(tonumber(targetId))
    if not a or not b or a == 0 or b == 0 then return cb(nil) end
    if #(GetEntityCoords(a) - GetEntityCoords(b)) > 3.0 then return cb(nil) end

    local worn = exports.essentialmode:GetPlayerBackpack(tonumber(targetId))
    if not worn then
        return cb({ backpack = nil, items = {} })
    end

    local bpStart = Config.BackpackSlotStart or 101
    local bpCount = xTarget.backpackSlotCount or 0

    local items = {}
    if xTarget.invSlots then
        for slot = bpStart, bpStart + bpCount - 1 do
            local entry = xTarget.invSlots[slot]
            if entry then
                items[#items + 1] = {
                    name  = entry.name,
                    count = entry.count,
                    label = (GetItemLabel and GetItemLabel(entry.name)) or entry.name,
                    image = Config.Pictures and Config.Pictures[entry.name] or nil,
                    slot  = slot,
                }
            end
        end
    end

    -- The search itself is a loggable event; a police search that leaves
    -- no trace is a search nobody can be held to.
    if sendToDiscordWithSpecialURL and webhooks and webhooks['removeItem'] then
        sendToDiscordWithSpecialURL(
            "🎒 Backpack search",
            ("\n\n``👮``Officer: ``[%s] %s``\n``🧍``Target: ``[%s] %s``\n``🎒``Pack: ``%s`` (%d stack(s))")
                :format(source, xPlayer.getName(), targetId, xTarget.getName(), tostring(worn), #items),
            webhooks['removeItem'].color,
            webhooks['removeItem'].webhook
        )
    end

    cb({ backpack = worn, label = (GetItemLabel and GetItemLabel(worn)) or worn, items = items })
end)

for itemName in pairs(Config.BackpackItems) do
    ESX.RegisterUsableItem(itemName, function(source)
        equipBackpack(source, itemName)
    end)
end

RegisterCommand('removebackpack', function(source)
    if source == 0 then return end
    local xPlayer = GetPlayerFromId(source)
    if not xPlayer then return end

    local current = exports.essentialmode:GetPlayerBackpack(source)
    if not current then
        showNotification(xPlayer, Locales[Config.Language]['no_backpack'] or "You aren't wearing a backpack.", 'error')
        return
    end

    AddItem(xPlayer, current, 1)
    exports.essentialmode:SetPlayerBackpack(source, nil)

    -- #15: shrinking the band re-places anything that was in it back
    -- into the normal grid (or leaves it in the overflow strip if the
    -- grid is full). Nothing is ever deleted - see reconcileSlots().
    if xPlayer.setBackpackSlots then xPlayer.setBackpackSlots(nil) end
    if _G.PushInventoryGrid then _G.PushInventoryGrid(source) end
    TriggerClientEvent('esx_inventory:backpackChanged', source)
    TriggerClientEvent('esx_inventory:syncBackpackProp', -1, source, nil)

    showNotification(xPlayer, Locales[Config.Language]['backpack_removed'] or 'Backpack removed.', 'success')
end, false)

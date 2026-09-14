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
    showNotification(xPlayer, Locales[Config.Language]['backpack_equipped'] or 'Backpack equipped.', 'success')
end

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
    showNotification(xPlayer, Locales[Config.Language]['backpack_removed'] or 'Backpack removed.', 'success')
end, false)

--[[
    Server-side checkout for the Unique Café product menu (client/shop_client.lua).

    The client only ever sends { value = 'ghahve80', qty = 2 } style entries -
    every price is looked up here from Config.UwUMenu_Cake_Item /
    Config.UwUMenu_Noshidani_Item, never trusted from the NUI payload, so a
    modified client can't just claim a cheaper price.

    Revenue: the full sale total is deposited into the interacting cafe's
    own business account (society_<job>, same shared-account system every
    other cafe revenue source in this resource uses - see crafting_sv.lua)
    and counted via RecordSale for the Takeover War weekly sales board
    (server/takeover_sv.lua) - a purchase here behaves like a real business
    sale, not a money sink.
]]

local function findMenuItem(value)
    for _, item in ipairs(Config.UwUMenu_Cake_Item) do
        if item.value == value then return item end
    end
    for _, item in ipairs(Config.UwUMenu_Noshidani_Item) do
        if item.value == value then return item end
    end
    return nil
end

local function isKnownCafeJob(job)
    for _, cafe in pairs(Cafes) do
        if cafe.Job == job then return true end
    end
    return false
end

RegisterNetEvent('uwushop:checkout')
AddEventHandler('uwushop:checkout', function(cart, cafeJob)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    if type(cart) ~= 'table' or #cart == 0 then
        TriggerClientEvent('uwushop:result', src, false, 'Sabad kharid khali ast.')
        return
    end

    if not cafeJob or not isKnownCafeJob(cafeJob) then
        TriggerClientEvent('uwushop:result', src, false, 'Cafe nameatabar ast.')
        return
    end

    -- Validate every line + compute the real total server-side.
    local total = 0
    local resolved = {}

    for _, line in ipairs(cart) do
        local qty = tonumber(line.qty)
        if not qty or qty <= 0 or qty > 50 then
            TriggerClientEvent('uwushop:result', src, false, 'Meghdar nameatabar.')
            return
        end

        local item = findMenuItem(line.value)
        if not item then
            TriggerClientEvent('uwushop:result', src, false, 'Kalaye nameatabar.')
            return
        end

        total = total + (item.price * qty)
        resolved[#resolved + 1] = { name = item.value, qty = qty }
    end

    if xPlayer.getMoney() < total then
        TriggerClientEvent('uwushop:result', src, false, 'Pool kafi nadarid.')
        return
    end

    xPlayer.removeMoney(total)

    for _, line in ipairs(resolved) do
        xPlayer.addInventoryItem(line.name, line.qty)
    end

    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. cafeJob, function(account)
        account.addMoney(total)
        RecordSale(cafeJob, total) -- Takeover War weekly sales board (server/takeover_sv.lua)
    end)

    TriggerClientEvent('uwushop:result', src, true, ('Kharid movafagh - $%d kasr shod.'):format(total))
end)

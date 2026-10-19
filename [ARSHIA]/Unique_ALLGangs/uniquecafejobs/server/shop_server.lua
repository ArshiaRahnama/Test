-- Cafe / restaurant checkout. Prices come from shared/menu.lua on the server.
-- The player must be standing at the menu point of the business they buy from.

local function findMenuItem(group, value)
    local menu = UCConfig.MenuByGroup[group]
    if not menu then return nil end
    for _, list in pairs(menu) do
        for _, item in ipairs(list) do
            if item.value == value then return item end
        end
    end
    return nil
end

RegisterNetEvent('uwushop:checkout')
AddEventHandler('uwushop:checkout', function(cart, cafeJob)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local function fail(msg) TriggerClientEvent('uwushop:result', src, false, msg) end

    if type(cart) ~= 'table' or #cart == 0 or #cart > 20 then return fail('Sabad kharid khali ast.') end

    local biz = type(cafeJob) == 'string' and GetCafeForJob(cafeJob)
    if not biz then return fail('Cafe nameatabar ast.') end

    local p = GetEntityCoords(GetPlayerPed(src))
    local mp = biz.Menu_Sefaresh.Pos
    if #(p - vector3(mp.x, mp.y, mp.z)) > 10.0 then return fail('Shoma nazdik in cafe nistid.') end

    local total, resolved = 0, {}
    for _, line in ipairs(cart) do
        local qty = math.floor(tonumber(line.qty) or 0)
        if qty <= 0 or qty > 50 then return fail('Meghdar nameatabar.') end
        local item = findMenuItem(biz.MenuGroup, line.value)
        if not item then return fail('Kalaye nameatabar.') end
        total = total + item.price * qty
        resolved[#resolved + 1] = { name = item.value, qty = qty }
    end

    if xPlayer.getMoney() < total then return fail('Pool kafi nadarid.') end
    xPlayer.removeMoney(total)
    for _, l in ipairs(resolved) do xPlayer.addInventoryItem(l.name, l.qty) end

    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. biz.Society, function(acc)
        if acc then acc.addMoney(total) end
    end)
    RecordSale(biz.Job, total)

    TriggerClientEvent('uwushop:result', src, true, ('Kharid movafagh - $%d kasr shod.'):format(total))
end)

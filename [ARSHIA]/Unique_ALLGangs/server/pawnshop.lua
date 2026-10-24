-- Pawnshops (Config.Pawnshops). Only the item lists in the config are bought.
local function shopPos(k)
    local b = Cafes and Cafes[k]
    return b and b.Menu_Sefaresh and b.Menu_Sefaresh.Pos
end

RegisterNetEvent('pawnshop:sell')
AddEventHandler('pawnshop:sell', function(k, item, count)
    local src = source
    local shop = Config.Pawnshops[k]
    if not shop then return end
    local p = shopPos(k)
    if not p or #(GetEntityCoords(GetPlayerPed(src)) - vector3(p.x, p.y, p.z)) > 10.0 then return end
    local listed
    for _, it in ipairs(shop.items) do if it.name == item then listed = it end end
    if not listed then return end
    local n = math.floor(tonumber(count) or 0)
    if n < 1 or n > 500 then return end
    local x = ESX.GetPlayerFromId(src)
    local gang = x and x.gang and x.gang.name
    if not GangOwnsBusiness(gang, k) then
        return TriggerClientEvent('esx:showNotification', src, 'In samsari mal-e holding ast.')
    end
    local inv = x and x.getInventoryItem(item)
    if not inv or (inv.count or 0) < n then
        return TriggerClientEvent('esx:showNotification', src, 'Item kafi nadari.')
    end
    x.removeInventoryItem(item, n)
    x.addMoney(listed.price * n)
    TriggerClientEvent('esx:showNotification', src, ('%dx %s sold for $%d'):format(n, listed.label, listed.price * n))
end)

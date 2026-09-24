--[[
    Unique Café product menu (NUI shop)

    Customer-facing ordering UI for the cafe's Cake / Noshidani (drinks)
    catalog (shared/menu.lua). Wired into the SAME entry points that used
    to open the broken ox_lib "cake_menu"/"noshidani_menu" contexts
    (client/functions.lua) - those contexts are gone, this file is what
    opens now.

    Prices are only ever trusted from Config.UwUMenu_Cake_Item /
    Config.UwUMenu_Noshidani_Item on the SERVER (server/shop_server.lua) -
    the client only tells the server which item value + qty was picked.

    Revenue routing: every purchase is tied to whichever cafe's Menu
    interaction point the player is actually standing at (nearest
    Menu_Sefaresh.Pos, same zones already used by ox_target), so the full
    sale amount lands in THAT cafe's business account (society_<job>) and
    counts toward its Takeover War weekly sales - same business economy
    every other revenue source in this resource already feeds.
]]

function GetNearestCafeJob()
    local pos = GetEntityCoords(PlayerPedId())
    local bestJob, bestDist

    for _, cafe in pairs(Cafes) do
        local p = cafe.Menu_Sefaresh.Pos
        local dist = #(pos - vector3(p.x, p.y, p.z))
        if not bestDist or dist < bestDist then
            bestDist = dist
            bestJob = cafe.Job
        end
    end

    return bestJob
end

function OpenUniqueShop(defaultTab)
    SendShopNUI({
        open = true,
        defaultTab = defaultTab or 'drinks',
        drinks = Config.UwUMenu_Noshidani_Item,
        desserts = Config.UwUMenu_Cake_Item,
        iconBase = Config.itemIconsPath,
    })
    SetNuiFocus(true, true)
end

RegisterNUICallback('shopClose', function(_, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('shopCheckout', function(data, cb)
    TriggerServerEvent('uwushop:checkout', data.cart, GetNearestCafeJob())
    cb('ok')
end)

RegisterNetEvent('uwushop:result')
AddEventHandler('uwushop:result', function(success, message)
    ESX.ShowNotification(message)
    SendShopNUI({ result = true, success = success })
end)

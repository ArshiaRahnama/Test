-- Cafe / restaurant product menu (NUI). The menu shown depends on the business
-- whose menu point the player is standing at.

local function GetNearestCafe()
    local pos = GetEntityCoords(PlayerPedId())
    local best, bestDist
    for _, cafe in pairs(Cafes) do
        local p = cafe.Menu_Sefaresh.Pos
        local d = #(pos - vector3(p.x, p.y, p.z))
        if not bestDist or d < bestDist then best, bestDist = cafe, d end
    end
    return best
end

function OpenUniqueShop(defaultTab)
    local cafe = GetNearestCafe()
    if not cafe then return end
    local menu = UCConfig.MenuByGroup[cafe.MenuGroup] or UCConfig.MenuByGroup.cafe
    SendShopNUI({
        open = true,
        defaultTab = defaultTab or 'drinks',
        drinks = menu.drinks,
        desserts = menu.desserts,
        iconBase = UCConfig.itemIconsPath,
    })
    SetNuiFocus(true, true)
end

RegisterNUICallback('shopClose', function(_, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('shopCheckout', function(data, cb)
    local cafe = GetNearestCafe()
    TriggerServerEvent('uwushop:checkout', data.cart, cafe and cafe.Job or nil)
    cb('ok')
end)

RegisterNetEvent('uwushop:result')
AddEventHandler('uwushop:result', function(success, message)
    ESX.ShowNotification(message)
    SendShopNUI({ result = true, success = success })
end)

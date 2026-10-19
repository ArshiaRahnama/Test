-- Auction House (client). UCConfig: auctionhouse/config.lua (Config_ah).
-- The UI lives in html/auctionhouse and is shown through the uniquecafejobs NUI router.

local ESX = nil
local uiOpen = false

CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(100)
    end
end)

local function SendAH(msg)
    SendNUIMessage({ __routeTo = 'ah', payload = msg })
end

local function RefreshShop()
    ESX.TriggerServerCallback('auction-house2:GetShopItems', function(data)
        SendAH({
            shop = 'refresh',
            sItems = data.sItems or {},
            mItems = data.mItems or {},
            canSell = data.canSell or false,
            shopInfo = data.shop,
        })
    end)
end

local function RefreshSell()
    ESX.TriggerServerCallback('auction-house2:GetSellItems', function(list)
        SendAH({ shop = 'sellitems', items = list or {} })
    end)
end

local function CloseUi()
    SetNuiFocus(false, false)
    if uiOpen then
        SendAH({ ui = 'closeui' })
        uiOpen = false
    end
end

-- Opens only if the server says this location is an auction house.
local function OpenShop()
    if uiOpen then return end
    ESX.TriggerServerCallback('auction-house2:GetShopItems', function(data)
        if not data.shop then
            ESX.ShowNotification('No auction house here.', 'error')
            return
        end
        uiOpen = true
        SetNuiFocus(true, true)
        SendAH({ ui = 'openui' })
        RefreshShop()
        RefreshSell()
    end)
end

-- Owned gun shops (refreshed from the server every 30s).
local Shops = {}

CreateThread(function()
    while true do
        if ESX then
            ESX.TriggerServerCallback('auction-house2:GetShops', function(list)
                Shops = list or {}
            end)
        end
        Wait(30000)
    end
end)

CreateThread(function()
    while true do
        Wait(1)
        local coords = GetEntityCoords(PlayerPedId())
        local near = false
        for _, v in ipairs(Shops) do
            local pos = vector3(v.coords.x, v.coords.y, v.coords.z)
            local d = #(coords - pos)
            if d < 10.0 then
                near = true
                local c = Config_ah.Shop.marker.color
                DrawMarker(Config_ah.Shop.marker.type, pos.x, pos.y, pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.1, 1.1, 1.1, c.r, c.g, c.b, c.a, false, true, 2, nil, nil, false, false)
                DrawMarker(Config_ah.Shop.marker.type2, pos.x, pos.y, pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, c.r, c.g, c.b, c.a, false, true, 2, nil, nil, false, false)
                if d < 2.0 and not uiOpen and IsControlJustReleased(0, 38) then
                    OpenShop()
                end
            end
        end
        if not near then Wait(500) end
    end
end)

-- Safety net: ESC always closes the panel and gives the mouse back.
CreateThread(function()
    while true do
        if uiOpen then
            Wait(0)
            if IsControlJustPressed(0, 322) or IsControlJustPressed(0, 200) then
                CloseUi()
            end
        else
            Wait(250)
        end
    end
end)

RegisterNUICallback('CloseUi', function(_, cb)
    CloseUi()
    cb('ok')
end)

RegisterNUICallback('AddItemToShop', function(data, cb)
    data = data or {}
    TriggerServerEvent('auction-house2:AddItemToShop', {
        item = data.item, amount = data.amount, price = data.price, discord = data.discord and true or false,
    })
    cb(true)
end)

RegisterNUICallback('BuyItemFromShop', function(data, cb)
    data = data or {}
    TriggerServerEvent('auction-house2:BuyItemFromShop', { id = data.id })
    cb(true)
end)

RegisterNUICallback('RemoveItemFromShop', function(data, cb)
    data = data or {}
    TriggerServerEvent('auction-house2:RemoveItemFromShop', { id = data.id })
    cb(true)
end)

RegisterNetEvent('auction-house2:RefreshShop', function()
    if uiOpen then
        RefreshShop()
        RefreshSell()
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    if uiOpen then CloseUi() end
end)

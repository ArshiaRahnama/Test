-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX = exports['essentialmode']:getObject()
local postBox = nil
local currentState = false
local courier = false
local countList = nil
Citizen.CreateThread(function()
	while ESX == nil do
		Wait(1000)
	end
    for k , v in pairs(coords) do
        if not v.hide then
            local blip = AddBlipForCoord(v.coords)
            SetBlipSprite  (blip, 304)
            SetBlipDisplay (blip, 4)
            SetBlipScale   (blip, 1.0)
            SetBlipCategory(blip, 3)
            SetBlipColour  (blip, 2)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Auction House")
            EndTextCommandSetBlipName(blip)
        end
    end

    Wait(5000)
    for k , v in pairs(coords) do
        ESX.RegisterPoint(v.coords,3,{
			Color = {R = 0,G = 0,B = 0,A = 255},
			DrawDistance = 10,
			Radius = 1.0,
			Type = 54
		},{
			Notification = nil,
			DrawText = 'Dokme ~INPUT_CONTEXT~ jahat baz kardan Auction House',
			DrawTextRadius = 4,
			DrawTextCoords = v.coords,
			Key = 'e',
			CB = function()
				-- openAH(true)
                if ESX.GetPlayerData().World == 0 then
                    TriggerServerEvent('ah:open')
                end
			end,
		},{
			In = nil,
			Out = ESX.UI.Menu.CloseAll
		})
    end
end)

function openAH(state, check)
    countList = nil
    SendNUIMessage({
        app = 'sunset_auctionhouse',
        method = 'open',
        data = {
            name = 'AUCTION HOUSE',
            state = state
        },
    })
    SetNuiFocus(state, state)
    currentState = state
    if state and not check then
        CreateThread(function()
            while currentState do
                Wait(2000)
                if not doesNear() then
                    openAH(false)
                end
            end
        end)
    end
end

RegisterNetEvent('ah:open', function(check)
    openAH(true, check)
end)

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    TriggerEvent('ah:onClose')
    cb()
end)

RegisterNUICallback('getCategories', function(data, cb)
    while not ESX do Wait(1000) end
    if countList == nil then
        local p = promise.new()
        ESX.TriggerServerCallback('ah:getProductsCount', function(result)
            countList = result or {}
            p:resolve()
        end)
        Citizen.Await(p)
    end
    local categories = {}
    for _, v in pairs(list_products) do
        categories[#categories+1] = {
            name = v.name,
            price_recommended = v.price_recommended,
            label = ('%s(%s)'):format(ESX.getItemLabel(v.name), countList and countList[v.name] or 0),
            img = v.img or ESX.getItemImage(v.name),
        }
    end
    cb(json.encode(categories))
end)

RegisterNUICallback('getPlayerItem', function(data, cb)
    local inventory = ESX.GetPlayerData().inventory
    local filtered = {}
    for _, v in pairs(inventory) do
        if v.count > 0 then
            for _, v2 in pairs(list_products) do
                if v2.name == v.name then
                    v.price_recommended = v2.price_recommended
                    table.insert(filtered, v)
                    break
                end
            end
        end
    end
    cb(json.encode(filtered))
end)

local function decorateProduct(v, label, image)
    v.count = v.amount
    v.label = label or ESX.getItemLabel(v.name)
    v.img = image or ESX.getItemImage(v.name)
    return v
end

RegisterNUICallback('getProducts', function(data, cb)
    local page = tonumber(data.page) or 1
    local sort = data.sort == 'expensive' and 'expensive' or 'cheap'
    ESX.TriggerServerCallback('ah:getProductsByName', function(result)
        result = result or { rows = {}, total = 0, page = 1, totalPages = 0 }
        local label = ESX.getItemLabel(data.category.name)
        local image = ESX.getItemImage(data.category.name)
        local rows = {}
        for _, v in pairs(result.rows or {}) do
            table.insert(rows, decorateProduct(v, label, image))
        end
        cb(json.encode({
            rows = rows,
            total = result.total or 0,
            page = result.page or page,
            totalPages = result.totalPages or 0,
        }))
    end, data.category.name, page, sort)
end)

RegisterNUICallback('getMyItemNames', function(data, cb)
    ESX.TriggerServerCallback('ah:getMyItemNames', function(result)
        local list = {}
        if result then
            for _, v in pairs(result) do
                table.insert(list, {
                    name = v.name,
                    label = ESX.getItemLabel(v.name),
                    img = ESX.getItemImage(v.name),
                    count = v.count,
                })
            end
        end
        cb(json.encode(list))
    end)
end)

RegisterNUICallback('getMyProductsByName', function(data, cb)
    local page = tonumber(data.page) or 1
    local sort = data.sort == 'expensive' and 'expensive' or 'cheap'
    local name = data.name
    ESX.TriggerServerCallback('ah:getMyProductsByName', function(result)
        result = result or { rows = {}, total = 0, page = 1, totalPages = 0 }
        local label = ESX.getItemLabel(name)
        local image = ESX.getItemImage(name)
        local rows = {}
        for _, v in pairs(result.rows or {}) do
            table.insert(rows, decorateProduct(v, label, image))
        end
        cb(json.encode({
            rows = rows,
            total = result.total or 0,
            page = result.page or page,
            totalPages = result.totalPages or 0,
        }))
    end, name, page, sort)
end)

RegisterNUICallback('buy', function(data, cb)
    ESX.TriggerServerEvent('ah:buyItem', data)
    Wait(6000)
    countList = nil
    cb("ok")
end)

RegisterNUICallback('delete', function(data, cb)
    ESX.TriggerServerEvent('ah:removeItem', data)
    Wait(3000)
    countList = nil
    cb("ok")
end)

RegisterNUICallback('add', function(data, cb)
    ESX.TriggerServerEvent('ah:advertiseItem', data)
    Wait(5000)
    countList = nil
    cb("ok")
end)

function doesNear()
    local playerCoords = GetEntityCoords(PlayerPedId())
    for k, v in pairs(coords) do
        if #(playerCoords - v.coords) < 10 then
            return true
        end
    end
    return postBox
end

RegisterNUICallback('checkBlackMoney', function(data, cb)
    cb(false)
end)
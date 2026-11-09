-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX = exports['essentialmode']:getObject()
local HasAlreadyEnteredMarker = false
Config.clothe = {}
local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}
local ShopOpen = false
local near = {active = false}
local labelTemp = {
    ['tshirt'] = 'T-shirt',
    ['torso'] = 'Lebas',
    ['pants'] = 'Shalvar',
    ['shoes'] = 'Kafsh',
    ['mask'] = 'Mask',
    ['bproof'] = 'Jelighe',
    ['chain'] = 'Gardan band',
    ['helmet'] = 'Kolah',
    ['glasses'] = 'Eynak',
    ['watches'] = 'Sa\'at',
    ['bracelets'] = 'Dastband',
    ['bag'] = 'Kif',
    ['ears'] = 'Gush',
    ['arms'] = 'Dastkesh',
}
local imageServer = 'https://cdn.sunrp.ir'
local numList = {}
local lastClothe = {}
local prime = false
Citizen.CreateThread(function()
    while not ESX do
        Wait(1000)
    end
    Config.clothe = exports['sunset_clothe']:getClothe2()
    for k , v in ipairs(Config.Zones) do
		if v.zones then
			for k2 , v2 in pairs(v.zones) do
                ESX.RegisterPoint(v2.coords,2,{
                    Color = {R = 102,G = 255,B = 204,A = 255},
                    DrawDistance = 3,
                    Radius = 0.6,
                    Type = 33,
                    world = 0,
                },{
                    Notification = nil,
                    DrawText = '~INPUT_CONTEXT~',
                    DrawTextRadius = 3,
                    DrawTextCoords = v2.coords,
                    Key = 'e',
                    CB = function()
                        prime = v.prime ~= nil
                        if prime and not ESX.isPrime() then
                            return ESX.notification('error', 'برای استفاده از لباس فروشی باید پرایم باشید')
                        end
                        OpenShopMenu(v2.access, nil)
                    end,
                },{
                    In = nil,
                    Out = nil
                })
            end
		end
	end
end)

local lastData = {}

RegisterNUICallback('reload', function(data, cb)
    OpenShopMenu(lastData,true)
end)

RegisterNUICallback('preview', function(data, cb)
    local num = data.num
    TriggerEvent('skinchanger:loadStuff',num)
end)

RegisterNUICallback('key4', function(data, cb)
    local heading = GetEntityHeading(PlayerPedId())
    SetEntityHeading(PlayerPedId(),heading - 10)
end)
RegisterNUICallback('key6', function(data, cb)
    local heading = GetEntityHeading(PlayerPedId())
    SetEntityHeading(PlayerPedId(),heading + 10)
end)

local lastCloseTime = 0

function OpenShopMenu(data,_)
    if ShopOpen and not _ then return end

    local currentTime = GetGameTimer()
    if currentTime - lastCloseTime < 3500 and not _ then
        ESX.notification('info', 'لطفا چند لحظه صبر کنید...')
        return
    end

    lastData = data
    local elements = {}
    ShopOpen = true
    if not _ then
        TriggerEvent('skinchanger:getSkin',function(data)
            lastClothe = data
        end)
        Camera()
    end
    local category = {}
    for k, v in pairs(data) do
        table.insert(category, {
            label = labelTemp[v],
            name = v,
            image = imageServer .. '/clothes/menu/'.. v .. '.png',
        })
    end
    SendNUIMessage({
        display = true,
        category = category
    })

    SetNuiFocus(true, true)
    ESX.UI.Menu.CloseAll()
   -- PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)
end

RegisterNUICallback('getData', function(data, cb)
    local type = data.name
    local data = Config.clothe[type]
    local _data = {}
    local __data = {}
    local ___data = {}
    numList = {}
    local sex = GetEntityModel(PlayerPedId()) == `mp_m_freemode_01` and 0 or 1
    local primeStatus = ESX.isPrime()
    local primePoint = ESX.getPrimePoint()
    for k , v in ipairs(data) do
        if v.sex == sex and v.price and v.price > 0 and (not prime or (v.prime and primeStatus and primePoint >= v.prime.point)) then
            table.insert(_data,v)
        end
    end
    for k , v in pairs(_data) do
        if not numList[v.num2[1]] then
            numList[v.num2[1]] = {}
        end
        numList[v.num2[1]][v.num2[2]] = v
        if __data[v.num2[1]] ~= nil then
            if v.num2[2] < __data[v.num2[1]].num2[2] then
                __data[v.num2[1]] = v
            end
        else
            __data[v.num2[1]] = v
        end
    end
    for k , v in pairs(__data) do
        table.insert(___data,v)
    end
    cb(___data)
end)

RegisterNUICallback('loadColor', function(num, cb)
    local num = tonumber(num)
    local _ = {}
    for k , v in pairs(numList[num]) do
        table.insert(_,v)
    end
    SendNUIMessage({
        loadColor = _,
    })
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if ShopOpen then
            ESX.UI.Menu.CloseAll()
        end
    end
end)

-- Create Blips
Citizen.CreateThread(function()
	for k , v in ipairs(Config.Zones) do
		if v.blip then
            if v.mask then
                local blip = AddBlipForCoord(v.blip.x, v.blip.y, v.blip.z)
                SetBlipSprite(blip, 543)
                SetBlipDisplay(blip, 4)
                SetBlipScale(blip, 0.7)
                SetBlipColour(blip, 75)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString('Mask foroushi')
                EndTextCommandSetBlipName(blip)
            else
                local blip = AddBlipForCoord(v.blip.x, v.blip.y, v.blip.z)
                SetBlipSprite(blip, 73)
                SetBlipDisplay(blip, 4)
                SetBlipScale(blip, 0.7)
                SetBlipColour(blip, 53)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString('Lebas foroushi')
                EndTextCommandSetBlipName(blip)
            end
		end
	end
end)

RegisterNUICallback('buy', function(data, cb)
    local data2 = {}
    for k, v in pairs(data) do
        data2[v.name] = true
    end
    ESX.TriggerServerEvent('sunset_clothe:buy', nil, data2)
    cb('ok')
end)

RegisterNetEvent('sun-clotheshop:buyResult')
AddEventHandler('sun-clotheshop:buyResult', function(success, message, purchasedItems)
    local notifType = 'error'
    if success == true then
        notifType = 'success'
    elseif success == 'partial' then
        notifType = 'info'
    end
    SendNUIMessage({
        notification = {
            type = notifType,
            message = message
        },
        purchasedItems = purchasedItems
    })
end)

function DestroyCamera()
    RenderScriptCams(false, true, 500, true, false)
    DestroyCam(cam, false)
    cam = nil
end

function Camera()
    cam = CreateCam('DEFAULT_SCRIPTED_CAMERA')
    local coordsCam = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.5, 0.65)
    local coordsPly = GetEntityCoords(PlayerPedId())
    SetCamCoord(cam, coordsCam)
    PointCamAtCoord(cam, coordsPly['x'], coordsPly['y'], coordsPly['z'])
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)
end


RegisterNUICallback('loadClothe', function(data)
    local type = data.name
    local data = Config.clothe[type]
    local _data = {}
    local __data = {}
    local ___data = {}
    numList = {}
    local sex = GetEntityModel(PlayerPedId()) == `mp_m_freemode_01` and 0 or 1
    local primeStatus = ESX.isPrime()
    local primePoint = ESX.getPrimePoint()
    for k , v in ipairs(data) do
        if v.sex == sex and v.price and v.price > 0 and (not prime or (v.prime and primeStatus and primePoint >= v.prime.point)) then
            table.insert(_data,v)
        end
    end
    for k , v in pairs(_data) do
        if not numList[v.num2[1]] then
            numList[v.num2[1]] = {}
        end
        v.img = imageServer .. '/clothes/'.. type ..'/'.. v.name .. '.png'
        numList[v.num2[1]][v.num2[2]] = v
        if __data[v.num2[1]] ~= nil then
            if v.num2[2] < __data[v.num2[1]].num2[2] then
                __data[v.num2[1]] = v
            end
        else
            __data[v.num2[1]] = v
        end
        -- v.colors = {}
        -- for k , v in pairs(numList[v.num2[1]]) do
        --     table.insert(v.colors,v )
        -- end
    end
    for k , v in pairs(__data) do
        v.id = v.num2[1]
        v.img = imageServer .. '/clothes/'.. type ..'/'.. v.name .. '.png'
        table.insert(___data,v)
    end
    SendNUIMessage({
        loadClothe = {
            type = type,
            data = ___data,
        },
    })
end)

RegisterNUICallback('close', function(data)
    SetNuiFocus(false, false)
    FreezeEntityPosition(PlayerPedId(), false)
    DestroyCamera()
    ShopOpen = false
    lastCloseTime = GetGameTimer()
    Wait(500)
    TriggerEvent('skinchanger:loadSkin',lastClothe)
end)

RegisterNUICallback('rotation', function(ha)
    if ha == 1 then
        SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) - 4.0)
    else
        SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) + 4.0)
    end
end)

RegisterNUICallback('resetCamera', function(data)
    DestroyCamera()
    Wait(100)
    Camera()
end)

RegisterNUICallback('tryout', function(data)
    TriggerEvent('skinchanger:loadSkin', lastClothe)
    Wait(100)
    for k, v in pairs(data) do
        TriggerEvent('skinchanger:loadStuff', v.num)
    end
    DestroyCamera()
    Wait(100)
    Camera()
    ExecuteCommand('e adjusttie')
end)

local defaultClothe = {
    [0] = {
        tshirt = { ['tshirt_1'] = 15, ['tshirt_2'] = 0 },
        torso = { ['torso_1'] = 15, ['torso_2'] = 0 },
        pants = { ['pants_1'] = 61, ['pants_2'] = 4 },
        shoes = { ['shoes_1'] = 34, ['shoes_2'] = 0 },
        mask = { ['mask_1'] = 0, ['mask_2'] = 0 },
        bproof = { ['bproof_1'] = 0, ['bproof_2'] = 0 },
        chain = { ['chain_1'] = 0, ['chain_2'] = 0 },
        helmet = { ['helmet_1'] = -1, ['helmet_2'] = -1 },
        glasses = { ['glasses_1'] = -1, ['glasses_2'] = -1 },
        watches = { ['watches_1'] = -1, ['watches_2'] = -1 },
        bracelets = { ['bracelets_1'] = -1, ['bracelets_2'] = 0 },
        bag = { ['bags_1'] = 0, ['bags_2'] = 0 },
        ears = { ['ears_1'] = -1, ['ears_2'] = -1 },
        arms = { ['arms'] = 15, ['arms_2'] = 0 },
        decals = { ['decals_1'] = 0, ['decals_2'] = 0 },
    },
    [1] = {
        tshirt = { ['tshirt_1'] = 14, ['tshirt_2'] = 0 },
        torso = { ['torso_1'] = 15, ['torso_2'] = 0 },
        pants = { ['pants_1'] = 15, ['pants_2'] = 0 },
        shoes = { ['shoes_1'] = 35, ['shoes_2'] = 0 },
        mask = { ['mask_1'] = 0, ['mask_2'] = 0 },
        bproof = { ['bproof_1'] = 0, ['bproof_2'] = 0 },
        chain = { ['chain_1'] = 0, ['chain_2'] = 0 },
        helmet = { ['helmet_1'] = -1, ['helmet_2'] = -1 },
        glasses = { ['glasses_1'] = -1, ['glasses_2'] = -1 },
        watches = { ['watches_1'] = -1, ['watches_2'] = -1 },
        bracelets = { ['bracelets_1'] = -1, ['bracelets_2'] = 0 },
        bag = { ['bags_1'] = 0, ['bags_2'] = 0 },
        ears = { ['ears_1'] = -1, ['ears_2'] = -1 },
        arms = { ['arms'] = 15, ['arms_2'] = 0 },
        decals = { ['decals_1'] = 0, ['decals_2'] = 0 },
    }
}

RegisterNUICallback('undress', function(data)
    local category = data.category
    local sex = GetEntityModel(PlayerPedId()) == `mp_m_freemode_01` and 0 or 1
    local defaultData = defaultClothe[sex][category]
    if defaultData then
        TriggerEvent('skinchanger:loadStuff', defaultData)
    end
end)

RegisterNUICallback('restoreClothing', function(data)
    local category = data.category
    if lastClothe then
        local restoreData = {}
        if category == 'tshirt' then
            restoreData = { ['tshirt_1'] = lastClothe.tshirt_1, ['tshirt_2'] = lastClothe.tshirt_2 }
        elseif category == 'torso' then
            restoreData = { ['torso_1'] = lastClothe.torso_1, ['torso_2'] = lastClothe.torso_2 }
        elseif category == 'pants' then
            restoreData = { ['pants_1'] = lastClothe.pants_1, ['pants_2'] = lastClothe.pants_2 }
        elseif category == 'shoes' then
            restoreData = { ['shoes_1'] = lastClothe.shoes_1, ['shoes_2'] = lastClothe.shoes_2 }
        elseif category == 'mask' then
            restoreData = { ['mask_1'] = lastClothe.mask_1, ['mask_2'] = lastClothe.mask_2 }
        elseif category == 'bproof' then
            restoreData = { ['bproof_1'] = lastClothe.bproof_1, ['bproof_2'] = lastClothe.bproof_2 }
        elseif category == 'chain' then
            restoreData = { ['chain_1'] = lastClothe.chain_1, ['chain_2'] = lastClothe.chain_2 }
        elseif category == 'helmet' then
            restoreData = { ['helmet_1'] = lastClothe.helmet_1, ['helmet_2'] = lastClothe.helmet_2 }
        elseif category == 'glasses' then
            restoreData = { ['glasses_1'] = lastClothe.glasses_1, ['glasses_2'] = lastClothe.glasses_2 }
        elseif category == 'watches' then
            restoreData = { ['watches_1'] = lastClothe.watches_1, ['watches_2'] = lastClothe.watches_2 }
        elseif category == 'bracelets' then
            restoreData = { ['bracelets_1'] = lastClothe.bracelets_1, ['bracelets_2'] = lastClothe.bracelets_2 }
        elseif category == 'bag' then
            restoreData = { ['bags_1'] = lastClothe.bags_1, ['bags_2'] = lastClothe.bags_2 }
        elseif category == 'ears' then
            restoreData = { ['ears_1'] = lastClothe.ears_1, ['ears_2'] = lastClothe.ears_2 }
        elseif category == 'arms' then
            restoreData = { ['arms'] = lastClothe.arms, ['arms_2'] = lastClothe.arms_2 }
        end
        if next(restoreData) then
            TriggerEvent('skinchanger:loadStuff', restoreData)
        end
    end
end)
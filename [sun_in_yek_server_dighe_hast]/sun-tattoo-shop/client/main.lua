-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local currentTattoos, cam = {}, -1
ESX = exports['essentialmode']:getObject()
isCameraActive = false
local reverseCamera = false
local originalHeading = 0.0
local index = 1
local xOffset, yOffset = 0, 0
local cameraOffsets = {
    {
        vector3(0.0, 2.8, 0.3),
        vector3(0.0, 0.0, 0.0),
    },
    {
        vector3(0.0, 0.9, 0.65),
        vector3(0.0, 0.0, 0.6),
    },
    {
        vector3(0.0, 1.4, 0.5),
        vector3(0.0, 0.0, 0.3),
    },
    {
        vector3(0.0, 1.6, -0.3),
        vector3(0.0, 0.0, -0.45),
    },
    {
        vector3(0.0, 0.98, -0.7),
        vector3(0.0, 0.0, -0.9),
    },
    {
        vector3(0.0, 0.98, 0.1),
        vector3(0.0, 0.0, 0.0),
    },
    {
        vector3(0.0, 1.3, 0.135),
        vector3(0.0, 0.0, 0.15),
    },
}
Citizen.CreateThread(function()
    while ESX == nil do
        Wait(1000)
    end
    for k,v in pairs(Config.Zones) do
        ESX.RegisterPoint(v,2,{
            Color = {R = 102,G = 255,B = 204,A = 255},
            DrawDistance = 4,
            Radius = 0.7,
            Type = 33,
            world = 0,
        },{
            Notification = nil,
            DrawText = 'Dokme ~INPUT_CONTEXT~ jahat baz kardan menu',
            DrawTextRadius = 3,
            DrawTextCoords = v + vector3(0,0,1),
            Key = 'e',
            CB = function()
                if not isCameraActive then
                    ESX.registerExitPoint(6, function()
                        closeMenu()
                        setPedSkin()
                    end)
                    OpenShopMenu()
                end
            end,
        },{
            In = nil,
            Out = function()
            end
        })
    end
    ESX.TriggerServerCallback('tattooShop:requestPlayerTattoos', function(tattooList)
        if tattooList then
            currentTattoos = tattooList
            setOwnedTattoo()
        end
    end)
end)

function closeMenu()
    isCameraActive = false
    cleanPlayer()
    RenderScriptCams(false, false, 0, 1, 0)
    if cam and DoesCamExist(cam) then DestroyCam(cam, false) end
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
end

AddEventHandler('skinchanger:modelLoaded', function()
    Citizen.Wait(15000)
    ESX.TriggerServerCallback('tattooShop:requestPlayerTattoos', function(tattooList)
        if tattooList then
            currentTattoos = tattooList
            setOwnedTattoo()
        end
    end)
end)

function setOwnedTattoo()
    local gangName = ESX.GetPlayerData().gang.name
    local primeStatus = ESX.isPrime()
    local primePoint = ESX.getPrimePoint()
    for k,v in pairs(currentTattoos) do
        local data = Config.TattooList[v.collection][v.num]
        if data then
            local haveAccess = true
            local gang = false
            if data.gang and #data.gang > 0 then
                haveAccess = ESX.tableFind(data.gang, gangName)
                gang = haveAccess
            end
            local doesPrivate = data.private
            if doesPrivate then
                haveAccess = v.access or gang
            end
            if data.prime then
                if primeStatus and primePoint >= data.prime.point then
                    haveAccess = false
                end
            end
            if haveAccess then
                ApplyPedOverlay(PlayerPedId(), GetHashKey(v.collection), GetHashKey(Config.TattooList[v.collection][v.num].nameHash))
            end
        end
    end
end

local tattooColor = '#16d6c1'
local tattooColorPrimary = '#FFB734'
local lastAccessList = {}

local function isOwned(col, num)
    for _, v in pairs(currentTattoos) do
        if v.collection and tostring(v.collection):lower() == tostring(col):lower() and v.num == num then
            return true
        end
    end
    return false
end

local TATTOO_ICONS = { 'flame', 'rose', 'skull', 'snake', 'star', 'heart', 'anchor', 'gem', 'butterfly', 'bolt', 'eye', 'moon', 'sun', 'paw', 'feather', 'wave' }

local function buildCategories(accessList)
    accessList = accessList or {}
    local gang = ESX.GetPlayerData().gang.name
    local primeStatus = ESX.isPrime()
    local primePoint = ESX.getPrimePoint()
    local categories = {}

    for i, cat in ipairs(Config.TattooCategories) do
        local col = cat.value
        if col == 'del_tattoo' then goto continue end
        local tattoos = {}
        for key, v in pairs(Config.TattooList[col] or {}) do
            local include = false
            if not v.gang or #v.gang == 0 then
                if (not v.private) or (accessList[col .. '-' .. key] and (not v.prime or (primeStatus and primePoint >= v.prime.point))) then
                    include = true
                end
            elseif ESX.tableFind(v.gang, gang) then
                include = true
            end
            if include then
                tattoos[#tattoos + 1] = { key = col .. '_' .. key, label = v.label or key, price = v.price or 0, cat = col, num = key, owned = isOwned(col, key), txd = v.txdHash, img = v.pngfile or v.img }
            end
        end
        categories[#categories + 1] = { key = col, label = cat.name, icon = (cat.icon or TATTOO_ICONS[((i - 1) % #TATTOO_ICONS) + 1]), kind = 'shop', tattoos = tattoos }
        ::continue::
    end

    if gang and gang ~= 'nogang' then
        local tattoos = {}
        for col, v in pairs(Config.TattooList) do
            for key, v2 in pairs(v) do
                if v2.gang and #v2.gang > 0 and ESX.tableFind(v2.gang, gang) then
                    tattoos[#tattoos + 1] = { key = col .. '_' .. key, label = v2.label or key, price = v2.price or 0, cat = col, num = key, owned = isOwned(col, key), txd = v2.txdHash, img = v2.pngfile or v2.img }
                end
            end
        end
        categories[#categories + 1] = { key = 'gang', label = 'Gang', icon = 'gang', kind = 'shop', tattoos = tattoos }
    end

    if primeStatus then
        local tattoos = {}
        for col, v in pairs(Config.TattooList) do
            for key, v2 in pairs(v) do
                if v2.prime and (primeStatus and primePoint >= v2.prime.point) then
                    tattoos[#tattoos + 1] = { key = col .. '_' .. key, label = v2.label or key, price = v2.price or 0, cat = col, num = key, owned = isOwned(col, key), txd = v2.txdHash, img = v2.pngfile or v2.img }
                end
            end
        end
        categories[#categories + 1] = { key = 'prime', label = 'Prime', icon = 'crown', kind = 'shop', tattoos = tattoos }
    end

    local delTattoos = {}
    for _, v in pairs(currentTattoos) do
        local data = Config.TattooList[v.collection] and Config.TattooList[v.collection][v.num]
        if data then
            local haveAccess = true
            local g = false
            if data.gang and #data.gang > 0 then
                haveAccess = ESX.tableFind(data.gang, gang)
                g = haveAccess
            end
            if data.private then
                haveAccess = v.access or g
            end
            if haveAccess then
                delTattoos[#delTattoos + 1] = { key = v.collection .. '_' .. v.num, label = data.label or v.num, cat = v.collection, num = v.num, owned = true, txd = data.txdHash, img = data.pngfile or data.img }
            end
        end
    end
    categories[#categories + 1] = { key = 'delete', label = 'Hazf', icon = 'trash', kind = 'delete', tattoos = delTattoos }

    return categories
end

local function refreshNui()
    SendNUIMessage({ action = 'refresh', categories = buildCategories(lastAccessList) })
end

local function doFlip()
    reverseCamera = not reverseCamera
    TaskGoStraightToCoord(PlayerPedId(), GetEntityCoords(PlayerPedId()), 8.0, 1600, GetEntityHeading(PlayerPedId()) + 180, 0.1)
    updateTattooCam()
end

function OpenShopMenu()
    if isCameraActive then return end
    isCameraActive = true
    reverseCamera = false
    originalHeading = GetEntityHeading(PlayerPedId())
    if not DoesCamExist(cam) then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 0, true, true)
        SetCamFov(cam, 40.0)
    end
    index = 1
    updateTattooCam()
    ESX.TriggerServerCallback('tattooshop:getAccessList', function(list)
        lastAccessList = list or {}
        SetNuiFocus(true, true)
        SendNUIMessage({ action = 'open', acc = tattooColor, accPrimary = tattooColorPrimary, categories = buildCategories(lastAccessList) })
    end)
end

RegisterNUICallback('preview', function(data, cb)
    local col, num = data.cat, data.num
    if col and num and Config.TattooList[col] and Config.TattooList[col][num] then
        drawTattoo(num, col)
        local d = Config.TattooList[col][num]
        index = d.pos or 1
        updateTattooCam()
        Wait(100)
        if d.back and not reverseCamera then
            doFlip()
        elseif reverseCamera then
            doFlip()
        end
    end
    cb('ok')
end)

RegisterNUICallback('category', function(data, cb)
    cb('ok')
end)

RegisterNUICallback('camera', function(data, cb)
    local ped = PlayerPedId()
    local d = data.dir
    if d == 'rotate-left' then
        SetEntityHeading(ped, GetEntityHeading(ped) + 6.0)
    elseif d == 'rotate-right' then
        SetEntityHeading(ped, GetEntityHeading(ped) - 6.0)
    elseif d == 'reset' then
        SetEntityHeading(ped, originalHeading)
        reverseCamera = false
        xOffset, yOffset = 0, 0
        centerCam()
    end
    cb('ok')
end)

RegisterNUICallback('buy', function(data, cb)
    local col, num = data.cat, data.num
    if not (col and num) then cb('ok') return end
    if isOwned(col, num) then
        ESX.Alert('', 'Shoma in tattoo ra darid', 5000, 'error')
        cb('ok') return
    end
    ESX.TriggerServerCallback('tattooShop:purchaseTattoo', function(success)
        if success then
            currentTattoos[#currentTattoos + 1] = { collection = col, num = num }
            refreshNui()
        end
    end, col, num)
    cb('ok')
end)

RegisterNUICallback('delete', function(data, cb)
    local col, num = data.cat, data.num
    if not (col and num) then cb('ok') return end
    ESX.TriggerServerCallback('tattooShop:deleteTattoo', function(success)
        if success then
            currentTattoos = success
            setOwnedTattoo()
            refreshNui()
        end
    end, col, num)
    cb('ok')
end)

RegisterNUICallback('close', function(data, cb)
    closeMenu()
    setPedSkin()
    cb('ok')
end)

AddEventHandler('sun_menu:settings', function(s)
    if type(s) == 'table' and s.tattoo then
        if s.tattoo.color then tattooColor = s.tattoo.color end
        if s.tattoo.colorPrimary then tattooColorPrimary = s.tattoo.colorPrimary end
        if isCameraActive then SendNUIMessage({ action = 'setColor', acc = tattooColor, accPrimary = tattooColorPrimary }) end
    end
end)

Citizen.CreateThread(function()
    for k,v in pairs(Config.Zones) do
        local blip = AddBlipForCoord(v)
        SetBlipSprite(blip, 75)
        SetBlipColour(blip, 1)
        SetBlipAsShortRange(blip, true)
        SetBlipScale(blip, 0.7)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(_U('tattoo_shop'))
        EndTextCommandSetBlipName(blip)
    end
end)


function setPedSkin()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        TriggerEvent('skinchanger:loadSkin', skin)
        exports['sunset_clothe']:removeStuffJob()
        Citizen.Wait(1000)
        exports['sunset_clothe']:loadUsed()
    end)

    Citizen.Wait(1000)

    setOwnedTattoo()
end

function drawTattoo(current, collection, notReload)
    ClearPedDecorations(PlayerPedId())

    if not notReload then
        setOwnedTattoo()
    end

    TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 then
            TriggerEvent('skinchanger:loadSkin', {
                sex      = 0,
                tshirt_1 = 15,
                tshirt_2 = 0,
                arms     = 15,
                torso_1  = 91,
                torso_2  = 0,
                pants_1  = 14,
                pants_2  = 0
            })
        else
            TriggerEvent('skinchanger:loadSkin', {
                sex      = 1,
                tshirt_1 = 34,
                tshirt_2 = 0,
                arms     = 15,
                torso_1  = 101,
                torso_2  = 1,
                pants_1  = 16,
                pants_2  = 0
            })
        end
    end)

    ApplyPedOverlay(PlayerPedId(), GetHashKey(collection), GetHashKey(Config.TattooList[collection][current].nameHash))

    if not DoesCamExist(cam) then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)

        SetCamActive(cam, true)
        RenderScriptCams(true, false, 0, true, true)
        SetCamFov(cam, 40.0)
        index = 1
    end
end



function cleanPlayer()
    ClearPedDecorations(PlayerPedId())
    setOwnedTattoo()
end

AddEventHandler('onKeyDown',function(key)
    if isCameraActive then
        if key == 'space' then
            reverseCamera = not reverseCamera
            TaskGoStraightToCoord(PlayerPedId(), GetEntityCoords(PlayerPedId()), 8.0, 1600, GetEntityHeading(PlayerPedId()) + 180, 0.1)
        end
    end
end)

function updateTattooCam()
    if DoesCamExist(cam) then
        if reverseCamera then
            SetCamCoord(cam, GetOffsetFromEntityInWorldCoords(PlayerPedId(), (cameraOffsets[index][1].x + xOffset) * -1.0, (cameraOffsets[index][1].y + yOffset) * -1.0, cameraOffsets[index][1].z))
            PointCamAtCoord(cam, GetOffsetFromEntityInWorldCoords(PlayerPedId(), cameraOffsets[index][2].y, cameraOffsets[index][2].y, cameraOffsets[index][2].z))
        else
            SetCamCoord(cam, GetOffsetFromEntityInWorldCoords(PlayerPedId(), cameraOffsets[index][1].x + xOffset, cameraOffsets[index][1].y + yOffset, cameraOffsets[index][1].z))
            PointCamAtCoord(cam, GetOffsetFromEntityInWorldCoords(PlayerPedId(), cameraOffsets[index][2].y, cameraOffsets[index][2].y, cameraOffsets[index][2].z))
        end
        xOffset, yOffset = 0, 0
    end
end

function centerCam()
    if DoesCamExist(cam) then
        local ped = PlayerPedId()
        SetCamCoord(cam, GetOffsetFromEntityInWorldCoords(ped, 0.0, 2.0, 0.45))
        PointCamAtCoord(cam, GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, 0.4))
        SetCamFov(cam, 40.0)
    end
end
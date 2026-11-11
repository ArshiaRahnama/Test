-- This Script Dump By FleeX Team  , discord.gg/2D79ZtUjxB

cam = nil
isCameraActive = false
mode = 'none'
ped = PlayerPedId()

componentIds = {
    ['tshirt'] = {id = 8, Dict = "clothingtie", Anim = "try_tie_negative_a", Move = 51, Dur = 1200},
    ['torso'] = {id = 11, Dict = "clothingtie", Anim = "try_tie_negative_a", Move = 51, Dur = 1200},
    ['pants'] = {id = 4, Dict = "re@construction", Anim = "out_of_breath", Move = 51, Dur = 1300},
    ['shoes'] = {id = 6, Dict = "random@domestic", Anim = "pickup_low", Move = 0, Dur = 1200},
    ['helmet'] = {id = 0, Dict = "mp_masks@standard_car@ds@", Anim = "put_on_mask", Move = 51, Dur = 600},
    ['mask'] = {id = 1, Dict = "mp_masks@standard_car@ds@", Anim = "put_on_mask", Move = 51, Dur = 800},
    ['ears'] = {id = 2, Dict = "mp_cp_stolen_tut", Anim = "b_think", Move = 51, Dur = 900},
    ['bag'] = {id = 5, Dict = "clothingtie", Anim = "try_tie_negative_a", Move = 51, Dur = 1200},
    ['chain'] = {id = 7, Dict = "clothingtie", Anim = "try_tie_positive_a", Move = 51, Dur = 2100},
    ['glasses'] = {id = 1, Dict = "clothingspecs", Anim = "take_off", Move = 51, Dur = 1400},
    ['bproof'] = {id = 9, Dict = "clothingtie", Anim = "try_tie_negative_a", Move = 51, Dur = 1200},
    ['watches'] = {id = 6, Dict = "nmt_3_rcm-10", Anim = "cs_nigel_dual-10", Move = 51, Dur = 1200},
    ['bracelets'] = {id = 7, Dict = "nmt_3_rcm-10", Anim = "cs_nigel_dual-10", Move = 51, Dur = 1200},
    ['decals'] = {id = 7, Dict = "nmt_3_rcm-10", Anim = "cs_nigel_dual-10", Move = 51, Dur = 1200},
    ['arms'] = {id = 3, Dict = "nmt_3_rcm-10", Anim = "cs_nigel_dual-10", Move = 51, Dur = 1200},
}


local function guardClothing()
    if ESX.canInteract() then return true end
    SendNuiMessage(json.encode({ action = 'clothingBlocked' }))
    return false
end

RegisterNUICallback('Select', function(data)
    if not guardClothing() then return end
    mode = data.mode
    local list = exports['Unique_clothe']:getOwnedClotheByType(mode, true)
    for _, v in ipairs(list) do
        v.iconUrl = getImage(v.name)
    end
    SendNuiMessage(json.encode({
        action = "loadClothe",
        obj = list,
        mode = mode,
        used = exports['Unique_clothe']:getUsedType()
    }))
end)

RegisterNUICallback('LoadPack', function()
    local list = exports['Unique_clothe']:getOwnedPack()
    for _, v in ipairs(list) do
        v.iconUrl = getImage(v.name)
    end
    SendNuiMessage(json.encode({
        action = 'loadClothe',
        obj = list,
        mode = 'pack'
    }))
end)

local clotheCountTypes = { 'torso', 'tshirt', 'pants', 'shoes', 'helmet', 'mask', 'glasses', 'bag', 'bproof', 'chain', 'watches', 'bracelets', 'ears', 'arms', 'decals' }
RegisterNUICallback('ClotheCounts', function(data, cb)
    local counts = {}
    for _, t in ipairs(clotheCountTypes) do
        counts[t] = #exports['Unique_clothe']:getOwnedClotheByType(t, true)
    end
    SendNuiMessage(json.encode({ action = 'clotheCounts', counts = counts }))
    cb({ ok = true })
end)



local spam = false

local packWearOrder = { 'shoes', 'pants', 'torso', 'tshirt', 'arms', 'bproof', 'mask', 'glasses', 'helmet', 'ears', 'chain', 'bag', 'watches', 'bracelets', 'decals' }

local function orderedPackItems(packItems)
    local byType = {}
    for itemName, owned in pairs(packItems) do
        if owned then
            local cData = exports['Unique_clothe']:getClotheData(itemName)
            local t = (cData and cData.type) or 'zzz'
            byType[t] = byType[t] or {}
            byType[t][#byType[t] + 1] = itemName
        end
    end
    local list = {}
    for _, t in ipairs(packWearOrder) do
        if byType[t] then
            for _, itemName in ipairs(byType[t]) do
                list[#list + 1] = itemName
            end
            byType[t] = nil
        end
    end
    for _, names in pairs(byType) do
        for _, itemName in ipairs(names) do
            list[#list + 1] = itemName
        end
    end
    return list
end

local function orderedTypes(wornTypes)
    local list = {}
    for _, t in ipairs(packWearOrder) do
        if wornTypes[t] then list[#list + 1] = t end
    end
    return list
end

RegisterNUICallback('ChangeClothe', function(data)
    if spam then return end
    if not guardClothing() then return end
    spam = true
    Citizen.SetTimeout(1000,function()
        spam = false
    end)
    TriggerEvent('removeSwatHelmet')
    if componentIds[data.name] then
		exports['Unique_clothe']:unUseByType(data.name)
		playClotheAnim(data.name)
        if data.name == 'bproof' then
            if GetPedArmour(PlayerPedId()) > 0 then
                TriggerEvent('esx:spawnObject', 'prop_bodyarmour_03')
                ESX.SetPedArmour(PlayerPedId(),0)
            end
            TriggerEvent('skinchanger:loadStuff',{bproof_1 = 0,bproof_2 = 0})
        end
        if data.name == 'helmet' and exports['Unique_utils']:checkArmoredHelmetActive() then
            exports['Unique_utils']:deactiveArmoredHelmet()
        end
	else
		exports['Unique_clothe']:toggleClothe(data.name)
		playClotheAnim(exports['Unique_clothe']:getClotheData(data.name).type)
    end
	Citizen.Wait(300)
    SendNuiMessage(json.encode({
        action = "update",
        obj = exports['Unique_clothe']:getUsedType()
    }))
    refreshPedScreen()
    loadPlayerInventory()
end)

RegisterNUICallback('TakeOffAll', function(data, cb)
    if spam then
        cb({ ok = true })
        return
    end
    if not guardClothing() then
        cb({ ok = false })
        return
    end
    spam = true
    Citizen.SetTimeout(15000, function() spam = false end)
    TriggerEvent('removeSwatHelmet')
    local used = exports['Unique_clothe']:getUsedType()
    local wornTypes = {}
    for typeName, isWorn in pairs(used) do
        if isWorn then wornTypes[typeName] = true end
    end
    local list = orderedTypes(wornTypes)
    if #list == 0 then
        SendNuiMessage(json.encode({ action = 'takeOffResult', ok = true }))
        spam = false
        cb({ ok = true })
        return
    end
    CreateThread(function()
        for _, typeName in ipairs(list) do
            focusCameraOn(typeName)
            Wait(450)
            playClotheAnim(typeName)
            if typeName == 'bproof' then
                if GetPedArmour(PlayerPedId()) > 0 then
                    TriggerEvent('esx:spawnObject', 'prop_bodyarmour_03')
                    ESX.SetPedArmour(PlayerPedId(), 0)
                end
                TriggerEvent('skinchanger:loadStuff', { bproof_1 = 0, bproof_2 = 0 })
            elseif typeName == 'helmet' and exports['Unique_utils']:checkArmoredHelmetActive() then
                exports['Unique_utils']:deactiveArmoredHelmet()
            end
            exports['Unique_clothe']:unUseByType(typeName)
            SendNuiMessage(json.encode({ action = 'update', obj = exports['Unique_clothe']:getUsedType() }))
            Wait(250)
        end
        SendNuiMessage(json.encode({ action = 'takeOffResult', ok = true }))
        loadPlayerInventory()
        spam = false
    end)
    cb({ ok = true })
end)

RegisterNUICallback('PackDetail', function(data, cb)
    ESX.TriggerServerCallback('clothe:getPackData', function(packItems)
        local list = {}
        if packItems then
            for itemName, owned in pairs(packItems) do
                if owned then
                    local c = exports['Unique_clothe']:getClotheData(itemName)
                    list[#list + 1] = {
                        name = itemName,
                        label = c and c.label or itemName,
                        type = c and c.type or nil,
                        iconUrl = getImage(itemName),
                    }
                end
            end
        end
        SendNuiMessage(json.encode({ action = 'loadPackDetail', name = data.name, items = list }))
    end, data.name)
    cb({ ok = true })
end)

RegisterNUICallback('UsePack', function(data, cb)
    if spam then
        cb({ ok = true })
        return
    end
    if not guardClothing() then
        cb({ ok = false })
        return
    end
    spam = true
    Citizen.SetTimeout(15000, function() spam = false end)
    ESX.TriggerServerCallback('clothe:usePack', function(packItems)
        if not packItems then
            SendNuiMessage(json.encode({ action = 'packResult', ok = false }))
            spam = false
            return
        end
        CreateThread(function()
            Wait(500)
            for _, itemName in ipairs(orderedPackItems(packItems)) do
                local cData = exports['Unique_clothe']:getClotheData(itemName)
                if cData then
                    focusCameraOn(cData.type)
                    Wait(450)
                    exports['Unique_clothe']:toggleClothe(itemName, true, true)
                    SendNuiMessage(json.encode({ action = 'update', obj = exports['Unique_clothe']:getUsedType() }))
                    Wait(250)
                end
            end
            local counts = {}
            for _, t in ipairs(clotheCountTypes) do
                counts[t] = #exports['Unique_clothe']:getOwnedClotheByType(t, true)
            end
            SendNuiMessage(json.encode({ action = 'clotheCounts', counts = counts }))
            SendNuiMessage(json.encode({ action = 'packResult', ok = true }))
            loadPlayerInventory()
            spam = false
        end)
    end, data.name)
    cb({ ok = true })
end)

RegisterNUICallback('CreatePack', function(data, cb)
    if spam then
        cb({ ok = true })
        return
    end
    if not guardClothing() then
        cb({ ok = false })
        return
    end
    spam = true
    Citizen.SetTimeout(15000, function() spam = false end)
    local toPack, n = {}, 0
    for k, v in pairs(exports['Unique_clothe']:getUsed()) do
        if v then
            local c = exports['Unique_clothe']:getClotheData(k)
            if c and not c.antiSearch then
                toPack[k] = true
                n = n + 1
            end
        end
    end
    if n < 2 then
        SendNuiMessage(json.encode({ action = 'packCreateResult', ok = false }))
        spam = false
        cb({ ok = true })
        return
    end
    CreateThread(function()
        for _, itemName in ipairs(orderedPackItems(toPack)) do
            local cData = exports['Unique_clothe']:getClotheData(itemName)
            if cData then
                focusCameraOn(cData.type)
                Wait(450)
                exports['Unique_clothe']:toggleClothe(itemName, true, true)
                SendNuiMessage(json.encode({ action = 'update', obj = exports['Unique_clothe']:getUsedType() }))
                Wait(250)
            end
        end
        ESX.TriggerServerEvent('clothe:createPack', toPack, data.name)
        Wait(800)
        local counts = {}
        for _, t in ipairs(clotheCountTypes) do
            counts[t] = #exports['Unique_clothe']:getOwnedClotheByType(t, true)
        end
        SendNuiMessage(json.encode({ action = 'clotheCounts', counts = counts }))
        SendNuiMessage(json.encode({ action = 'packCreateResult', ok = true }))
        loadPlayerInventory()
        spam = false
    end)
    cb({ ok = true })
end)

function playClotheAnim(mode)
    ESX.Streaming.RequestAnimDict(componentIds[mode].Dict)
    if ESX.isDeadOrCuff() then return end
    if IsPedInAnyVehicle(PlayerPedId()) then return end
    TaskPlayAnim(PlayerPedId(), componentIds[mode].Dict, componentIds[mode].Anim, 3.0, 3.0, componentIds[mode].Dur, componentIds[mode].Move, 0, false, false, false)

    Wait(componentIds[mode].Dur)
end
exports('playClotheAnim', playClotheAnim)
--

-- Citizen.CreateThread(Camera())

function packAnim()
    playClotheAnim('tshirt')
    playClotheAnim('pants')
    playClotheAnim('helmet')
    playClotheAnim('shoes')
    playClotheAnim('ears')
    playClotheAnim('glasses')
    playClotheAnim('bracelets')
end
exports('packAnim', packAnim)

componentIds = {
    ['tshirt'] = {id = 8, Dict = "clothingtie", Anim = "try_tie_negative_a", Move = 51, Dur = 1200},
    ['torso'] = {id = 11, Dict = "clothingtie", Anim = "try_tie_negative_a", Move = 51, Dur = 1200},
    ['pants'] = {id = 4, Dict = "re@construction", Anim = "out_of_breath", Move = 51, Dur = 1300},
    ['shoes'] = {id = 6, Dict = "random@domestic", Anim = "pickup_low", Move = 0, Dur = 1200},
    ['helmet'] = {id = 0, Dict = "mp_masks@standard_car@ds@", Anim = "put_on_mask", Move = 51, Dur = 600},
    ['mask'] = {id = 1, Dict = "mp_masks@standard_car@ds@", Anim = "put_on_mask", Move = 51, Dur = 800},
    ['ears'] = {id = 2, Dict = "mp_cp_stolen_tut", Anim = "b_think", Move = 51, Dur = 900},
    ['bag'] = {id = 5, Dict = "clothingtie", Anim = "try_tie_negative_a", Move = 51, Dur = 1200},
    ['chain'] = {id = 7, Dict = "clothingtie", Anim = "try_tie_positive_a", Move = 51, Dur = 2100},
    ['glasses'] = {id = 1, Dict = "clothingspecs", Anim = "take_off", Move = 51, Dur = 1400},
    ['bproof'] = {id = 9, Dict = "clothingtie", Anim = "try_tie_negative_a", Move = 51, Dur = 1200},
    ['watches'] = {id = 6, Dict = "nmt_3_rcm-10", Anim = "cs_nigel_dual-10", Move = 51, Dur = 1200},
    ['bracelets'] = {id = 7, Dict = "nmt_3_rcm-10", Anim = "cs_nigel_dual-10", Move = 51, Dur = 1200},
    ['decals'] = {id = 7, Dict = "nmt_3_rcm-10", Anim = "cs_nigel_dual-10", Move = 51, Dur = 1200},
    ['arms'] = {id = 3, Dict = "nmt_3_rcm-10", Anim = "cs_nigel_dual-10", Move = 51, Dur = 1200},
}


previewCam = nil
previewHeading = nil

local headParts = { helmet = true, mask = true, glasses = true, ears = true }
local chestParts = { tshirt = true, torso = true, bproof = true, chain = true, decals = true, bag = true }
local handParts = { arms = true, watches = true, bracelets = true }
local legParts = { pants = true }
local footParts = { shoes = true }

local camState = nil
local focusToken = 0
local pendingFocus = nil

local partAngle = {
    bag = 180.0,
    ears = 78.0,
    watches = 52.0,
    bracelets = 52.0,
    arms = 32.0,
}

local function computeFocus(ped, part)
    local headZ = GetPedBoneCoords(ped, 0x796E, 0.0, 0.0, 0.0).z
    local footZ = GetPedBoneCoords(ped, 0xCC4D, 0.0, 0.0, 0.0).z
    local pelvisZ = GetPedBoneCoords(ped, 0x2E28, 0.0, 0.0, 0.0).z
    local handZ = GetPedBoneCoords(ped, 0xDEAD, 0.0, 0.0, 0.0).z
    local aimZ, dist, fov
    if headParts[part] then
        aimZ, dist, fov = headZ, 1.2, 28.0
    elseif handParts[part] then
        aimZ, dist, fov = handZ, 1.5, 30.0
    elseif legParts[part] then
        aimZ, dist, fov = pelvisZ - (pelvisZ - footZ) * 0.5, 1.7, 36.0
    elseif footParts[part] then
        aimZ, dist, fov = footZ + 0.12, 1.4, 30.0
    elseif chestParts[part] then
        aimZ, dist, fov = pelvisZ + (headZ - pelvisZ) * 0.6, 1.7, 38.0
    else
        aimZ, dist, fov = (headZ + footZ) * 0.5, 2.2, 45.0
    end
    return {
        angle = partAngle[part] or 0.0,
        aimZ = aimZ, dist = dist, fov = fov,
        near = dist - 0.5, far = dist + 0.8,
    }
end

local function applyState(cam, ped, s)
    local coords = GetEntityCoords(ped)
    local rad = math.rad(s.angle)
    local camPos = GetOffsetFromEntityInWorldCoords(ped, s.dist * math.sin(rad), s.dist * math.cos(rad), s.aimZ - coords.z)
    SetCamCoord(cam, camPos.x, camPos.y, camPos.z)
    PointCamAtCoord(cam, coords.x, coords.y, s.aimZ)
    SetCamFov(cam, s.fov)
    SetCamUseShallowDofMode(cam, true)
    SetCamNearDof(cam, s.near)
    SetCamFarDof(cam, s.far)
    SetCamDofStrength(cam, 1.0)
end

function createPedScreen()
    if previewCam then return end
    if IsPedInAnyVehicle(PlayerPedId()) then return end
    local ped = PlayerPedId()
    previewHeading = GetEntityHeading(ped)
    ClearPedTasksImmediately(ped)
    FreezeEntityPosition(ped, true)
    previewCam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    camState = computeFocus(ped, pendingFocus or 'torso')
    pendingFocus = nil
    applyState(previewCam, ped, camState)
    SetCamActive(previewCam, true)
    RenderScriptCams(true, true, 500, true, true)
    CreateThread(function()
        while previewCam do
            SetUseHiDof()
            Wait(0)
        end
    end)
end

function focusCameraOn(part)
    if not previewCam then
        pendingFocus = part
        return
    end
    local ped = PlayerPedId()
    local target = computeFocus(ped, part)
    local from = camState or target
    focusToken = focusToken + 1
    local myToken = focusToken
    CreateThread(function()
        local steps = 24
        for i = 1, steps do
            if myToken ~= focusToken or not previewCam then return end
            local t = i / steps
            local e = t * t * (3.0 - 2.0 * t)
            local s = {
                angle = from.angle + (target.angle - from.angle) * e,
                aimZ = from.aimZ + (target.aimZ - from.aimZ) * e,
                dist = from.dist + (target.dist - from.dist) * e,
                fov = from.fov + (target.fov - from.fov) * e,
                near = from.near + (target.near - from.near) * e,
                far = from.far + (target.far - from.far) * e,
            }
            applyState(previewCam, ped, s)
            camState = s
            Wait(16)
        end
        camState = target
    end)
end

function deletePedScreen()
    if not previewCam then return end
    focusToken = focusToken + 1
    pendingFocus = nil
    RenderScriptCams(false, true, 400, true, false)
    DestroyCam(previewCam, false)
    previewCam = nil
    camState = nil
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, false)
    if previewHeading then
        SetEntityHeading(ped, previewHeading)
        previewHeading = nil
    end
end

function refreshPedScreen()
end

RegisterNUICallback('createPed', function()
    if not guardClothing() then return end
    createPedScreen()
    SendNuiMessage(json.encode({ action = 'clothePreview', shown = previewCam ~= nil }))
end)

RegisterNUICallback('deletePed', function()
    deletePedScreen()
end)

RegisterNUICallback('FocusCamera', function(data, cb)
    if data and data.part then
        focusCameraOn(data.part)
    end
    cb({ ok = true })
end)
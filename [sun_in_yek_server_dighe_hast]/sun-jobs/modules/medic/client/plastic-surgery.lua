-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local inSurgery, cam, surgeryData, cameraType, disableMove, tId = false, 0, {}, 0, false, 0
local x, y, z, x2, y2, z2 =  0.2, 5.0, 10.0, 0.2, -0.6, 0.0
local function openPlasticSurgery()
    if not inSurgery then
        ESX.selectPlayerMenu(function(src)
            local ped = GetPlayerPed(GetPlayerFromServerId(src))
            local bed = 0
            local coords = GetEntityCoords(ped)
            local near = false
            for k, v in pairs(Shared.ambulance.config.plasticSurgeryLocations) do
                if #(coords - v.xyz) < v.w then
                    near = true
                    break
                end
            end
            if near then
                for k, v in pairs(Shared.ambulance.config.plasticSurgery.models) do
                    bed = GetClosestObjectOfType(coords.x, coords.y, coords.z, 5.0, k, false, false, false)
                    if DoesEntityExist(bed) then break end
                end
                if DoesEntityExist(bed) then
                    ESX.TriggerServerEvent('medic:surgery:openSurgerySession', src)
                else
                    ESX.chatMessage('Takhti dar nazdik shoma nist', 'job')
                end
            else
                ESX.chatMessage('Nemitavanid dar inja jarahi konid', 'job')
            end
        end)
    end
end
exports('openPlasticSurgery', openPlasticSurgery)

local function disableMoveThread()
    CreateThread(function()
        disableMove = true
        while disableMove do
            Wait(0)
            DisableControlAction(0,30,true) -- move (w)
            DisableControlAction(0,31,true) -- move (a)
            DisableControlAction(0,32,true) -- move (s)
            DisableControlAction(0,34,true) -- move (d)
            DisableControlAction(0,35,true)
        end
    end)
end
local function closeMenu()
    ESX.UI.Menu.CloseAll()
    inSurgery = false
    TriggerEvent('core:updateHud:status', true)
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
    TriggerServerEvent('medic:surgery:cancel', surgeryData.skin)
end

RegisterNetEvent('medic:surgery:sleepOnBed', function()
    local bed = 0
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    for k, v in pairs(Shared.ambulance.config.plasticSurgery.models) do
        bed = GetClosestObjectOfType(coords.x, coords.y, coords.z, 5.0, k, false, false, false)
        if DoesEntityExist(bed) then break end
    end
    if DoesEntityExist(bed) then
        inSurgery, cameraType = true, 0
        exports['essentialmode']:disableallControl(true)
        TriggerEvent('core:updateHud:status', false)
        local bedCoords, bedHeading = GetEntityCoords(bed), GetEntityHeading(bed)
        ESX.Streaming.RequestAnimDict('missfbi1')
        exports['sunset_clothe']:unUseByType('mask')
        exports['sunset_clothe']:unUseByType('chain')
        exports['sunset_clothe']:unUseByType('torso')
        exports['sunset_clothe']:unUseByType('tshirt')
        exports['sunset_clothe']:unUseByType('helmet')
        exports['sunset_clothe']:unUseByType('arms')
        exports['sunset_clothe']:unUseByType('glasses')
        SetEntityCoords(ped, bedCoords.x, bedCoords.y, bedCoords.z)
        SetEntityHeading(ped, (bedHeading+180))
        TaskPlayAnim(ped, 'missfbi1', 'cpr_pumpchest_idle', 8.0, -8.0, -1, 1, 0, false, false, false)
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 0, true, true)
        SetCamFov(cam, 20.0)
        CreateThread(function()
            while inSurgery do
                local coords = GetEntityCoords(ped) + vec(0, 0, 1)
                DrawLightWithRange(coords.x, coords.y, coords.z, 255, 255, 255, 3.0, 50.0)
                local camCoords = GetOffsetFromEntityInWorldCoords(ped, 0.11, -0.55 + (cameraType == 1 and 0.4 or 0.0), 0.3)
                local camPointCoords = GetOffsetFromEntityInWorldCoords(ped, 0.11, -0.6 + (cameraType == 1 and 0.4 or 0.0), 0.0)
                SetCamCoord(cam, camCoords.x, camCoords.y, camCoords.z)
                PointCamAtCoord(cam, camPointCoords.x, camPointCoords.y, camPointCoords.z)
                ESX.ShowHelpNotification('~INPUT_CELLPHONE_CANCEL~ Jahate cancel jarahi')
                EnableControlAction(0, 177, true)
                if IsControlJustPressed(0, 177) then
                    TriggerServerEvent('medic:surgery:cancel2')
                end
                DisableAllControlActions(0)
                EnableControlAction(0, 249, true)
                Wait(0)
            end
        end)
    end
end)


local function openSurgerMenu(skin, components, max)
    local elements = {}
	for k, v in pairs(Shared.ambulance.config.plasticSurgery.params) do
        local data
        for k2, v2 in pairs(components) do
            if v2.name == v.k then
                data = v2
            end
        end
        if data then
            table.insert(elements, {
                label = ('%s($%s)'):format(data.label, ESX.Math.GroupDigits(v.price)),
                k = v.k,
                value = surgeryData.payed[v.k] or skin[v.k] or 0,
                defaultValue = skin[v.k]or 0,
                min = data.min,
                max = max[v.k],
                price = v.price,
                type = 'slider',
                cameraType = v.cameraType,
            })
        end
	end
    table.insert(elements, {label = ('Etemam kar($%s)'):format(ESX.Math.GroupDigits(surgeryData.cost or 0)), value = 'finish'})
    table.insert(elements, {label = 'Cancel', value = 'cancel'})
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'surg', {
		title    = 'Menu Job',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
        if data.current.value == 'cancel' then
            menu.close()
            closeMenu()
        elseif data.current.value == 'finish' then
            if ESX.tableLength(surgeryData.payed) > 0 then
                ESX.TriggerServerEvent('medic:surgery:finish', surgeryData.payed)
                menu.close()
                closeMenu()
                disableMoveThread()
                tId = ESX.SetTimeout(20000, function()
                    disableMove = false
                end)
                CreateThread(function()
                    lib.progressCircle({
                        duration = 20000,
                        position = 'bottom',
                        useWhileDead = false,
                        canCancel = false,
                        allowRagdoll = true,
                        allowFalling = true,
                    })
                end)
            else
                ESX.Alert('', 'Baraye etmam kar ebteda bayad yek taghir e\'mal konid', 7000, 'error')
            end
        else
            if data.current.value ~= data.current.defaultValue then
                if not surgeryData.payed[data.current.k] then
                    surgeryData.cost = surgeryData.cost + data.current.price
                end
                surgeryData.payed[data.current.k] = data.current.value
            elseif surgeryData.payed[data.current.k] then
                surgeryData.payed[data.current.k] = nil
                surgeryData.cost = surgeryData.cost - data.current.price
            end
            openSurgerMenu(skin, components, max)
        end
	end, nil, function(data, menu)
        if data.current.value ~= 'cancel' and data.current.value ~= 'finish' then
            local cam, cam2 = data.current.cameraType or 0
            if cam ~= cameraType then
                cameraType = cam
                cam2 = cam
            end
            TriggerServerEvent('medic:surgery:setPedSkinData', data.current.k, data.current.value, cam2)
        end
    end, function()
        closeMenu()
    end)
end

RegisterNetEvent('medic:surgery:openMenu', function(src, skin)
    local ped = GetPlayerPed(GetPlayerFromServerId(src))
    inSurgery, cameraType = true, 0
    TriggerEvent('core:updateHud:status', false)
    cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 0, true, true)
    SetCamFov(cam, 20.0)
    SetTimeout(1000, function ()
        local coords = GetOffsetFromEntityInWorldCoords(ped, 1.0, 0, 0)
        ESX.Game.Teleport(PlayerPedId(), coords)
        ESX.entityFaceEntity(PlayerPedId(), ped)
        exports['sun-animmenu']:PlayEmote('clipboard', true)
    end)
    CreateThread(function()
        while inSurgery do
            local coords = GetEntityCoords(ped) + vec(0, 0, 1)
            DrawLightWithRange(coords.x, coords.y, coords.z, 255, 255, 255, 3.0, 50.0)
            DisableAllControlActions(0)
            EnableControlAction(0, 249, true)
            local camCoords = GetOffsetFromEntityInWorldCoords(ped, 0.11, -0.55 + (cameraType == 1 and 0.4 or 0.0), 0.3)
            local camPointCoords = GetOffsetFromEntityInWorldCoords(ped, 0.11, -0.6 + (cameraType == 1 and 0.4 or 0.0), 0.0)
            SetCamCoord(cam, camCoords.x, camCoords.y, camCoords.z)
            PointCamAtCoord(cam, camPointCoords.x, camPointCoords.y, camPointCoords.z)
            Wait(0)
        end
    end)
    surgeryData = {skin = skin, cost = 0, payed = {}}
    TriggerEvent('skinchanger:getData', function(components, max)
        openSurgerMenu(skin, components, max)
    end)
end)

RegisterNetEvent('medic:surgery:cancel', function()
    if inSurgery then
        inSurgery = false
        TriggerEvent('core:updateHud:status', true)
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(cam, false)
        exports['essentialmode']:disableallControl(false)
        TriggerEvent('core:updateHud:status', true)
        -- ClearPedTasks(PlayerPedId())
    end
end)

RegisterNetEvent('medic:surgery:cancel2', function()
    closeMenu()
end)

RegisterNetEvent('medic:surgery:updateCamera', function(type)
    cameraType = type
end)

RegisterNetEvent('medic:surgery:pay', function(cost)
    SetTimeout(20000, function()
        ESX.UI.Menu.CloseAll()
    end)
    CreateThread(function()
        lib.progressCircle({
            duration = 20000,
            position = 'bottom',
            useWhileDead = false,
            canCancel = false,
            allowRagdoll = true,
            allowFalling = true,
        })
    end)
    local isOpen = true
    ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'pay', {
        title 	 = 'Taeed Jarahi',
        align    = 'center',
        question = 'Hazine jarahi $'..ESX.Math.GroupDigits(cost) .. ' shode, aya taeed mikonid??',
        elements = {
            {label = 'Taeed', value = 'ok'},
            {label = 'Cancel', value = 'cancel'},
        }
    }, function(data, menu)
        isOpen = false
        menu.close()
        if data.current.value == 'ok' then
            TriggerServerEvent('medic:surgery:pay')
            if lib.progressActive() then
                lib.cancelProgress()
            end
            exports['essentialmode']:disableallControl(true)
            disableMoveThread()
            Wait(6000)
            disableMove = false
            exports['essentialmode']:disableallControl(false)
        elseif data.current.value == 'cancel' then
            TriggerServerEvent('medic:surgery:cancelPayment')
            if lib.progressActive() then
                lib.cancelProgress()
            end
        end
    end, nil, nil, function()
        if isOpen then
            TriggerServerEvent('medic:surgery:cancelPayment', true)
        end
    end)
end)

RegisterNetEvent('medic:surgery:clearFreeze', function()
    if lib.progressActive() then
        lib.cancelProgress()
    end
    ESX.ClearTimeout(tId)
    disableMove = false
end)

RegisterNetEvent('medic:surgery:playEndAnim', function()
    if lib.progressActive() then
        lib.cancelProgress()
    end
    ESX.ClearTimeout(tId)
    exports['sun-animmenu']:PlayEmote('mechanic1', true)
    Wait(5000)
    disableMove = false
    ClearPedTasks(PlayerPedId())
end)

CreateThread(function()
    while not ESX do Wait(1000) end
    ESX.RegisterClientCallback('medic:surgery:question', function(cb)
        local alert = lib.alertDialog({
            header = 'Jarahi Pelastic',
            content = 'Aya mayel be jarahi pelastic hastid?',
            centered = true,
            cancel = true
        })
        cb(alert == 'confirm')
    end)
end)

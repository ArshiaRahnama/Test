-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local oxygen = false
local oxygenDarsad = 0
local nightVision = false

local function setOxygenDarsad(v)
    oxygenDarsad = v
    LocalPlayer.state:set('oxygenMaskDarsad', v, true)
end

function oxygenMask()
    if oxygen then
        setOxygenDarsad(100)
        ESX.showTextUI('Oxygen status : '.. oxygenDarsad .. '%')
        return
    end
    oxygen = true
    setOxygenDarsad(100)
    TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 then
            TriggerEvent('skinchanger:loadStuff',{mask_1 = 166,mask_2 = 0})
        else
            TriggerEvent('skinchanger:loadStuff',{mask_1 = 36,mask_2 = 0})
        end
    end)
    SetPedDiesInWater(PlayerPedId(), false)
    Citizen.CreateThread(function()
        ESX.showTextUI('Oxygen status : '.. oxygenDarsad .. '%')
        ESX.SetPlayerState('oxygenMask', true)
        Citizen.CreateThread(function()
            while oxygen do
                Wait(0)
                if SUN.isPlayerInWater then
                    local coords = GetEntityCoords(PlayerPedId())
                    local x,y,z = table.unpack(coords + GetEntityForwardVector(PlayerPedId()) * 0.5)
                    DrawLightWithRangeAndShadow(x,y,z, 255, 255, 255, 10.00, 10.0, 200.00)
                end
                if oxygenDarsad > 0 and oxygenDarsad <= 10 then
                    local alpha = math.floor(40 + (math.sin(GetGameTimer() / 400) + 1) * 20)
                    DrawRect(0.5, 0.005, 1.0, 0.01, 255, 180, 0, alpha)
                    DrawRect(0.5, 0.995, 1.0, 0.01, 255, 180, 0, alpha)
                    DrawRect(0.0025, 0.5, 0.005, 1.0, 255, 180, 0, alpha)
                    DrawRect(0.9975, 0.5, 0.005, 1.0, 255, 180, 0, alpha)
                end
            end
        end)
        local add = ((LocalPlayer.state.level or 1) * 15000) / 100
        while true do
            Citizen.Wait(3000 + add)
            TriggerEvent('skinchanger:getSkin', function(skin)
                if skin.sex == 0 then
                    TriggerEvent('skinchanger:loadStuff',{mask_1 = 166,mask_2 = 0})
                else
                    TriggerEvent('skinchanger:loadStuff',{mask_1 = 36,mask_2 = 0})
                end
            end)
            if oxygenDarsad > 0 then
                setOxygenDarsad(oxygenDarsad - 1)
                ESX.showTextUI('Oxygen status : '.. oxygenDarsad .. '%')
            else
                SetPedDiesInWater(PlayerPedId(), true)
                oxygen = false
                setOxygenDarsad(0)
                TriggerEvent('skinchanger:loadStuff',{mask_1 = 0,mask_2 = 0})
                ESX.hideTextUI()
                break
            end
        end
        ESX.SetPlayerState('oxygenMask', false)
    end)
end

RegisterNetEvent('oxygenMask',oxygenMask)
exports('oxygenMask', oxygenMask)

local inTh = false
local jobSpam = false
function ghayeghBadi(job,prop)
    if inTh then return end
    if job and jobSpam then return ESX.ShowNotification('Shoma har 10 daghighe mitavanid 1 gahyegh estefade konid!') end
    local coords = GetEntityCoords(PlayerPedId()) 
    local inwater , waterheight = GetWaterHeight(
        ESX.Math.Round(coords.x, 1),
        ESX.Math.Round(coords.y, 1),
        ESX.Math.Round(coords.z, 1)
    )
    if inwater == 1 then
        if not IsPedInAnyVehicle(PlayerPedId()) then
            inTh = true
            exports['sun-animmenu']:PlayEmote('medic',true)
            TriggerEvent("mythic_progbar:client:progress", {
                name = "bad",
                duration = math.random(20000,30000),
                label = "Dar hal bad kardan ghayegh",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                },
            }, function(status)
                if not status then
                    jobSpam = true
                    Citizen.SetTimeout(10 * 60 * 1000,function()
                        jobSpam = false
                    end)
                    ClearPedTasksImmediately(GetPlayerPed(-1))
                    if ESX.DoesHaveItem('ghayegh_badi',1,nil,nil,false) or job then
                        local coords = GetEntityCoords(PlayerPedId())
                        ESX.Game.SpawnVehicle('dinghy2', coords, GetEntityHeading(PlayerPedId()), function(vehicle)
                            TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                            TriggerEvent('esx:createvehiclekey')
                            ESX.TriggerServerEvent('setEntityState', NetworkGetNetworkIdFromEntity(vehicle), 'antiImpound', true)
                            if prop then
                                ESX.Game.SetVehicleProperties(vehicle,prop)
                            end
                            Citizen.CreateThread(function()
                                Citizen.Wait(2000)
                                ESX.setVehicleFuel(vehicle, 100.0)
                            end)
                            if not job then
                                Wait(1000)
                                ESX.Game.DeleteEntity(vehicle,true,5 * 60 * 1000)
                                Citizen.CreateThread(function()
                                    local darsad = 100
                                    ESX.showTextUI('Boat health : '.. darsad .. '%')
                                    while true do
                                        Citizen.Wait(3000)
                                        if darsad > 0 then
                                            darsad = darsad - 1
                                            local color = 'lightgreen'
                                            if darsad > 60 and darsad < 80 then
                                                color = 'lightblue'
                                            elseif darsad > 30 and darsad <= 60 then
                                                color = 'lightred'
                                            elseif darsad <= 30 then
                                                color = 'lightgrey'
                                            end
                                            ESX.showTextUI('Boat health : '.. darsad .. '%')
                                        else
                                            ESX.hideTextUI()
                                            break
                                        end
                                    end
                                end)
                            end
                        end)
                        TriggerServerEvent('items:remove','ghayegh_badi',1)
                    end
                elseif status then
                    ClearPedTasksImmediately(GetPlayerPed(-1))
                end
                inTh = false
            end)
        end
    else
        ESX.Alert('Error','Shoma dar nazdiki ab nistid!',5000,'error')
    end
end

exports('ghayeghBadi',ghayeghBadi)
RegisterNetEvent('ghayeghBadi',ghayeghBadi)

RegisterNetEvent('uave:use',function()
    TriggerEvent('InteractSound_CL:PlayOnOne','uavonline',0.9)
    local Players = GetActivePlayers()
    for k,v in pairs(Players) do
        local ped = GetPlayerPed(v)
        local distance = GetDistanceBetweenCoords(GetEntityCoords(ped),GetEntityCoords(PlayerPedId()))
        if distance <= 120 and ped ~= PlayerPedId() then
            blip = AddBlipForEntity(ped)
            SetBlipSprite(blip, 8)
            ShowHeadingIndicatorOnBlip(blip, true) 
            SetBlipRotation(blip, math.ceil(GetEntityHeading(ped)))
            SetBlipNameToPlayerName(blip, id)
            SetBlipScale(blip, 0.85)
            SetBlipColour(blip, 1)
            SetBlipAsShortRange(blip, true)
        end
    end
    Wait(60000)
    for k,v in pairs(Players) do
        local ped = GetPlayerPed(v)
        local blip = GetBlipFromEntity(ped)
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
end)

RegisterNetEvent('use:kit50',function()
    local vehicle,distance = ESX.Game.GetClosestVehicle()
    if vehicle ~= -1 and distance < 5 then
        if IsVehicleSeatFree(vehicle,-1) then
            local engine = GetVehicleEngineHealth(vehicle)
            local class = GetVehicleClass(vehicle)
            if engine < ((class == 15 or class == 16) and 900.0 or 500.0) then
                local pos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, 'overheat'))
                SetVehicleDoorOpen(vehicle, 4,0,0)
                --TaskGoStraightToCoord(PlayerPedId(), pos.x, pos.y, pos.z, 1.0, 1000, GetEntityHeading(vehicle))
                --Citizen.Wait(5000)
                makeEntityFaceEntity(GetEntityCoords(vehicle),PlayerPedId())
                TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
                TriggerEvent("mythic_progbar:client:progress", {
                    name = "kit",
                    duration = 10000,
                    label = "Dar ta'amir engine",
                    useWhileDead = false,
                    canCancel = true,
                    controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                    }
                    }, function(status)
                    if not status then	
                        if IsVehicleSeatFree(vehicle,-1) then
                            if ESX.DoesHaveItem('kit50',1,nil,nil,false) then
                                TriggerServerEvent('items:remove','kit50',1)
                                ESX.TriggerServerEvent('items:fixEngine',NetworkGetNetworkIdFromEntity(vehicle),ESX.Game.GetPlayersToSend(30),(class == 15 or class == 16) and 900.0 or 500.0)
                                ClearPedTasks(PlayerPedId())
                            end
                        end
                    end
                end)
            else
                ESX.Alert('','Engine in mashin salem ast!',7000,'warning')
            end
        else
            ESX.Alert('','Jahat estefade az kit mashin bayad bedun ranande bashad!',7000,'warning')
        end
    else
        ESX.Alert('','Mashini kenar shoma nist!',7000,'warning')
    end
end)

RegisterNetEvent('use:kit100',function()
    local vehicle,distance = ESX.Game.GetClosestVehicle()
    if vehicle ~= -1 and distance < 5 then
        if IsVehicleSeatFree(vehicle,-1) then
            local engine = GetVehicleEngineHealth(vehicle)   
            if engine < 1000 then
                local pos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, 'overheat'))
                SetVehicleDoorOpen(vehicle, 4,0,0)
                --TaskGoStraightToCoord(PlayerPedId(), pos.x, pos.y, pos.z, 1.0, 1000, GetEntityHeading(vehicle))
                --Citizen.Wait(5000)
                makeEntityFaceEntity(GetEntityCoords(vehicle),PlayerPedId())
                TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
                TriggerEvent("mythic_progbar:client:progress", {
                    name = "kit",
                    duration = 10000,
                    label = "Dar ta'amir engine",
                    useWhileDead = false,
                    canCancel = true,
                    controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                    }
                    }, function(status)
                    if not status then	
                        if IsVehicleSeatFree(vehicle,-1) then
                            if ESX.DoesHaveItem('kit100',1,nil,nil,false) then
                                TriggerServerEvent('items:remove','kit100',1)
                                ESX.TriggerServerEvent('items:fixEngine',NetworkGetNetworkIdFromEntity(vehicle),ESX.Game.GetPlayersToSend(30),1000.0)
                                ClearPedTasks(PlayerPedId())
                            end
                        end
                    end
                end)
            else
                ESX.Alert('','Engine in mashin salem ast!',7000,'warning')
            end
        else
            ESX.Alert('','Jahat estefade az kit mashin bayad bedun ranande bashad!',7000,'warning')
        end
    else
        ESX.Alert('','Mashini kenar shoma nist!',7000,'warning')
    end
end)

RegisterNetEvent('items:fixEngine',function(vehicle,damage)
    vehicle = NetworkGetEntityFromNetworkId(vehicle)
    if DoesEntityExist(vehicle) then
        if damage == 1000 then
            ESX.SetVehicleFixed(Vehicle)
		    SetVehicleDirtLevel(Vehicle, 0.0)
            --tire
        else
            local class = GetVehicleClass(vehicle)
            if class == 15 or class == 16 then
                ESX.SetVehicleFixed(Vehicle)
                Wait(300)
                ESX.SetVehicleEngineHealth(vehicle,damage)
            else
                ESX.SetVehicleEngineHealth(vehicle,damage)
            end
        end
    end
end)

function makeEntityFaceEntity(crds, entity)
    local p2 = crds
    local p1 = GetEntityCoords(entity, true)

    local dx = p2.x - p1.x
    local dy = p2.y - p1.y

    local heading = GetHeadingFromVector_2d(dx, dy)
    SetEntityHeading(entity, heading)
end

RegisterNetEvent('use:kittire',function()
    local vehicle,distance = ESX.Game.GetClosestVehicle()
    if vehicle ~= -1 and distance < 5 then
        if IsVehicleSeatFree(vehicle,-1) then
            local count = 0
            if IsVehicleTyreBurst(vehicle, 0, false) then
                count = count + 1
            end
            --Right Front
            if IsVehicleTyreBurst(vehicle, 1, false)  then
                count = count + 1
            end
            --Left Rear
            if IsVehicleTyreBurst(vehicle, 4, false) then
                count = count + 1
            end
            --Right Rear
            if IsVehicleTyreBurst(vehicle, 5, false) then
                count = count + 1
            end
            if count > 0 then
                local pos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, 'overheat'))
                --TaskGoStraightToCoord(PlayerPedId(), pos.x, pos.y, pos.z, 1.0, 1000, GetEntityHeading(vehicle))
                --Citizen.Wait(5000)
                makeEntityFaceEntity(GetEntityCoords(vehicle),PlayerPedId())
                -- TaskStartScenarioInPlace(PlayerPedId(), "CODE_HUMAN_MEDIC_KNEEL", 0, true)
                local carryObj = 0
                ESX.Game.SpawnObject('prop_wheel_03', GetEntityCoords(PlayerPedId()), function(spawnObj)
					carryObj = spawnObj
					local boneIndex = GetPedBoneIndex(PlayerPedId(), 28422)
					AttachEntityToEntity(spawnObj, PlayerPedId(), boneIndex, 0, 0, 0, 0, 0, 0, true, true, false, true, 1, true)
				end)
                TriggerEvent("mythic_progbar:client:progress", {
                    name = "kit",
                    duration = 10000,
                    label = "Dar ta'amir tire",
                    useWhileDead = false,
                    canCancel = true,
                    controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                    },
                    animation = {
                        animDict = "anim@heists@box_carry@",
                        anim = "idle",
                    },
                    }, function(status)
                        ESX.Game.DeleteObject(carryObj)
                        if not status then	
                            if IsVehicleSeatFree(vehicle,-1) then
                                if ESX.DoesHaveItem('kittire',1,nil,nil,false) then
                                    TriggerServerEvent('items:remove','kittire',1)
                                    ESX.TriggerServerEvent('items:fitTire',NetworkGetNetworkIdFromEntity(vehicle),ESX.Game.GetPlayersToSend(30))
                                    ClearPedTasks(PlayerPedId())
                                end
                            end
                        end
                end)
            else
                ESX.Alert('','Tire in mashin salem ast!',7000,'warning')
            end
        else
            ESX.Alert('','Jahat estefade az kit mashin bayad bedun ranande bashad!',7000,'warning')
        end
    else
        ESX.Alert('','Mashini kenar shoma nist!',7000,'warning')
    end
end)

RegisterNetEvent('items:fitTire',function(vehicle)
    vehicle = NetworkGetEntityFromNetworkId(vehicle)
    SetVehicleBodyHealth(vehicle,1000.0)
    if DoesEntityExist(vehicle) then
        local tireIndex = {["wheel_lf"] = 0, ["wheel_rf"] = 1, ["wheel_lm1"] = 2, ["wheel_rm1"] = 3, ["wheel_lm2"] = 45,["wheel_rm2"] = 47, ["wheel_lm3"] = 46, ["wheel_rm3"] = 48, ["wheel_lr"] = 4, ["wheel_rr"] = 5,}
        for k,v in pairs(tireIndex) do
            SetVehicleTyreFixed(vehicle, v)
            SetVehicleWheelHealth(vehicle, v, 100) 
        end
    end
end)

RegisterNetEvent('use:cleaner',function()
    local vehicle,distance = ESX.Game.GetClosestVehicle()
    if vehicle ~= -1 and distance < 5 then
        if IsVehicleSeatFree(vehicle,-1) then
            local pos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, 'overheat'))
            --TaskGoStraightToCoord(PlayerPedId(), pos.x, pos.y, pos.z, 1.0, 1000, GetEntityHeading(vehicle))
            --Citizen.Wait(5000)
            makeEntityFaceEntity(GetEntityCoords(vehicle),PlayerPedId())
            TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_MAID_CLEAN", 0, true)
            TriggerEvent("mythic_progbar:client:progress", {
                name = "kit",
                duration = 10000,
                label = "Dar tamiz kardan",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
                }
                }, function(status)
                if not status then	
                    if IsVehicleSeatFree(vehicle,-1) then
                        if ESX.DoesHaveItem('cleaner',1,nil,nil,false) then
                            local dirtyLevel = GetVehicleDirtLevel(vehicle)
                            TriggerServerEvent('items:remove','cleaner',1)
                            SetVehicleDirtLevel(vehicle, 0)
                            ClearPedTasks(PlayerPedId())
                            if ESX.PlayerData.job.name == 'mechanic' then
                                --if dirtyLevel > 8.0 then
                                    ESX.TriggerServerEvent('items:successCleanQuest')
                                --end
                            end
                        end
                    end
                end
            end)
        else
            ESX.Alert('','Jahat estefade az kit mashin bayad bedun ranande bashad!',7000,'warning')
        end
    else
        ESX.Alert('','Mashini kenar shoma nist!',7000,'warning')
    end
end)

RegisterNetEvent('use:mask_shab', function()
    if not nightVision then
        nightVision = true
        SetNightvision(true)
        TriggerEvent('skinchanger:getSkin', function(skin)
            local helmet = configItems.nightVision.helmet[skin.sex]
            if skin.sex == 0 then
                TriggerEvent('skinchanger:loadStuff', {helmet_1 = helmet[1], helmet_2 = helmet[2]})
            else
                TriggerEvent('skinchanger:loadStuff', {helmet_1 = helmet[1], helmet_2 = helmet[2]})
            end
        end)
        SetTimeout((configItems.nightVision.duration * 1000) + (LocalPlayer.state.level or 1) * 15000, function()
            nightVision = false
            SetNightvision(false)
            TriggerEvent('skinchanger:loadStuff', {helmet_1 = -1, helmet_2 = -1})
        end)
    end
end)

local lastSetedCycle = {}

AddEventHandler('onSkinChange', function()
    TriggerEvent('skinchanger:getSkin', function(skin)
        if nightVision then
            local helmet = configItems.nightVision.helmet[skin.sex]
            if skin.helmet_1 ~= helmet[1] then
                if skin.sex == 0 then
                    TriggerEvent('skinchanger:loadStuff', {helmet_1 = helmet[1], helmet_2 = helmet[2]})
                else
                    TriggerEvent('skinchanger:loadStuff', {helmet_1 = helmet[1], helmet_2 = helmet[2]})
                end
            end
        end

        local config = configItems.glasses[skin.sex]
        if config then
            local find = false
            for k, v in pairs(config) do
                if v.num[1] == skin.glasses_1 and v.num[2] == skin.glasses_2 then
                    find = true
                    if lastSetedCycle.name ~= v.name then
                        if lastSetedCycle.name then
                            TriggerEvent('core:applyScreenEffect', lastSetedCycle.name)
                            lastSetedCycle = {}
                        end
                        lastSetedCycle.name = v.name
                        TriggerEvent('core:applyScreenEffect', v.name, v.strength, 1)
                    end
                end
            end
            if not find and lastSetedCycle.name then
                TriggerEvent('core:applyScreenEffect', lastSetedCycle.name)
                lastSetedCycle = {}
            end
        end
    end)
end)

RegisterNetEvent('use:jack',function()
    local vehicle,distance = ESX.Game.GetClosestVehicle()
    if vehicle ~= -1 and distance < 5 then
        if IsVehicleSeatFree(vehicle,-1) then
            local roll = GetEntityRoll(vehicle)
            if roll > 75 or roll < -75 then
                local pos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, 'overheat'))
                SetVehicleDoorOpen(vehicle, 4,0,0)
                --TaskGoStraightToCoord(PlayerPedId(), pos.x, pos.y, pos.z, 1.0, 1000, GetEntityHeading(vehicle))
                --Citizen.Wait(5000)
                makeEntityFaceEntity(GetEntityCoords(vehicle),PlayerPedId())
                TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
                TriggerEvent("mythic_progbar:client:progress", {
                    name = "jack",
                    duration = 10000,
                    label = "",
                    useWhileDead = false,
                    canCancel = true,
                    controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                    }
                    }, function(status)
                    if not status then
                        if IsVehicleSeatFree(vehicle,-1) then
                            if ESX.DoesHaveItem('jack', 1, nil, nil, false) then
                                TriggerServerEvent('items:remove','jack', 1)
                                exports['esx_vehiclecontrol']:flip(vehicle)
                                ClearPedTasks(PlayerPedId())
                            end
                        end
                    end
                end)
            else
                ESX.Alert('','In mashin niaz be jack nadarad!',7000,'warning')
            end
        else
            ESX.Alert('','Jahat estefade az jack mashin bayad bedun ranande bashad!',7000,'warning')
        end
    else
        ESX.Alert('','Mashini kenar shoma nist!',7000,'warning')
    end
end)

-- Hookah
local currentHookah = nil
local moasel = nil
local smoking = false
local function destroyHookah()
    if currentHookah then
        ESX.Game.DeleteEntity(currentHookah)
        currentHookah = nil
        TriggerServerEvent('hookah:setEntity', nil)
    end
end

local function createHookah()
    if not currentHookah then
        local coords = exports['sun-jobs']:rayCastPut(configItems.hookah.model, 5)
        if coords then
            ESX.Game.SpawnObject(configItems.hookah.model, coords, function(object)
                currentHookah = object
                PlaceObjectOnGroundProperly(currentHookah)
                TriggerServerEvent('hookah:setEntity', NetworkGetNetworkIdFromEntity(object))
                while DoesEntityExist(currentHookah) do
                    Wait(1000)
                    if #(GetEntityCoords(currentHookah) - SUN.PlayerCoords) > 150 then
                        destroyHookah()
                    end
                end
            end)
        end
    end
end

RegisterNetEvent('use:hookah', function()
    if not currentHookah and exports['sun-jobs']:notBlackListCoords() then
        createHookah()
    end
end)

RegisterNetEvent('esx:removeInventoryItemss', function(label, count, name, newCount)
    if name == 'sun_hookah_1' and newCount <= 0 and currentHookah then
        destroyHookah()
    end
end)

local function playHookahAnim()
    local boneIndex = GetPedBoneIndex(SUN.ped, 24818)
    local object = ESX.Game.SpawnObject(configItems.hookah.shelangModel, vec(SUN.PlayerCoords.x + 0.5, SUN.PlayerCoords.y + 0.1, SUN.PlayerCoords.z + 0.4), nil, true)
    AttachEntityToEntity(object, SUN.ped, boneIndex, -0.43, 0.68, 0.18, 0.0, 90.0, 90.0, true, true, false, true, 1, true)
    ESX.Streaming.RequestAnimDict('anim@heists@humane_labs@finale@keycards')
	TaskPlayAnim(SUN.ped, 'anim@heists@humane_labs@finale@keycards', 'ped_a_enter_loop', 8.00, -8.00, configItems.hookah.smookingTime, 49, 0.00, false, false, false)
    SetTimeout(configItems.hookah.smookingTime, function()
        ESX.Game.DeleteEntity(object)
        StopAnimTask(SUN.ped, 'anim@heists@humane_labs@finale@keycards', 'ped_a_enter_loop', 1.0)
        smoking = false
        removeStress('hookah')
    end)
end

local hookahEffect = {}
local function activeHookahEffect()
    if hookahEffect.active then
        hookahEffect.value += 0.01
    else
        hookahEffect.active = true
        hookahEffect.value = 0.01
        CreateThread(function()
            while hookahEffect.active do
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', hookahEffect.value)
                Wait(1500)
            end
            StopGameplayCamShaking(true)
        end)
        SetTimeout(5 * 60000, function()
            hookahEffect = {}
        end)
    end
end

local armoredHelmetActive = false

local function onSelect(object)
    object = object.entity
    if moasel and moasel > 0 then
        if not smoking then
            moasel -= 1
            smoking = true
            ESX.entityFaceEntity(SUN.ped, object)
            activeHookahEffect()
            ESX.TriggerServerEvent('hookah:smoke', ESX.Game.GetPlayersToSend(15.0))
            playHookahAnim()
        end
    else
        ESX.chatMessage('Shoma naiz be tanbaku darid', 'plarms')
        local options = {}
        for k, v in pairs(configItems.hookah.moasels) do
            if ESX.DoesHaveItem2(k, 1) then
                table.insert(options, {label = ESX.getItemLabel(k), values = k, args = k, icon = ('nui://sun-inventory-hud/ui/img/items/%s.png'):format(k)})
            end
        end
        if #options == 0 then
            table.insert(options, {label = 'Shoma tanbaku nadarid!'})
        end
        lib.registerMenu({
            id = 'useMoasel',
            title = 'Tanbaku',
            options = options
        }, function(selected, scrollIndex, args)
            if args then
                ESX.TriggerServerCallback('core:removeItem', function(removed)
                    if removed then
                        ESX.entityFaceEntity(PlayerPedId(), object)
                        Wait(100)
                        TriggerEvent('anim:play', 'tanbaku')
                        moasel = configItems.hookah.moasels[args]
                        ESX.chatMessage('Tanbaku estefade shod', 'plarms')
                    end
                end, args, 1)
            end
        end)
        lib.showMenu('useMoasel')
    end
end
CreateThread(function()
    waitForLoad()
    exports['ox_target']:addModel({
        configItems.hookah.model,
    },{
        {
            label = 'کشیدن🚬',
            canInteract = function()
                return moasel and moasel > 0
            end,
            onSelect = onSelect
        },{
            label = 'چاغ کردن🚬',
            canInteract = function()
                return not (moasel and moasel > 0)
            end,
            onSelect = onSelect
        }
        ,{
            label = 'برداشتن❌',
            canInteract = function(entity)
                return entity == currentHookah
            end,
            onSelect = function(entity)
                destroyHookah()
            end
        }
    })
    Wait(5000)
    ESX.RegisterClientCallback('items:checkHelmetActive', function(cb)
        cb(armoredHelmetActive)
    end)
end)


RegisterNetEvent('hookah:smoke_cl', function(player)
    if ESX.Game.doesPlayerExist(player) then
        local ped = GetPlayerPed(GetPlayerFromServerId(player))
        local smoke = UseParticleFxAsset('core')
        local part = StartParticleFxLoopedOnEntityBone('exp_grd_bzgas_smoke', ped, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetPedBoneIndex(ped, 20279), 5.0, 0.0, 0.0, 0.0)
        exports['xsound']:PlayUrl('hookah'.. 1, './sounds/hookah.ogg', 0.1)
        Wait(5000)
        StopParticleFxLooped(smoke, 1)
        Wait(7000)
        RemoveParticleFxFromEntity(ped)
    end
end)

--armored hat

RegisterNetEvent('items:activeHelmet', function()
    if not armoredHelmetActive then
        armoredHelmetActive = true
        SetPedConfigFlag(SUN.ped, 438, false)
        exports['sunset_clothe']:unUseByType('helmet')
        Wait(2000)
        CreateThread(function()
            TriggerEvent('skinchanger:getSkin', function(skin)
                TriggerEvent('skinchanger:loadClothes', skin, {['helmet_1'] = configItems.armoredHelmet.helmetNum[skin.sex][1],  ['helmet_2'] = configItems.armoredHelmet.helmetNum[skin.sex][2]})
            end)
            while armoredHelmetActive do
                TriggerEvent('skinchanger:getSkin',function(cb)
                    if cb.helmet_1 ~= configItems.armoredHelmet.helmetNum[cb.sex][1] or cb.helmet_2 ~= configItems.armoredHelmet.helmetNum[cb.sex][2] then
                        armoredHelmetActive = false
                    end
                end)
                if not exports['sun-jobs']:notBlackListCoords() and SUN.world < 61 then
                    SetPedConfigFlag(SUN.ped, 438, true)
                else
                    SetPedConfigFlag(SUN.ped, 438, false)
                end
                Wait(4000)
            end

            TriggerEvent('skinchanger:loadStuff', {['helmet_1'] = -1,  ['helmet_2'] = 0})
            exports['sunset_clothe']:unUseByType('helmet')
            SetPedConfigFlag(SUN.ped, 438, true)
            ESX.TriggerServerEvent('items:removeArmoredHelmet')
        end)
    end
end)

exports('checkArmoredHelmetActive', function()
    return armoredHelmetActive
end)

exports('deactiveArmoredHelmet', function()
    armoredHelmetActive = false
end)

AddEventHandler('esx:onPlayerDeath',function()
	armoredHelmetActive = false
end)
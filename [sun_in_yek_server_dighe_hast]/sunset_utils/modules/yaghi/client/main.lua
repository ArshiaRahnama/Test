-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local yaghiCD = false
local yaghiCD2, yaghiCD3 = false, false
local throwEntity = nil
local throwEntityPichundan = nil
local bID = 1
Citizen.CreateThread(function()
    waitForLoad()
    for k, v in pairs(configYaghi.props) do
        local prop = {GetHashKey(k)}
        exports['ox_target']:addModel(prop, {
            {
                label = "🔧پیچوندن",
                onSelect = function(entity)
                    entity = entity.entity
                    if yaghiCD2 then return else yaghiCD2 = true Citizen.SetTimeout(5000,function() yaghiCD2 = false end) end
                    Wait(500)
                    if yaghiCD or SUN.isPlayerInVehicle or throwEntity or yaghiCD3 then return end
                    if exports['gangs']:isInGreenZone() then return ESX.Alert('','در مکان های سبز امکان انجام این کار وجود ندارد',5000,'error') end
                    local canSteal = true
                    local coords = GetEntityCoords(entity)
                    yaghiCD = true
                    local rand = math.random(1,1000)
                    bID = rand
                    local time = exports['sunset_utils']:getSkillTime('yaghi_skill', 'farm_yaghi')
                    SetTimeout(time * 1100,function() 
                        if rand == bID then
                            yaghiCD = false
                        end
                    end)
                    local p = promise.new()
                    ESX.TriggerServerCallback('yaghi:canSteal',function(can)
                        p:resolve(can)
                    end,coords)
                    canSteal = Citizen.Await(p)
                    if canSteal then
                        local x = GetEntityRotation(entity).x
                        if (x < 0.1 and x > -0.1) and canSteal then
                            if ESX.DoesHaveItem2('blowtorch') then
                                yaghiCD = true
                                TaskTurnPedToFaceEntity(SUN.ped, entity, -1)
                                local hour = GetClockHours()
                                if hour >= 6 and hour < 21 then
                                    ESX.TriggerServerEvent('yaghi:alarm',ESX.Game.GetPlayersToSend(400))
                                end
                                Wait(1000)
                                exports['sun-animmenu']:PlayEmote('weld')
                                exports['essentialmode']:disablecontrol('x',true)
                                yaghiCD3 = true
                                ESX.chatMessage('yaghi 0')
                                if ESX.progressCircle(time * 1000, false, true) then
                                    ESX.chatMessage('yaghi 1')
                                    Wait(math.random(500,1000))
                                    exports['essentialmode']:disablecontrol('x',false)
                                    ESX.chatMessage('yaghi 2')
                                    ESX.TriggerServerCallback('yaghi:steal', function(success)
                                        print('yaghi 3')
                                        if success then
                                            ESX.chatMessage('yaghi 4')
                                            ClearPedTasks(SUN.ped)
                                            Wait(1000)
                                            exports['essentialmode']:disablecontrol('x',true)
                                            ESX.Streaming.RequestAnimDict('rcmnigel1d')
                                            TaskPlayAnim(SUN.ped, 'rcmnigel1d', 'base_club_shoulder', 2.0, 2.0, -1, 51, 0, false, false, false)
                                            exports['sun-animmenu']:Walk('armored')
                                            TriggerEvent("dpemote:enable",false)
                                            ESX.Game.SpawnObject(k, coords, function(obj)
                                                throwEntityPichundan = obj
                                                addStress('yaghi_start')
                                                AttachEntityToEntity(obj, SUN.ped, GetPedBoneIndex(SUN.ped, 60309), -0.1390, -0.9870, 0.4300, -67.3315314, 145.0627869, -4.4318885, true, true, false, true, 1, true)
                                                Wait(500)
                                                ESX.TriggerServerEvent('setEntityState', NetworkGetNetworkIdFromEntity(obj), 'yaghi',true)
                                                ESX.TriggerServerEvent('setEntityState', NetworkGetNetworkIdFromEntity(obj), 'antiDelete',true)
                                                while true do
                                                    Wait(0)
                                                    if SUN.isPlayerInVehicle then
                                                        TaskLeaveVehicle(SUN.ped, GetVehiclePedIsIn(SUN.ped), 16)
                                                    end
                                                    ESX.ShowMissionText('Hala be samte yek vanet beravid!')
                                                    DisableControlAction(0, 21, true)
                                                    DisableControlAction(0, 22, true)
                                                    DisableControlAction(0, 25, true)
                                                    disableFiring()
                                                    if not IsEntityPlayingAnim(SUN.ped, 'rcmnigel1d', 'base_club_shoulder', 3) then
                                                        TaskPlayAnim(SUN.ped, 'rcmnigel1d', 'base_club_shoulder', 2.0, 2.0, -1, 51, 0, false, false, false)
                                                    end 
                                                    local vehicle, distance = ESX.Game.GetClosestVehicle(SUN.PlayerCoords) 
                                                    if vehicle ~= -1 and distance < 4 then 
                                                        ESX.ShowHelpNotification('~INPUT_CONTEXT~ jahat bar zadan')
                                                    else
                                                        ESX.ShowHelpNotification('~INPUT_VEH_DUCK~ jahat cancel kardan')
                                                    end
                                                    if IsControlJustPressed(0, 38) then
                                                        if vehicle ~= -1 and distance < 4 then
                                                            if ESX.isVehicleLocked(vehicle) or not IsVehicleSeatFree(vehicle,-1) then
                                                                ESX.Alert('','در ماشین قفل است',5000,'error')
                                                            elseif Entity(vehicle).state.JobCenter then
                                                                ESX.Alert('','شما نمیتوانید از این ماشین استفاده کنید',5000,'error')
                                                            else
                                                                local weight = exports['sun-inventory-hud']:getVehicleMaxWeight(vehicle)
                                                                if weight >= 300 then
                                                                    local wait = math.random(10000,15000)
                                                                    if ESX.progressCircle(wait, false, true) then
                                                                        throwEntityPichundan = nil
                                                                        ESX.Game.RequestControl(vehicle)
                                                                        ESX.Game.RequestControl(obj)
                                                                        local placedEntity = Entity(vehicle).state.placedEntity
                                                                        if not placedEntity or placedEntity < weight then
                                                                            AttachEntityToEntity(obj, vehicle, GetEntityBoneIndexByName(vehicle,'platelight'), 0.0, 1.0, 0.0, -43.0, 0, math.random(0,360)+0.0, true, true, false, true, 1, true)
                                                                            while not IsEntityAttachedToEntity(obj, vehicle) do
                                                                                AttachEntityToEntity(obj, vehicle, GetEntityBoneIndexByName(vehicle,'platelight'), 0.0, 1.0, 0.0, -43.0, 0, math.random(0,360)+0.0, true, true, false, true, 1, true)
                                                                                Wait(100)
                                                                            end
                                                                            ESX.TriggerServerEvent('setEntityState', NetworkGetNetworkIdFromEntity(vehicle), 'placedEntity',(Entity(vehicle).state.placedEntity and Entity(vehicle).state.placedEntity + configYaghi.entityWeight) or configYaghi.entityWeight)
                                                                            --Entity(vehicle).state:set('placedEntity',,true)
                                                                            ClearPedTasks(SUN.ped)
                                                                            exports['essentialmode']:disablecontrol('x',false)
                                                                            yaghiCD = false
                                                                            break
                                                                        else
                                                                            ESX.Alert('','این ماشین فضای کافی ندارد',5000,'error')
                                                                        end
                                                                    end
                                                                else
                                                                    ESX.Alert('','این ماشین فضای کافی ندارد',5000,'error')
                                                                end
                                                            end
                                                        else
                                                            ESX.Alert('','شما در نزدیکی ماشینی نیستید',5000,'error')
                                                        end
                                                    end
                                                    if IsControlJustPressed(0, 73) or not DoesEntityExist(obj) then
                                                        ClearPedTasks(SUN.ped)
                                                        ESX.Game.DeleteEntity(obj)
                                                        exports['essentialmode']:disablecontrol('x',false)
                                                        yaghiCD = false
                                                        throwEntityPichundan = nil
                                                        break
                                                    end
                                                end
                                                ResetPedMovementClipset(SUN.ped)
                                                TriggerEvent("dpemote:enable",true)
                                                yaghiCD = false
                                            end)
                                        else
                                            ESX.chatMessage('yaghi 5')
                                            yaghiCD = false
                                        end
                                    end, coords)
                                    ESX.Game.DeleteLocalObject(entity)
                                    Wait(3000)
                                    yaghiCD3 = false
                                end
                                ESX.chatMessage('yaghi 10')
                                yaghiCD = false
                            else
                                ESX.Alert('','شما به یک دستگاه جوش نیاز دارید',5000,'error')
                                yaghiCD = false
                            end
                        else
                            ESX.Alert('','.این شیء صدمه دیده است',5000,'error')
                            yaghiCD = false
                        end
                    else
                        yaghiCD = false
                    end
                end,
            },
        })
    end
    ESX.RegisterPoint(configYaghi.meltingPos - vector3(0,0,1),3,{
		Color = {R = 255,G = 0,B = 0,A = 255},
		DrawDistance = 5,
		Radius = 1.5,
		Type = 0
	},{
		Notification = nil,
		DrawText = '~INPUT_CONTEXT~ jahat zobe felez',
		DrawTextRadius = 4,
		DrawTextCoords = configYaghi.meltingPos,
		Key = 'e',
		CB = function()
            if yaghiCD2 then return else yaghiCD2 = true Citizen.SetTimeout(5000,function() yaghiCD2 = false end) end
			if throwEntity then
                local netId = NetworkGetNetworkIdFromEntity(throwEntity)
                local __ = throwEntity
                throwEntity = nil
                local wait = math.random(10000,15000)
                ESX.progressCircle(wait, false, true)
                ESX.TriggerServerEvent('yaghi:melt',netId)
                Wait(5000)
                ESX.Game.DeleteEntity(__)
            else
                ESX.Alert('','!شما شیء جهت ذوب ندارید',5000,'error')
            end
		end,
	},{
		In = nil,
		Out = ESX.UI.Menu.CloseAll
	})
end)

AddEventHandler('yaghi:pickup',function(vehicle)
    if yaghiCD2 then return else yaghiCD2 = true Citizen.SetTimeout(5000,function() yaghiCD2 = false end) end
    if yaghiCD or SUN.isPlayerInVehicle or throwEntity or throwEntityPichundan then return end
    -- local vehicle, distance = ESX.Game.GetClosestVehicle(SUN.PlayerCoords) 
    -- if vehicle ~= -1 and distance < 4 then
    if vehicle ~= -1 then
        local placedEntity = Entity(vehicle).state.placedEntity
        if placedEntity and placedEntity >= 100 then
            if ESX.isVehicleLocked(vehicle) or not IsVehicleSeatFree(vehicle,-1) or not exports['sunset_utils']:canAccessToVehicle(vehicle) then
                ESX.Alert('','در ماشین قفل است',5000,'error')
            else
                yaghiCD = true
                local rand = math.random(1,1000)
                bID = rand
                SetTimeout(20000,function()
                    if rand == bID then
                        yaghiCD = false
                    end
                end)

                local wait = math.random(10000,15000)
                ESX.TriggerServerEvent('setEntityState', NetworkGetNetworkIdFromEntity(vehicle), 'placedEntity',Entity(vehicle).state.placedEntity - configYaghi.entityWeight)
                ESX.progressCircle(wait, false, true)
                ESX.Game.RequestControl(vehicle)
                local entity = nil
                local objects = ESX.Game.GetObjects()
                for k, v in pairs(objects) do
                    if IsEntityAttachedToEntity(v, vehicle) then
                        DetachEntity(v, true, true)
                        entity = v
                        break
                    end
                end
                if entity and DoesEntityExist(entity) then
                    ESX.Game.RequestControl(vehicle)
                    ESX.Game.RequestControl(entity)
                    TriggerEvent("dpemote:enable",false)
                    exports['sun-animmenu']:Walk('armored')
                    exports['essentialmode']:disablecontrol('x',true)
                    DetachEntity(entity, true, true)
                    AttachEntityToEntity(entity, SUN.ped, GetPedBoneIndex(SUN.ped, 60309), -0.1390, -0.9870, 0.4300, -67.3315314, 145.0627869, -4.4318885, true, true, false, true, 1, true)
                    while not IsEntityAttachedToEntity(entity, SUN.ped) do
                        AttachEntityToEntity(entity, SUN.ped, GetPedBoneIndex(SUN.ped, 60309), -0.1390, -0.9870, 0.4300, -67.3315314, 145.0627869, -4.4318885, true, true, false, true, 1, true)
                        Wait(100)
                    end
                    throwEntity = entity
                    while true do
                        Wait(0)
                        local vehicle, distance = ESX.Game.GetClosestVehicle(SUN.PlayerCoords) 
                        if vehicle ~= -1 and distance < 4 then 
                            ESX.ShowHelpNotification('~INPUT_CONTEXT~ jahat bar zadan')
                        else
                            ESX.ShowHelpNotification('~INPUT_VEH_DUCK~ jahat cancel kardan')
                        end
                        if SUN.isPlayerInVehicle then
                            TaskLeaveVehicle(SUN.ped, GetVehiclePedIsIn(SUN.ped), 16)
                        end
                        DisableControlAction(0, 21, true)
                        DisableControlAction(0, 22, true)
                        DisableControlAction(0, 25, true)
                        disableFiring()
                        if not IsEntityPlayingAnim(SUN.ped, 'rcmnigel1d', 'base_club_shoulder', 3) then
                            TaskPlayAnim(SUN.ped, 'rcmnigel1d', 'base_club_shoulder', 2.0, 2.0, -1, 51, 0, false, false, false)
                        end 
                        if not yaghiCD2 and IsControlJustPressed(0, 38) then
                            Wait(500)
                            if not yaghiCD2 and vehicle ~= -1 and distance < 4 then
                                if ESX.isVehicleLocked(vehicle) or not IsVehicleSeatFree(vehicle,-1) then
                                    ESX.Alert('','در ماشین قفل است',5000,'error')
                                else
                                    local weight = exports['sun-inventory-hud']:getVehicleWeight(vehicle)
                                    if weight >= 300000 then
                                        local wait = math.random(10000,15000)
                                        ESX.progressCircle(wait, false, true)
                                        ESX.Game.RequestControl(vehicle)
                                        ESX.Game.RequestControl(throwEntity)
                                        local placedEntity = Entity(vehicle).state.placedEntity
                                        if not placedEntity or placedEntity < weight then
                                            AttachEntityToEntity(throwEntity, vehicle, GetEntityBoneIndexByName(vehicle,'platelight'), 0.0, 1.0, 0.0, -43.0, 0, math.random(0,360)+0.0, true, true, false, true, 1, true)
                                            while not IsEntityAttachedToEntity(throwEntity, vehicle) do
                                                AttachEntityToEntity(throwEntity, vehicle, GetEntityBoneIndexByName(vehicle,'platelight'), 0.0, 1.0, 0.0, -43.0, 0, math.random(0,360)+0.0, true, true, false, true, 1, true)
                                                Wait(100)
                                            end
                                            ESX.TriggerServerEvent('setEntityState', NetworkGetNetworkIdFromEntity(vehicle), 'placedEntity',(Entity(vehicle).state.placedEntity and Entity(vehicle).state.placedEntity + configYaghi.entityWeight) or configYaghi.entityWeight)
                                            --Entity(vehicle).state:set('placedEntity',,true)
                                            ClearPedTasks(SUN.ped)
                                            exports['essentialmode']:disablecontrol('x',false)
                                            yaghiCD = false
                                            throwEntity = nil
                                            break
                                        else
                                            ESX.Alert('','این ماشین فضای کافی ندارد',5000,'error')
                                        end
                                    else
                                        ESX.Alert('','این ماشین فضای کافی ندارد',5000,'error')
                                    end
                                end
                            else
                                --ESX.Alert('','شما در نزدیکی ماشینی نیستید',5000,'error')
                            end
                        end 
                        if not throwEntity then
                            exports['essentialmode']:disablecontrol('x',false)
                            yaghiCD = false
                            break   
                        end
                        if not IsEntityAttachedToEntity(throwEntity, SUN.ped) then
                            yaghiCD = false
                            throwEntity = nil
                            break
                        end
                        if not DoesEntityExist(throwEntity) then
                            yaghiCD = false
                            throwEntity = nil
                            break
                        end
                        if IsControlJustPressed(0, 73) then   
                            ClearPedTasks(SUN.ped)
                            ESX.Game.DeleteEntity(entity)
                            exports['essentialmode']:disablecontrol('x',false)
                            yaghiCD = false
                            throwEntity = nil
                            break
                        end
                    end
                    ResetPedMovementClipset(SUN.ped)
                    TriggerEvent("dpemote:enable",true)
                    ClearPedTasks(SUN.ped)
                    yaghiCD = false
                end
                yaghiCD = false  
            end
        end
    end
end)

RegisterNetEvent('yaghi:alarm',function(coords)
    if configYaghi.alarmJob[ESX.PlayerData.job.name] then
        local blip = ESX.AddBlipForCoord(coords,1.0,15,1,'Yaghi')
        SetTimeout(60000,function()
            ESX.removeBlip(blip)
        end)
    end
end)

RegisterCommand('yaghi',function(source,args,raw)
    print(yaghiCD,SUN.isPlayerInVehicle,throwEntity)
end)
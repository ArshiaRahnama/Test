-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local carblip                 = 0
local drawInD                 = false

local function openRequst(id)
    ESX.TriggerServerCallback('mechanic:getlist', function(data)
        ems = data
        elements = {}
        emoji = "❌"
        if ems[id].accept then
            emoji = "✔️"
        end
        table.insert(elements,{label = "Id : ".. ems[id].source,value = "no"})
        table.insert(elements,{label = "Accept status : ".. emoji,value = "no"})
        if ems[id].accept then
            table.insert(elements,{label = "Accepted by : ".. ems[id].acceptername,value = "no"})
        else
            table.insert(elements,{label = "Accept",value = "accept"})
        end
        if ems[id].acceptersource == GetPlayerServerId(PlayerId()) then
            table.insert(elements,{label = "Decline",value = "decline"})
            table.insert(elements,{label = "Finish",value = "finish"})
        end
        table.insert(elements,{label = "Pin location",value = "pin"})
        table.insert(elements,{label = "Call",value = "call"})
        local source = ems[id].source
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ems_list2', {
            title    = 'Request list',
            align    = 'top-left',
            elements = elements
        }, function(data2, menu2)
            if data2.current.value == "accept" then
                TriggerServerEvent('mechanic:accept',id)
                openRequst(id)
            elseif data2.current.value == "decline" then
                TriggerServerEvent('mechanic:decline',id)
                openRequst(id)
            elseif data2.current.value == "finish" then
                TriggerServerEvent('mechanic:finish',id)
                menu2.close()
            elseif data2.current.value == "pin" then
                ESX.TriggerServerCallback('getplayercoords', function(coords)
                    if coords ~= nil then
                        SetNewWaypoint(coords.x,coords.y)
                        SetNewWaypoint(coords.x,coords.y)
                    end
                end,source)
            elseif data2.current.value == "call" then
                --TriggerEvent('gcphone:autoCall',ems[id].number)
                exports['sun-phone']:Call({number = ems[id].number,name = ems[id].number})
            end
        end, function(data2, menu2)
            menu2.close()
        end)
    end)
end

function openMechanicRequest()
    ESX.TriggerServerCallback('mechanic:getlist', function(data)
        ems = data
        local lenth = CountTable(ems)
        if lenth == 0 then
            ESX.ShowNotification('Hich darkhasti vojoud nadarad')
        else
            elements = {}
            for k , v in ipairs(ems) do
                if v.show then
                    emoji = "❌"
                    if v.accept then
                        emoji = '<span style="color:green;">' .. v.acceptersource .. '</span>'
                    end
                    table.insert(elements,{label = "Request id : ".. v.source .. " | Accept : ".. emoji .." | Distance : ".. ESX.Math.Round(ESX.GetDistance(GetEntityCoords(PlayerPedId()),v.coords)),value = k})
                end
            end
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ems_list', {
                title    = 'Request list',
                align    = 'top-left',
                elements = elements
            }, function(data2, menu)
                menu.close()
                local id = tonumber(data2.current.value)
                openRequst(id)
            end, function(data2, menu)
                menu.close()
            end)
        end
    end)
end

function mechanicRepairVehicle()
    if ESX.DoesHaveItem('kit100',1,nil,nil,false) then
        ESX.selectVehicleMenu(function(vehicle)
            if not vehicle then
                TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Hich mashini nazdik shoma nist!", 'job')
                return
            end
            local bime = exports["esx_vehiclecontrol"]:RepairVehicle(vehicle,true, true)
            SUN.log('job_mechanic_repair',"Fix car",GetPlayerName(PlayerId()).." (".. ESX.PlayerData.name ..") (".. ESX.PlayerData.job.name ..") (".. GetPlayerServerId(PlayerId()) ..") ".. ESX.GetVehicleLabelFromHash(GetEntityModel(vehicle)) .. " pelak ".. GetVehicleNumberPlateText(vehicle) .. " engine health : ".. ESX.Math.Round(GetVehicleEngineHealth(vehicle)).."/1000 fix kard\nBime : ".. tostring(bime))
            SUN.log('repairadmin',"Fix car",GetPlayerName(PlayerId()).." (".. ESX.PlayerData.name ..") (".. ESX.PlayerData.job.name ..") (".. GetPlayerServerId(PlayerId()) ..") ".. ESX.GetVehicleLabelFromHash(GetEntityModel(vehicle)) .. " pelak ".. GetVehicleNumberPlateText(vehicle) .. " engine health : ".. ESX.Math.Round(GetVehicleEngineHealth(vehicle)).."/1000 fix kard\nBime : ".. tostring(bime))
        end, 8)
    else
        ESX.Alert('','Shoma niaz be repair kit darid',5000,'error')
    end
end

function mechanicFixEngine()
    ESX.selectVehicleMenu(function(vehicle)
        if not vehicle then
            TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Hich mashini nazdik shoma nist!", 'job')
            return
        end
        exports["esx_vehiclecontrol"]:RepairVehicle2(vehicle)
    end, 8)
end

function mechanicFlip()
    ESX.selectVehicleMenu(function(vehicle)
        if not vehicle then
            TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Hich mashini nazdik shoma nist!", 'job')
            return
        end
        exports['esx_vehiclecontrol']:flip(vehicle)
    end, 8)
end

function mechanicImound()
    local ped = GetPlayerPed(-1)
    if DoesEntityExist(ped) and not IsEntityDead(ped) then
        local pos = GetEntityCoords( ped )
        if IsPedSittingInAnyVehicle(ped) then
            local vehicle = GetVehiclePedIsIn( ped, false )
            if GetPedInVehicleSeat(vehicle, -1) == ped then
                ClearPedTasksImmediately(GetPlayerPed(-1))
                TaskStartScenarioInPlace(GetPlayerPed(-1), 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
                TriggerEvent("mythic_progbar:client:progress", {
                    name = "mechanic_impound",
                    duration = 15000,
                    label = "Dar hale impound kardan mashin",
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
                        if ESX.GetDistance(GetEntityCoords(PlayerPedId()), GetEntityCoords(vehicle)) > 10.0 then
                            return ESX.chatMessage('Mashin mored nazar az shoma fasele gerefte ast!', 'job')
                        end
                        TriggerServerEvent('checkcustom',GetVehicleNumberPlateText(vehicle))
                        ESX.ShowNotification(_U(Shared.mechanic.Locale, 'vehicle_impounded'))
                        SUN.log('job_mechanic_impound',"Impound car",GetPlayerName(PlayerId()).." (".. ESX.PlayerData.name ..") (".. ESX.PlayerData.job.name ..") (".. GetPlayerServerId(PlayerId()) ..") ".. ESX.GetVehicleLabelFromHash(GetEntityModel(vehicle))  .. " pelak ".. GetVehicleNumberPlateText(vehicle) .. " impound kard")
                        SUN.log('allimp',"Impound car",GetPlayerName(PlayerId()).." (".. ESX.PlayerData.name ..") (".. ESX.PlayerData.job.name ..") (".. GetPlayerServerId(PlayerId()) ..") ".. ESX.GetVehicleLabelFromHash(GetEntityModel(vehicle))  .. " pelak ".. GetVehicleNumberPlateText(vehicle) .. " impound kard")
                        if not exports["esx_vehiclecontrol"]:IsGOV(vehicle) then
                            TriggerServerEvent('mechanic:impound')
                            local model, coords, heading, level, plate, ownerHex = GetEntityModel(vehicle), GetEntityCoords(vehicle), GetEntityHeading(vehicle), Entity(vehicle).state.ownerLevel, ESX.GetPlate(vehicle), Entity(vehicle).state.ownerHex
                            ESX.removeCarKey(vehicle)
				            ESX.TriggerServerEvent('mechanic:impound:startImpoundSession', NetworkGetNetworkIdFromEntity(vehicle), exports['esx_vehiclecontrol']:IsGOV(target))
                        else
                            ESX.Game.DeleteVehicle(vehicle)
                        end
                        -- ESX.Game.DeleteVehicle(vehicle)
                    elseif status then
                    end
                end)
            else
                ESX.ShowNotification(_U(Shared.mechanic.Locale, 'must_seat_driver'))
            end
        else
            local vehicle = ESX.Game.GetVehicleInDirection()
            if DoesEntityExist(vehicle) then
                TaskStartScenarioInPlace(GetPlayerPed(-1), 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
                TriggerEvent("mythic_progbar:client:progress", {
                    name = "mechanic_impound",
                    duration = 15000,
                    label = "Dar hale impound kardan mashin",
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
                        if ESX.GetDistance(GetEntityCoords(PlayerPedId()), GetEntityCoords(vehicle)) > 10.0 then
                            return ESX.chatMessage('Mashin mored nazar az shoma fasele gerefte ast!', 'job')
                        end
                        TriggerServerEvent('checkcustom',GetVehicleNumberPlateText(vehicle))
                        ESX.ShowNotification(_U(Shared.mechanic.Locale, 'vehicle_impounded'))
                        SUN.log('job_mechanic_impound',"Impound car",GetPlayerName(PlayerId()).." (".. ESX.PlayerData.name ..") (".. ESX.PlayerData.job.name ..") (".. GetPlayerServerId(PlayerId()) ..") ".. ESX.GetVehicleLabelFromHash(GetEntityModel(vehicle)) .. " pelak ".. GetVehicleNumberPlateText(vehicle) .. " impound kard")
                        SUN.log('allimp',"Impound car",GetPlayerName(PlayerId()).." (".. ESX.PlayerData.name ..") (".. ESX.PlayerData.job.name ..") (".. GetPlayerServerId(PlayerId()) ..") ".. ESX.GetVehicleLabelFromHash(GetEntityModel(vehicle)) .. " pelak ".. GetVehicleNumberPlateText(vehicle) .. " impound kard")
                        if not exports["esx_vehiclecontrol"]:IsGOV(vehicle) then
                            TriggerServerEvent('mechanic:impound')
                            local model, coords, heading, level, plate, ownerHex = GetEntityModel(vehicle), GetEntityCoords(vehicle), GetEntityHeading(vehicle), Entity(vehicle).state.ownerLevel, ESX.GetPlate(vehicle), Entity(vehicle).state.ownerHex
                            ESX.removeCarKey(vehicle)
                            ESX.TriggerServerEvent('mechanic:impound:startImpoundSession', NetworkGetNetworkIdFromEntity(vehicle), exports['esx_vehiclecontrol']:IsGOV(target))
                        else
                            ESX.Game.DeleteVehicle(vehicle)
                        end
                        -- ESX.Game.DeleteVehicle(vehicle)
                    elseif status then
                    end
                end)
            else
                ESX.ShowNotification(_U(Shared.mechanic.Locale, 'must_near'))
            end
        end
    end
end

function mechanicFlatbed()
    local playerped = GetPlayerPed(-1)
    -- if IsPedInAnyVehicle(playerped) then
    --     ESX.chatMessage('Shoma nemitavanid savar mashin flatbed konid', 'job')
    -- end
    local vehicle = 0
    local towmodel = `flatbed`
    local vehicles = {}
    local de = 0
    for k , v in pairs(ESX.Game.GetVehicles()) do
        if ESX.GetDistance(GetEntityCoords(PlayerPedId()),GetEntityCoords(v)) <= 20 then
            if IsVehicleModel(v, towmodel) then
                vehicle = v
            else
                if IsEntityAttachedToAnyVehicle(v) then
                    de = v
                elseif ESX.GetDistance(GetEntityCoords(PlayerPedId()),GetEntityCoords(v)) <= 10 then
                    table.insert(vehicles,{label = ESX.GetVehicleLabelFromHash(GetEntityModel(v)) .. ' (' .. GetVehicleNumberPlateText(v) ..')',vehicle = v})
                end
            end
        end
    end
    for k, entity in pairs(ESX.Game.GetObjects()) do
        if Entity(entity).state.impoundEntity then
            if IsEntityAttachedToAnyVehicle(entity) then
                de = entity
            elseif ESX.GetDistance(GetEntityCoords(PlayerPedId()), GetEntityCoords(entity)) <= 10 then
                table.insert(vehicles,{label = ESX.GetVehicleLabelFromHash(GetEntityModel(entity)) .. ' ',vehicle = entity, object = true})
            end
        end
    end
    if vehicle and de == 0 then
        List = {}
        for k , v in pairs(vehicles) do
            table.insert(List,{
                img = 'SS_gold.png',
                text = v.label,
                text2 = '',
                callBack = function()
                    exports.icon_menu:ForceCloseMenu()
                    ESX.Game.RequestControl(v.vehicle)
                    -- if ESX.Game.RequestControl(vehicle) then
                    ESX.TriggerServerEvent('setEntityState', NetworkGetNetworkIdFromEntity(v.vehicle), 'attachVehicleToVehicle', NetworkGetNetworkIdFromEntity(vehicle))
                    AttachEntityToEntity(v.vehicle, vehicle, 20, -0.5, -6.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
                    if Entity(v.vehicle).state.impoundEntity then
                        ESX.TriggerServerEvent('mechanic:impound:clearDeleteTimeout', Entity(v.vehicle).state.impoundEntity)
                    end
                    local near = nil
                    local coords = GetEntityCoords(PlayerPedId())
                    for k, v in pairs(Shared.mechanic.zones.vehicleDeleterImpound) do
                        if not near or #(coords - v.xyz) < near.distance then
                            near = {
                                coords = v,
                                distance = #(coords - v.xyz),
                            }
                        end
                    end
                    Wait(200)
                    ESX.TriggerServerEvent('setEntityState', NetworkGetNetworkIdFromEntity(v.vehicle), 'attachVehicleToVehicle', nil)
                    -- else
                        -- ESX.Alert('Yek moshkel dar attach kardan be vojoud amade')
                    -- end
                end})
        end
        exports.icon_menu:OpenMenu(List)
    elseif de ~= 0 then
        ESX.TriggerServerEvent('setEntityState', NetworkGetNetworkIdFromEntity(de), 'detachVehicle', NetworkGetNetworkIdFromEntity(vehicle))
        AttachEntityToEntity(de, vehicle, 20, -0.5, -12.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
        DetachEntity(de, true, true)
        if Entity(de).state.impoundEntity then
            ESX.TriggerServerEvent('mechanic:impound:setDeleteTimeout', Entity(de).state.impoundEntity)
        end
        Wait(200)
        ESX.TriggerServerEvent('setEntityState', NetworkGetNetworkIdFromEntity(de), 'detachVehicle', nil)
    end
end

AddStateBagChangeHandler('detachVehicle', nil, function(bagName, k, v)
    local entity = GetEntityFromStateBagName(bagName)
    if entity ~= 0 and v ~= false then
        local vehicle = NetworkGetEntityFromNetworkId(v)
        AttachEntityToEntity(entity, vehicle, 20, -0.5, -12.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
        DetachEntity(entity, true, true)
        PlaceObjectOnGroundProperly(entity)
    end
end)

AddStateBagChangeHandler('attachVehicleToVehicle', nil, function(bagName, k, v)
    local entity = GetEntityFromStateBagName(bagName)
    if entity ~= 0 and v ~= false then
        local vehicle = NetworkGetEntityFromNetworkId(v)
        AttachEntityToEntity(entity, vehicle, 20, -0.5, -6.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
    end
end)

RegisterNetEvent('mechanic:openAdmin',function()
    ESX.TriggerServerCallback('mechanic:getlist', function(data)
        ems = data
        local lenth = CountTable(ems)
        if lenth == 0 then
            ESX.ShowNotification('Hich darkhasti vojoud nadarad')
        else
            elements = {}
            for k , v in ipairs(ems) do
                emoji = "❌"
                if v.accept then
                    emoji = '<span style="color:green;">' .. v.acceptersource .. '</span>'
                end
                table.insert(elements,{label = "Request id : ".. v.source .. " | Accept : ".. emoji .." | Distance : ".. ESX.Math.Round(ESX.GetDistance(GetEntityCoords(PlayerPedId()),v.coords)) ,value = k})
            end
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ems_list', {
                title    = 'Request list',
                align    = 'top-left',
                elements = elements
            }, function(data2, menu)
                menu.close()
                local id = tonumber(data2.current.value)
                openRequst(id)
            end, function(data2, menu)
                menu.close()
            end)
        end
    end)
end)

RegisterNetEvent('mechanic:addmecblip',function(id,coords,name)
    local id = id
    if carblip ~= 0 then
        RemoveBlip(carblip)
        carblip = 0
    end
    Wait(2000)
    carblip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(carblip, 402)
    SetBlipFlashes(carblip, true)
    SetBlipColour(carblip,46)
    SetBlipFlashTimer(carblip, 5000)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('Mechanic officer')
    EndTextCommandSetBlipName(carblip)
    while carblip ~= 0 do
        Wait(1000)
        ESX.TriggerServerCallback('getplayercoords', function(coords)
            if coords ~= nil then
                SetBlipCoords(carblip, coords.x, coords.y, coords.z)
            else
                RemoveBlip(carblip)
                carblip = 0
            end
        end,id)
        ESX.ShowAdvancedNotification(name, '~g~Dar rah ast~s~', '/mechanic to open request menu', 'CHAR_CARSITE2', 7)
    end
end)

RegisterNetEvent('mechanic:deleteblip',function()
    if carblip ~= 0 then
        RemoveBlip(carblip)
        carblip = 0
    end
end)

RegisterCommand('mechanic',function()
    ESX.TriggerServerCallback('mechanic:getmerequest',function(id,v)
        if id == nil then
            ESX.ShowNotification('Shoma hich darkhast mechanic ersal nakardid')
        else
            elements = {}
            emoji = "❌"
            if v.accept then
                emoji = "✔️"
            end
            table.insert(elements,{label = "Request id : ".. id .. " | Accept : ".. emoji,value = id})

            if v.accept then
                table.insert(elements,{label = "Accepted by : ".. v.acceptername,value = "no"})
                table.insert(elements,{label = "Call",value = "call"})
            else
                table.insert(elements,{label = "Cancel request",value = "cancel"})
            end

            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ems_list', {
                title    = 'Request list',
                align    = 'top-left',
                elements = elements
            }, function(data, menu)
                if data.current.value == "call" then
                    --TriggerEvent('gcphone:autoCall',v.accepternumber)
                    exports['sun-phone']:Call({number = v.accepternumber,name = v.accepternumber})
                elseif data.current.value == "cancel" then
                    ESX.TriggerServerCallback('mechanic:remove',function(data)
                        menu.close()
                    end)
                end
            end, function(data, menu)
                menu.close()
            end)
        end
    end)
end, false)

RegisterNetEvent('mechanic:acceptq',function(id)
    local elements = {
        {label = 'Bale', value = true},
        {label = 'Kheyr', value = false},
    }
    ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'a' .. id,
        {
            title 	 = 'Darkhast jadid!',
            align    = 'center',
            question = 'Aya mayel be ghabul kardan darkhast hastid?',
            elements = elements
        }, function(data, menu)
            menu.close()
            if data.current.value then
                local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
                TriggerServerEvent('mechanic:accept',id,mugshotStr)
                ExecuteCommand('f Darkhast ' .. id .. ' accept shod!')
            else
                ExecuteCommand('f Darkhast ' .. id .. ' reject shod!')
            end
        end)
    Citizen.SetTimeout(10000,function()
        if ESX.UI.Menu.IsOpen('question',GetCurrentResourceName(),'a' .. id) then
            ESX.UI.Menu.Close('question',GetCurrentResourceName(), 'a' .. id)
            ExecuteCommand('f Darkhast ' .. id .. ' be dalil AFK reject shod!')
        end
    end)
end)

RegisterNetEvent('mechanic:acceptKarde',function()
    if not drawInD then
        drawInD = true
        reqid = 0
        Citizen.CreateThread(function()
            while drawInD do
                Citizen.Wait(0)
                ESX.ShowMissionText('~y~Request in progress('.. reqid ..')')
            end
        end)
        Citizen.CreateThread(function()
            while drawInD do
                local bedeBezanim = false
                ESX.TriggerServerCallback('mechanic:getlist', function(data)
                    ems = data
                    for k , v in ipairs(ems) do
                        if v.acceptersource and v.acceptersource == GetPlayerServerId(PlayerId()) then
                            bedeBezanim = true
                            reqid = v.source
                        end
                    end
                    if not bedeBezanim then
                        drawInD = false
                    end
                end)
                Citizen.Wait(10000)
            end
        end)
    end
end)

function mechanicCheckVehicleInsurance()
    ESX.selectVehicleMenu(function(vehicle)
        exports['sun-jobs']:checkVehicleInsurance(vehicle)
    end, 5)
end
-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local botThread, botPed, botBlip, botVehicle = false, nil, 0, 0
local function stopBot()
    ESX.Game.DeleteEntity(botPed)
    ESX.Game.DeleteEntity(botVehicle)
    botPed, botThread = nil, nil
end

RegisterNetEvent('mechanic:createBotThread', function()
    ESX.selectVehicleMenu(function(vehicle)
        if not vehicle then
            TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Hich mashini nazdik shoma nist!", 'job')
            return
        end
        if not botThread then
            botThread = true
            local spawnTime = GetGameTimer() + Shared.mechanic.config.mechanicBot.timer
            local task = nil
            CreateThread(function()
                while botThread do
                    if not DoesEntityExist(vehicle) then
                        stopBot()
                        break
                    end
                    -- if LocalPlayer.state.combat then
                    --     spawnTime = GetGameTimer() + Shared.ambulance.config.medicBot.timer
                    -- end
                    local timeMande = spawnTime - GetGameTimer()
                    if timeMande >= 0 then
                        ESX.Game.Utils.DrawText2D(('~g~%sS ta residan mechanic'):format(ESX.Math.Round(timeMande / 1000), 1), 0.5, 0.72, 0.4)
                    end
                    if timeMande <= 0 and not botPed then
                        ESX.TriggerServerEvent('suncore:whiteListPed')
                        local coords = GetEntityCoords(vehicle)
                        local model, car = Shared.mechanic.config.mechanicBot.models[math.random(1, #Shared.mechanic.config.mechanicBot.models)], Shared.mechanic.config.mechanicBot.cars[math.random(1, #Shared.mechanic.config.mechanicBot.cars)]
                        local found, spawnPos, spawnHeading = GetClosestVehicleNodeWithHeading(coords.x + math.random(-Shared.ambulance.config.medicBot.spawnRadius, Shared.ambulance.config.medicBot.spawnRadius), coords.y + math.random(-Shared.ambulance.config.medicBot.spawnRadius, Shared.ambulance.config.medicBot.spawnRadius), coords.z, 0, 3, 0)
                        if found then
                            local p = promise.new()
                            ESX.Game.SpawnVehicle(car, spawnPos, spawnHeading, function(vehicle)
                                p:resolve(vehicle)
                            end)
                            botVehicle = Citizen.Await(p)
                            TriggerServerEvent('esx_vehiclecontrol:sync', NetworkGetNetworkIdFromEntity(botVehicle), true)
                            ESX.Streaming.RequestModel('mp_m_famdd_01')
                            botPed = CreatePedInsideVehicle(botVehicle, 0, model, -1, true, true)
                            Wait(2000)
                            SetBlockingOfNonTemporaryEvents(botPed, true)
                            SetEntityInvincible(botPed, true)
                            botBlip = AddBlipForEntity(botPed)
                            SetBlipFlashes(botBlip, true)
                            SetBlipColour(botBlip, 5)
                        end
                    elseif botPed then
                        local coords = GetEntityCoords(vehicle)
                        local distance = #(coords - GetEntityCoords(botPed))
                        if distance > 10 then
                            if not task then
                                TaskVehicleDriveToCoord(botPed, botVehicle, coords.x, coords.y, coords.z, 30.0, 0, GetEntityModel(botVehicle), 524863, 5.0, 0)
                                task = true
                                SetTimeout(30000, function()
                                    local coords = GetEntityCoords(vehicle)
                                    if #(coords - GetEntityCoords(botVehicle)) > 10 then
                                        ESX.Game.DeleteEntity(botVehicle)
                                        SetEntityCoords(botPed, coords.x - 2.5, coords.y + 2.5, coords.z)
                                    end
                                end)
                            end
                        else
                            TaskLeaveVehicle(botPed, botVehicle, 0)
                            Wait(1000)
                            TaskGoToEntity(botPed, vehicle, -1, 1.0, 10, 0, 0)
                            Wait(7000)
                            ClearPedTasks(botPed)
                            Wait(1000)
                            ESX.entityFaceEntity(botPed, vehicle)
                            Wait(1000)
                            ESX.Streaming.RequestAnimDict('mini@repair')
                            TaskPlayAnim(botPed, 'mini@repair', 'fixing_a_ped', -1, -1, -1, 1, 1.0, false, false, false)
                            Wait(15000)
                            exports['esx_vehiclecontrol']:repair(vehicle)
                            ESX.TriggerServerEvent('mechanic:removeBotMoney')
                            ClearPedTasks(botPed)
                            Wait(1000)
                            if DoesEntityExist(botVehicle) then
                                TaskEnterVehicle(botPed, botVehicle, 15000, -1, 1.0, 1, 0)
                                Wait(10000)
                                TaskVehicleDriveWander(botPed, botVehicle, 100.0, 524863)
                                Wait(15000)
                            end
                            stopBot()
                        end
                    end
                    Wait(0)
                end
            end)
        end
    end, 8)
end)
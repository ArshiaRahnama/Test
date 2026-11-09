-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local botThread, botPed, botBlip = false, nil, 0
local function stopBot()
    ESX.Game.DeleteEntity(botPed)
    botPed, botThread = nil, nil
end

RegisterNetEvent('medic:createBotThread', function()
    if isInjure and not botThread then
        botThread = true
        local spawnTime = GetGameTimer() + Shared.ambulance.config.medicBot.timer
        local task = nil
        CreateThread(function()
            while botThread do
                if not isInjure then
                    stopBot()
                    break
                end
                if LocalPlayer.state.combat then
                    spawnTime = GetGameTimer() + Shared.ambulance.config.medicBot.timer
                end
                local timeMande = spawnTime - GetGameTimer()
                if timeMande >= 0 then
                    ESX.Game.Utils.DrawText2D(('~g~%sS ta residan medic'):format(ESX.Math.Round(timeMande / 1000), 1), 0.5, 0.72, 0.4)
                end
                if timeMande <= 0 and not botPed then
                    ESX.TriggerServerEvent('suncore:whiteListPed')
                    local coords = GetEntityCoords(PlayerPedId())
                    local model = Shared.ambulance.config.medicBot.models[math.random(1, #Shared.ambulance.config.medicBot.models)]
                    local found, spawnPos, spawnHeading = GetClosestVehicleNodeWithHeading(coords.x + math.random(-Shared.ambulance.config.medicBot.spawnRadius, Shared.ambulance.config.medicBot.spawnRadius), coords.y + math.random(-Shared.ambulance.config.medicBot.spawnRadius, Shared.ambulance.config.medicBot.spawnRadius), coords.z, 0, 3, 0)
                    if found then
                        botPed = ESX.Game.SpawnPed(model, spawnPos, 0)
                        Wait(2000)
                        SetBlockingOfNonTemporaryEvents(botPed, true)
                        SetEntityInvincible(botPed, true)
                        botBlip = AddBlipForEntity(botPed)
                        SetBlipFlashes(botBlip, true)
                        SetBlipColour(botBlip, 2)
                    end
                elseif botPed then
                    local coords = GetEntityCoords(PlayerPedId())
                    local distance = #(coords - GetEntityCoords(botPed))
                    if distance > 2 then
                        if not task then
                            TaskGoToEntity(botPed, PlayerPedId(), -1, 1.0, 10, 0, 0)
                            task = true
                            SetTimeout(30000, function()
                                local coords = GetEntityCoords(PlayerPedId())
                                if #(coords - GetEntityCoords(botPed)) > 2 then
                                    SetEntityCoords(botPed, coords.x, coords.y, coords.z)
                                end
                            end)
                        end
                    else
                        TriggerEvent('medic:syncAnim', botPed)
                        ESX.Streaming.RequestAnimDict(Shared.ambulance.config.anim.revive.sender.dict1)
							ESX.Streaming.RequestAnimDict(Shared.ambulance.config.anim.revive.sender.dict2, function()
                            Wait(500)
                            TaskPlayAnim(botPed, Shared.ambulance.config.anim.revive.sender.dict1, Shared.ambulance.config.anim.revive.sender.anim1, 8.0, 8.0, -1, 0, 0, false, false, false)
                            Wait(15800)
                            TaskPlayAnim(botPed, Shared.ambulance.config.anim.revive.sender.dict2, Shared.ambulance.config.anim.revive.sender.anim2, 8.0, 8.0, -1, 1, 0, false, false, false)
                            Wait(5000)
                            TaskPlayAnim(botPed, Shared.ambulance.config.anim.revive.sender.dict2, Shared.ambulance.config.anim.revive.sender.anim3, 8.0, 8.0, -1, 0, 0, false, false, false)
                            Wait(28600)
                            ClearPedTasks(botPed)
                            adrenalineThread()
                            stopBot()
                        end)
                    end
                end
                Wait(0)
            end
        end)
    end
end)
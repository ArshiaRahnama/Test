-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local currentPersuit = nil
local temp = {}
local textUI = 0
local nearType = 0
local cooldown = false
local vehiclesBlip = {}
local displaySecond = 0
local threadsRunning = false
local pursuitLock = false

local function clearTextUI(type)
    if textUI == type then
        textUI = 0
        lib.hideTextUI()
    end
end

local function safeCleanup()
    threadsRunning = false
    lib.hideTextUI()
    textUI = 0
    nearType = 0
    displaySecond = 0
    for k, v in pairs(temp.blips or {}) do
        RemoveBlip(v)
    end
    temp = {}
    currentPersuit = nil
    pursuitLock = false
end

RegisterNetEvent('persuit:start', function(data)
    if pursuitLock then return end
    pursuitLock = true
    
    currentPersuit = data
    ESX.chatMessage('Be maghsad pin shode beravid va eghdam be baz kardan dar mashin konid', 'plarms')
    SetNewWaypoint(data.coords.locations[1].xy)
    local tempBlip = AddBlipForCoord(data.coords.locations[1].xyz)
    SetBlipSprite(tempBlip, 1)
    SetBlipColour(tempBlip, 2)
    SetBlipScale(tempBlip, 1.0)
    SetBlipAsShortRange(tempBlip, true)
    SetBlipDisplay(tempBlip, 6)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Mashin persuit')
    EndTextCommandSetBlipName(tempBlip)
    SetBlipAsMissionCreatorBlip(tempBlip, true)
    SetBlipRoute(tempBlip, true)
    temp.blips = {}
    table.insert(temp.blips, tempBlip)
    threadsRunning = true
    
    CreateThread(function()
        displaySecond = persuitConfig.deadLine.hack / 1000
        CreateThread(function()
            while displaySecond > 0 and threadsRunning do
                displaySecond -= 1
                Wait(1000)
            end
        end)
        while currentPersuit and displaySecond > 0 and threadsRunning do
            ESX.Game.Utils.DrawText2D(('~r~%ss~w~ Vaght darid ta mashin ra serghat va be maghsad berasanid'):format(ESX.Math.Round(displaySecond)), 0.5, 0.8, 0.5)
            Wait(0)
        end
    end)
    
    CreateThread(function()
        while currentPersuit and currentPersuit.step and threadsRunning do
            Wait(1000)
            local pursuit = currentPersuit
            if not pursuit then break end
            
            nearType = 0
            if pursuit.step == 1 then
                local distance = #(SUN.PlayerCoords - pursuit.coords.locations[1].xyz)
                if distance < 100 then
                    if not temp.vehicle then
                        local blockedVehicle = ESX.Game.GetVehiclesInArea(pursuit.coords.locations[1].xyz, 5.0)
                        for k, v in pairs(blockedVehicle) do
                            ESX.Game.DeleteVehicle(v)
                        end
                        local p = promise.new()
                        local model = persuitConfig.cars[math.random(1, #persuitConfig.cars)]
                        ESX.Game.SpawnVehicle(model, pursuit.coords.locations[1].xyz - vec(0, 0, 1), pursuit.coords.locations[1].w, function(vehicle)
                            Wait(1000)
                            FreezeEntityPosition(vehicle, true)
                            temp.vehicle = NetworkGetNetworkIdFromEntity(vehicle)
                            temp.plate = ESX.GetPlate(vehicle)
                            p:resolve()
                        end)
                        Citizen.Await(p)
                        exports['sunset_utils']:lockVehicle(NetworkGetEntityFromNetworkId(temp.vehicle))
                        local netId = temp.vehicle
                        ESX.TriggerServerEvent('persuit:setVehicleNetId', netId)
                    else
                        if distance < 3 then
                            lib.showTextUI('[E] jahat lockpick mashin', {
                                position = 'left-center',
                                style = {
                                    borderRadius = 5,
                                    backgroundColor ='#7F00FF',
                                    color = 'white',
                                }
                            })
                            textUI = 1
                            nearType = 1
                        else
                            clearTextUI(1)
                        end
                    end
                else
                    clearTextUI(1)
                end
            else
                if pursuit.step == 2 then
                    local distance = #(SUN.PlayerCoords - pursuit.coords.locations[2].xyz)
                    if distance < 8 then
                        lib.showTextUI('[E] jahat tahvil mashin', {
                            position = 'left-center',
                            style = {
                                borderRadius = 5,
                                backgroundColor ='#7F00FF',
                                color = 'white',
                            }
                        })
                        textUI = 2
                        nearType = 2
                    else
                        clearTextUI(2)
                    end
                else
                    clearTextUI(2)
                end
                clearTextUI(1)
            end
        end
    end)
end)

AddEventHandler('KeyDown:e', function()
    local pursuit = currentPersuit
    if not pursuit then return end
    
    if nearType == 1 then
        nearType = 0
        if not cooldown then
            cooldown = true
            ESX.TriggerServerCallback('core:removeItem', function(removed)
                if removed then
                    exports['ps-ui']:Scrambler(function(success)
                        if success then
                            ESX.TriggerServerEvent('persuit:hackComplete')
                            local vehicle = NetworkGetEntityFromNetworkId(temp.vehicle)
                            ESX.forceGiveCarKey(vehicle)
                            exports['sunset_utils']:unlockVehicle(vehicle)
                            FreezeEntityPosition(vehicle, false)
                        end
                        cooldown = false
                    end, 'alphanumeric', 45, 0)
                else
                    cooldown = false
                    ESX.chatMessage(('Shoma be 1x %s niaz darid'):format(ESX.getItemLabel('raspberry')), 'plarms')
                end
            end, 'raspberry', 1)
            ESX.entityFaceEntity(SUN.ped, NetworkGetEntityFromNetworkId(temp.vehicle))
        end
    elseif nearType == 2 then
        if ESX.GetPlate(SUN.vehiclePlayerIsIn) == temp.plate then
            if not cooldown then
                cooldown = true
                if lib.progressCircle({
                    duration = persuitConfig.finishCastTime,
                    position = 'bottom',
                    useWhileDead = false,
                    canCancel = false,
                    allowRagdoll = true,
                    allowFalling = true,
                    disable = {
                        car = true,
                        move = true,
                        combat = true,
                    },
                }) then
                    ESX.TriggerServerCallback('persuit:finish', function(remove)
                        if remove then
                            ESX.Game.DeleteVehicle(NetworkGetEntityFromNetworkId(temp.vehicle))
                        end
                        cooldown = false
                    end)
                else
                    cooldown = false
                end
            end
        else
            ESX.chatMessage('Bayad savar mashin persuit bashid', 'plarms')
        end
    end
end)

RegisterNetEvent('persuit:update', function(step)
    if not currentPersuit then return end
    
    if step then
        currentPersuit.step = step
        if step == 2 then
            displaySecond = persuitConfig.deadLine.finish / 1000
            if temp.blips and temp.blips[1] then
                SetBlipCoords(temp.blips[1], currentPersuit.coords.locations[2].xyz)
                SetBlipRoute(temp.blips[1], true)
                SetNewWaypoint(currentPersuit.coords.locations[2].xy)
            end
        end
    end
end)

local function removeVehiclesBlip()
    for k, v in pairs(vehiclesBlip) do
        ESX.removeBlip(v)
    end
    vehiclesBlip = {}
end

RegisterNetEvent('persuit:updateVehiclesLocation', function(data)
    removeVehiclesBlip()
    for k, v in pairs(data) do
        table.insert(vehiclesBlip, ESX.AddBlipForCoord(v.coords, 1.0, 225, 1, v.id, 2, false))
    end
end)

RegisterNetEvent('esx:setJob', function()
    removeVehiclesBlip()
end)

RegisterNetEvent('persuit:finish', function()
    safeCleanup()
end)
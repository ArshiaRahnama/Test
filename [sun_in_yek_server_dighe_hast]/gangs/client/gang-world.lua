-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local worldCheckThread = false
local gangWorld = nil
local gangBlipPos = nil
local gangBlipRadius = nil
local gangEnterTimer = false
local SEC_TO_CW = 120
function stopWorldThread()
    worldCheckThread = false
    gangWorld = nil
    gangBlipPos = nil
    gangBlipRadius = nil
end

local function enterGangWorld()
    local vehicle = ESX.isVehicleDriver()
    if vehicle then
        local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
        exports['gangprop']:putaway(vehicle, vehicleProps)
        Wait(1000)
    end
    ESX.TriggerServerEvent('gangs:enterGangWorld')
end

function startWorldCheckThread()
    if not worldCheckThread then
        worldCheckThread = true
        CreateThread(function()
            while worldCheckThread do
                while not ESX or not ESX.PlayerData or not ESX.PlayerData.gang do
                    Wait(1000)
                end

                if ESX.PlayerData.gang.name == 'nogang' then
                    stopWorldThread()
                    break
                end

                if not gangBlipPos then
                    ESX.TriggerServerCallback('gangs:getGangWorldData', function(data)
                        if data then
                            gangBlipPos = vector3(data.pos.x, data.pos.y, data.pos.z)
                            gangBlipRadius = data.radius or 50.0
                            gangWorld = data.world
                        end
                    end)
                    Wait(2000)
                end

                if gangBlipPos and gangWorld then
                    local ped = PlayerPedId()
                    local coords = GetEntityCoords(ped)
                    local dist = #(coords - gangBlipPos)
                    local isOnFoot = not IsPedInAnyVehicle(ped, false)

                    if isOnFoot and dist <= gangBlipRadius and ESX.PlayerData.World == 0 and not ESX.isDead() then
                        if not gangEnterTimer then
                            gangEnterTimer = true
                            ESX.startCountdown(SEC_TO_CW,'Raftan be world gang - F4 baraye rad shodan timer', function()
                                enterGangWorld()
                            end, function()
                                return gangEnterTimer
                            end)
                        end
                    elseif dist > gangBlipRadius or ESX.isDead() then
                        if ESX.PlayerData.World == gangWorld then
                            local vehicle = ESX.isVehicleDriver()
                            if vehicle then
                                local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
                                exports['gangprop']:putaway(vehicle, vehicleProps)
                                Wait(1000)
                            end
                            ESX.TriggerServerEvent('gangs:leaveGangWorld')
                        end
                        gangEnterTimer = false
                    end

                    if not isOnFoot then
                        gangEnterTimer = false
                    end
                end

                Wait(1000)
            end
        end)
    end
end

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
	if not worldCheckThread and xPlayer.gang.name ~= 'nogang' then
        startWorldCheckThread()
    end
end)

RegisterNetEvent('esx:setGang', function(gang)
    stopWorldThread()
    if ESX.PlayerData.gang.name ~= 'nogang' then
        startWorldCheckThread()
    end
end)


RegisterNetEvent('esx:changeworld', function(_)
	ESX.PlayerData.World = _
    gangEnterTimer = false
end)

AddEventHandler('KeyDown:f4', function()
    if gangEnterTimer then
        enterGangWorld()
    end
end)

exports('isInGangWorld', function()
    return ESX.PlayerData.World == gangWorld
end)

exports('exitGangWorld', function()
    if ESX.PlayerData.World == gangWorld then
        local vehicle = ESX.isVehicleDriver()
        if vehicle then
            local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
            exports['gangprop']:putaway(vehicle, vehicleProps)
            Wait(1000)
        end
        ESX.TriggerServerEvent('gangs:leaveGangWorld')
    end
end)
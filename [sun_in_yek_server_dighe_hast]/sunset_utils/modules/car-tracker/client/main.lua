-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

RegisterNetEvent('carTracker:use', function()
    exports['sun-inventory-hud']:closeInventory()
    if ESX.PlayerData.job.name ~= 'mechanic' then
        return ESX.notification('error', 'Faghat mechanic mitavanad gps mashin ra nasb konad')
    end
    if not ESX.isVehicleDriver() then
        return ESX.notification('error', 'Savar mashini nistid')
    end
    if not exports['esx_vehiclecontrol']:isNearGarage() then
        return ESX.notification('error', 'Baraye anjam in kar bayad dar nazdiki garage bashid')
    end
    local vehicle = SUN.vehiclePlayerIsIn
    local plate = GetVehicleNumberPlateText(SUN.vehiclePlayerIsIn)
    ESX.TriggerServerCallback('carTracker:checkVehicle', function(have)
        if have then
            return ESX.notification('error', 'In mashin az ghabl gps darad')
        end
        if lib.progressCircle({
            duration = 10000,
            position = 'bottom',
            canCancel = true,
            disable = {
                car = true,
                move = true,
                combat = true,
            },
        }) then
            ESX.TriggerServerEvent('carTracker:installGps', plate, NetworkGetNetworkIdFromEntity(vehicle))
        end
    end, plate)
end)


CreateThread(function()
    waitForLoad()
    Wait(10000)
    local blips = {}
    local liveBlips = {}
    while true do
        Wait(carTrackerConfig.refreshRate)
        local p = promise.new()

        ESX.TriggerServerCallback('carTracker:getVehicles', function(vehicles)
            for k, v in pairs(blips) do
                ESX.removeBlip(v)
            end
            for k, v in pairs(liveBlips) do
                v.check = false
            end
            if ESX.tableLength(vehicles) > 0 then
                for plate, v in pairs(vehicles) do
                    local entity = NetworkGetEntityFromNetworkId(v.networkId)
                    if DoesEntityExist(entity) then
                        if liveBlips[plate] then
                            liveBlips[plate].check = true
                        else
                            liveBlips[plate] = {
                                check = true,
                                blip =  ESX.AddBlipForEntity(entity, 0.4, 42, 0, v.label .. ' ' .. plate, 4)
                            }
                        end
                    else
                        table.insert(blips, ESX.AddBlipForCoord(v.coords, 0.4, 42, 0, v.label .. ' ' .. plate, 4))
                    end
                end
            else
                Wait(30000)
            end
            for k, v in pairs(liveBlips) do
                if not v.check then
                    ESX.removeBlip(v.blip)
                    liveBlips[k] = nil
                end
            end
            p:resolve()
        end)
        Citizen.Await(p)
    end
end)

RegisterNetEvent('carTracker:removerUse', function()
    exports['sun-inventory-hud']:closeInventory()
    if not ESX.isVehicleDriver() then
        return ESX.notification('error', 'Savar mashini nistid')
    end
    local vehicle = SUN.vehiclePlayerIsIn
    local plate = GetVehicleNumberPlateText(SUN.vehiclePlayerIsIn)
    local inNCZ = exports['sunset_utils']:checkncz()
    if inNCZ then
        return ESX.notification('error', 'Nemitavanid dar in makan in kar ra anjam dahid')
    end
    ESX.TriggerServerCallback('carTracker:checkVehicle', function(have)
        if not have then
            return ESX.notification('error', 'In mashin gps nadarad')
        end
        local success = lib.skillCheck({'easy', 'easy', 'medium', 'easy'}, {'1', '2', '3'})
        inNCZ = exports['sunset_utils']:checkncz()
        if success and SUN.vehiclePlayerIsIn == vehicle and not inNCZ then
            ESX.TriggerServerEvent('carTracker:removeGPS', plate)
        end
    end, plate)
end)
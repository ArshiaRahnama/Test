-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local speedLimited = false

AddEventHandler('KeyDown:b',function()
    if not ESX.checkCooldown('speedlimit', 5000) then return end
    local playerPed = SUN.PlayerPedId
    local vehicle = SUN.vehiclePlayerIsIn
    if GetPedInVehicleSeat(vehicle, -1) == playerPed and IsPedInAnyVehicle(playerPed, false) then
        if speedLimited then
            speedLimited = false
            exports['esx_vehiclecontrol']:setVehicleTempSpeed('speedlimitb', nil)
            exports['ps-ui']:HideText()
        elseif not speedLimited then
            speedLimited = true
            local speed = GetEntitySpeed(vehicle)
            if speed * 3.6 > 2 then
                exports['esx_vehiclecontrol']:setVehicleTempSpeed('speedlimitb', speed)
                exports['ps-ui']:DisplayText(('Cruise : %sKM'):format(ESX.Math.Round(speed * 3.6)), 'info')
            end
        end
    end
end)

AddEventHandler('exitVehicle', function()
    if speedLimited then
        speedLimited = false
        exports['ps-ui']:HideText()
    end
end)

exports('doesSpeedLimited', function()
    return speedLimited
end)


local function GetFuelPercent(vehicle)
    local ok, fuel = pcall(function() return exports['LegacyFuel']:GetFuel(vehicle) end)
    if ok and fuel then
        return math.floor(fuel + 0.5)
    end
    return math.floor(GetVehicleFuelLevel(vehicle) + 0.5)
end

CreateThread(function()
    while true do
        local sleep = 500

        if currentVeh and currentVeh ~= 0 and DoesEntityExist(currentVeh) then
            sleep = 0

            local vehCoords = GetEntityCoords(currentVeh)
            local fuelPercent = GetFuelPercent(currentVeh)
            local engineHealth = GetVehicleEngineHealth(currentVeh)
            local engineOk = engineHealth > 0 and "Bale" or "Na"
            local bodyPercent = math.floor((GetVehicleBodyHealth(currentVeh) / 1000.0) * 100)
            if bodyPercent < 0 then bodyPercent = 0 end
            if bodyPercent > 100 then bodyPercent = 100 end

            local text = string.format("Benzin : %d%%~n~Engine : %s~n~Salamate motor : %d%%", fuelPercent, engineOk, bodyPercent)
            Draw3DText(vehCoords.x, vehCoords.y, vehCoords.z + 1.0, text)
        end

        Wait(sleep)
    end
end)

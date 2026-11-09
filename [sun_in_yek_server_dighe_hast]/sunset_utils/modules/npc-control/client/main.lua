-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

if GetConvarInt('serverNum') == 2 then
    local event
    CreateThread(function()
        waitForLoad()
        local density = 0.1
        for i = 1, 12 do
			BlockDispatchServiceResourceCreation(i, true)
		end
        SetCreateRandomCops(false)
        SetCreateRandomCopsNotOnScenarios(false)
        SetCreateRandomCopsOnScenarios(false)
        SetRandomTrains(false)
        SetGarbageTrucks(false)
        SetRandomBoats(false)
        while true do
            Wait(0)
            if SUN.World ~= 0 then
                density = 0.0
                local coords = SUN.PlayerCoords
                ClearAreaOfVehicles(SUN.PlayerCoords, 400.0, false, false, false, false, false)
		        RemoveVehiclesFromGeneratorsInArea(coords.x - 400.0, coords.y - 400.0, coords.z - 400.0, coords.x + 400.0, coords.y + 400.0, coords.z + 400.0)
                if not event then
                    event = AddEventHandler('populationPedCreating', function()
                        CancelEvent()
                    end)
                    print(event)
                end
            elseif event then
                RemoveEventHandler(event)
                event = nil
                density = 0.1
            end
            SetVehicleDensityMultiplierThisFrame(density)
            SetPedDensityMultiplierThisFrame(density)
            SetRandomVehicleDensityMultiplierThisFrame(density)
            SetParkedVehicleDensityMultiplierThisFrame(density)
            SetScenarioPedDensityMultiplierThisFrame(density, density)
            ClearAreaOfCops(SUN.PlayerCoords, 400.0)
            for k, v in pairs(GetGamePool('CPed')) do
                if not IsPedAPlayer(v) then
                    RemoveAllPedWeapons(v, false)
                end
            end
        end
    end)
end
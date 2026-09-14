local ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

function UpdateCollections()
    ESX.TriggerServerCallback('HUD_Menu:GetVehicles', function(vehicles)
        local resolved = {}
        for _, v in ipairs(vehicles) do
            local label = v.plate
            local slug = nil
            if v.model then
                local ok, hash = pcall(function() return type(v.model) == 'string' and GetHashKey(v.model) or v.model end)
                if ok and hash then
                    local displayName = GetDisplayNameFromVehicleModel(hash)
                    if displayName and displayName ~= 'CARNOTFOUND' then
                        slug = string.lower(displayName)
                    end
                    local text = GetLabelText(displayName)
                    if text and text ~= 'NULL' then
                        label = text
                    end
                end
            end
            table.insert(resolved, {
                plate = v.plate, name = label, slug = slug, stored = v.stored, fuel = v.fuel,
                color1 = v.color1, color2 = v.color2,
                modEngine = v.modEngine, modBrakes = v.modBrakes, modTransmission = v.modTransmission,
                modSuspension = v.modSuspension, modArmor = v.modArmor, modTurbo = v.modTurbo,
                windowTint = v.windowTint,
            })
        end
        SendNUIMessage({ type = "loadVehicles", vehicles = resolved })
    end)

    ESX.TriggerServerCallback('HUD_Menu:GetHouses', function(houses)
        SendNUIMessage({ type = "loadHouses", houses = houses })
    end)
end

RegisterNUICallback('setWaypoint', function(data, cb)
    if data.x and data.y then
        SetNewWaypoint(data.x + 0.0, data.y + 0.0)
        TriggerEvent('esx:showNotification', 'GPS set to ' .. (data.label or 'property'))
    end
    cb('ok')
end)

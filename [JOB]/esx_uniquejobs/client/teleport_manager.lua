-- Replaces: client/teleport_police.lua, client/teleport_ambulance.lua,
-- client/teleport_mechanic.lua, client/teleport_taxi.lua, client/teleport_weazel.lua
-- One config-driven loop instead of 5 near-identical copy/pasted files.
-- Access logic still keys off shared/departments.lua (DojJobSet/LeJobSet/
-- GovernmentJobSet), same as before, just read through ConfigTeleport.Teleports[i].department.

local currentJob = nil

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(10)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    currentJob = ESX.GetPlayerData().job.name

    RegisterNetEvent('esx:setJob')
    AddEventHandler('esx:setJob', function(job)
        currentJob = job.name
    end)

    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local isInVehicle = IsPedInAnyVehicle(playerPed, false)

        for _, teleport in pairs(ConfigTeleport.Teleports) do
            if TeleportHasAccess(teleport) then
                for _, position in pairs(teleport.positions) do
                    if Vdist(playerCoords, position.coords.x, position.coords.y, position.coords.z) < 100.0 then
                        if (teleport.vehicle and isInVehicle) or (not teleport.vehicle and not isInVehicle) then
                            DrawMarker(TeleportMarkerCode, position.coords.x, position.coords.y, position.coords.z - 0.0, 0, 0, 0, 0, 0, 0, teleport.scale.p1, teleport.scale.p2, teleport.scale.p3, teleport.color.r, teleport.color.g, teleport.color.b, 100, false, true, 2, false, nil, nil, false)
                            if Vdist(playerCoords, position.coords.x, position.coords.y, position.coords.z) < 2.0 then
                                ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ To Open Teleport Menu")
                                if IsControlJustReleased(0, 38) then
                                    OpenTeleportMenu(teleport, position.coords)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

function TeleportHasAccess(teleport)
    -- own job is always allowed
    if teleport.job and teleport.job == currentJob then
        return true
    end

    -- department shortcut, resolved live against shared/departments.lua so it
    -- can never drift out of sync with Departments{} the way 5 separate
    -- hardcoded job lists could
    if teleport.department == 'doj' and IsDojJob(currentJob) then
        return true
    elseif teleport.department == 'le' and IsLeJob(currentJob) then
        return true
    elseif teleport.department == 'government' and IsGovernmentJob(currentJob) then
        return true
    end

    return false
end

function OpenTeleportMenu(teleport, currentCoords)
    if not TeleportHasAccess(teleport) then
        ESX.ShowNotification("Shoma Dastrasi Az Estefade az in Teleporter ra Nadarid", 'error')
        return
    end

    local elements = {}

    for _, position in pairs(teleport.positions) do
        if Vdist(currentCoords.x, currentCoords.y, currentCoords.z, position.coords.x, position.coords.y, position.coords.z) > 2.0 then
            table.insert(elements, { label = position.label, value = position.coords })
        end
    end

    if #elements == 0 then
        ESX.ShowNotification("Accsess Nadari !", 'warning')
        return
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'teleport_menu', {
        title = teleport.menuTitle or "Teleport Location",
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        menu.close()
        TeleportPlayer(data.current.value)
    end, function(data, menu)
        menu.close()
    end)
end

function TeleportPlayer(coords)
    local playerPed = PlayerPedId()
    local isInVehicle = IsPedInAnyVehicle(playerPed, false)
    local entity = playerPed

    if isInVehicle then
        entity = GetVehiclePedIsIn(playerPed, false)
    end

    -- keeps existing anti-cheat compatibility (speed/teleport exempt window)
    TriggerServerEvent('esx_uniquejobs:AntiCheatExempt', 5000, { teleport = true, speed = true })

    DoScreenFadeOut(500)
    Citizen.Wait(900)
    SetEntityCoords(entity, coords.x, coords.y, coords.z)
    Citizen.Wait(700)
    DoScreenFadeIn(1000)
end



local markerCoords1 = vector3(-585.961, -934.131, 23.815)
local markerCoords2 = vector3(-598.481, -930.876, 23.860)
local markerCoords3 = vector3(129.4453, -800.5595, 30.28)
local markerCoords4 = vector3(1735.931, 3641.736, 35.640)

local function isPlayerAllowedWeazel()
    local playerData = ESX.GetPlayerData()
    if playerData and playerData.job then
        return playerData.job.name == 'weazel' or playerData.job.name == 'cid' or playerData.job.name == 'cia' or playerData.job.name == 'marshal' or playerData.job.name == 'fbi' or playerData.job.name == 'judge' or playerData.job.name == 'doa'
    end
    return false
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        if isPlayerAllowedWeazel() then

            if #(playerCoords - markerCoords1) < 10.0 then
                DrawMarker(6, markerCoords1.x, markerCoords1.y, markerCoords1.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.7, 0, 255, 0, 100, false, true, 2, nil, nil, false)

                if #(playerCoords - markerCoords1) < 1.5 then
                    ESX.ShowHelpNotification("~INPUT_CONTEXT~ Brai Teleport")

                    if IsControlJustReleased(0, 38) then
                        OpenTeleportMenuWeazel("1")
                    end
                end
            end


            if #(playerCoords - markerCoords2) < 10.0 then
                DrawMarker(6, markerCoords2.x, markerCoords2.y, markerCoords2.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.7, 0, 255, 0, 100, false, true, 2, nil, nil, false)

                if #(playerCoords - markerCoords2) < 1.5 then
                    ESX.ShowHelpNotification("~INPUT_CONTEXT~ Brai Teleport")

                    if IsControlJustReleased(0, 38) then
                        OpenTeleportMenuWeazel("2")
                    end
                end
            end


            if #(playerCoords - markerCoords3) < 10.0 then
                DrawMarker(6, markerCoords3.x, markerCoords3.y, markerCoords3.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.7, 0, 255, 0, 100, false, true, 2, nil, nil, false)

                if #(playerCoords - markerCoords3) < 1.5 then
                    ESX.ShowHelpNotification("~INPUT_CONTEXT~ Brai Teleport")

                    if IsControlJustReleased(0, 38) then
                        OpenTeleportMenuWeazel("3")
                    end
                end
            end


            if #(playerCoords - markerCoords4) < 10.0 then
                DrawMarker(6, markerCoords4.x, markerCoords4.y, markerCoords4.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.7, 0, 255, 0, 100, false, true, 2, nil, nil, false)

                if #(playerCoords - markerCoords4) < 1.5 then
                    ESX.ShowHelpNotification("~INPUT_CONTEXT~ Brai Teleport")

                    if IsControlJustReleased(0, 38) then
                        OpenTeleportMenuWeazel("4")
                    end
                end
            end
        end
    end
end)

function OpenTeleportMenuWeazel(currentLocation)
    if not isPlayerAllowedWeazel() then
        ESX.ShowNotification("Shoma Dastrasi Az Estefade az in Teleporter ra Nadarid")
        return
    end

    local elements = {}

    if currentLocation ~= "2" then
        table.insert(elements, {label = "Station 2", value = "to2"})
    end
    if currentLocation ~= "3" then
        table.insert(elements, {label = "Station 3", value = "to3"})
    end
    if currentLocation ~= "4" then
        table.insert(elements, {label = "Administatior", value = "to4"})
    end
    if currentLocation ~= "1" then
        table.insert(elements, {label = "Station 1", value = "to1"})
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'teleport_menu_weazel', {
        title    = "WZ Teleporter",
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        menu.close()

        TriggerEvent('mythic_progbar:client:progress', {
            name = "teleport_progress",
            duration = 5000,
            label = "",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },
            animation = {
                animDict = "mp_common",
                anim = " ",
            },
        }, function(status)
            if not status then
                if data.current.value == "to2" then
                    TriggerServerEvent('esx_uniquejobs:AntiCheatExempt', 5000, { teleport = true, speed = true })
                    SetEntityCoords(PlayerPedId(), markerCoords2.x, markerCoords2.y, markerCoords2.z, false, false, false, true)
                elseif data.current.value == "to1" then
                    TriggerServerEvent('esx_uniquejobs:AntiCheatExempt', 5000, { teleport = true, speed = true })
                    SetEntityCoords(PlayerPedId(), markerCoords1.x, markerCoords1.y, markerCoords1.z, false, false, false, true)
                elseif data.current.value == "to3" then
                    TriggerServerEvent('esx_uniquejobs:AntiCheatExempt', 5000, { teleport = true, speed = true })
                    SetEntityCoords(PlayerPedId(), markerCoords3.x, markerCoords3.y, markerCoords3.z, false, false, false, true)
                elseif data.current.value == "to4" then
                    TriggerServerEvent('esx_uniquejobs:AntiCheatExempt', 5000, { teleport = true, speed = true })
                    SetEntityCoords(PlayerPedId(), markerCoords4.x, markerCoords4.y, markerCoords4.z, false, false, false, true)
                end
            end
        end)
    end, function(data, menu)
        menu.close()
    end)
end

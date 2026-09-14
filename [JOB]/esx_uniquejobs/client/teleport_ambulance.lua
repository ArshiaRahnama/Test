ESX = nil

local markerCoordsA = vector3(-801.547, -1251.81, 7.3374)
local markerCoordsB = vector3(1835.664, 3671.769, 34.276)
local markerCoordsC = vector3(-256.404, 6334.413, 32.427)
local markerCoordsD = vector3(1736.338, 3641.375, 35.640)

local function isPlayerAllowed()
    local playerData = ESX.GetPlayerData()
    if playerData and playerData.job then
        return playerData.job.name == 'ambulance' or playerData.job.name == 'cid' or playerData.job.name == 'cia' or playerData.job.name == 'marshal' or playerData.job.name == 'fbi' or playerData.job.name == 'judge' or playerData.job.name == 'doa'
    end
    return false
end

local PlayerData = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job ~= nil do
        Wait(10)
    end

    PlayerData = ESX.GetPlayerData()

end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        if isPlayerAllowed() then

            if #(playerCoords - markerCoordsA) < 10.0 then
                DrawMarker(6, markerCoordsA.x, markerCoordsA.y, markerCoordsA.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.7, 0, 255, 0, 100, false, true, 2, nil, nil, false)

                if #(playerCoords - markerCoordsA) < 1.5 then
                    ESX.ShowHelpNotification("~INPUT_CONTEXT~ Brai Teleport")

                    if IsControlJustReleased(0, 38) then
                        OpenTeleportMenu("A")
                    end
                end
            end

            if #(playerCoords - markerCoordsB) < 10.0 then
                DrawMarker(6, markerCoordsB.x, markerCoordsB.y, markerCoordsB.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.7, 0, 255, 0, 100, false, true, 2, nil, nil, false)

                if #(playerCoords - markerCoordsB) < 1.5 then
                    ESX.ShowHelpNotification("~INPUT_CONTEXT~ Brai Teleport")

                    if IsControlJustReleased(0, 38) then
                        OpenTeleportMenu("B")
                    end
                end
            end

            if #(playerCoords - markerCoordsC) < 10.0 then
                DrawMarker(6, markerCoordsC.x, markerCoordsC.y, markerCoordsC.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.7, 0, 255, 0, 100, false, true, 2, nil, nil, false)

                if #(playerCoords - markerCoordsC) < 1.5 then
                    ESX.ShowHelpNotification("~INPUT_CONTEXT~ Brai Teleport")

                    if IsControlJustReleased(0, 38) then
                        OpenTeleportMenu("C")
                    end
                end
            end

            if #(playerCoords - markerCoordsD) < 10.0 then
                DrawMarker(6, markerCoordsD.x, markerCoordsD.y, markerCoordsD.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.7, 0, 255, 0, 100, false, true, 2, nil, nil, false)

                if #(playerCoords - markerCoordsD) < 1.5 then
                    ESX.ShowHelpNotification("~INPUT_CONTEXT~ Brai Teleport")

                    if IsControlJustReleased(0, 38) then
                        OpenTeleportMenu("D")
                    end
                end
            end
        end
    end
end)

function OpenTeleportMenu(currentLocation)
    if not isPlayerAllowed() then
        ESX.ShowNotification("Shoma Dastrasi Az Estefade az in Teleporter ra Nadarid")
        return
    end

    local elements = {}

    if currentLocation ~= "B" then
        table.insert(elements, {label = "Station 2 Sandy", value = "toB"})
    end
    if currentLocation ~= "C" then
        table.insert(elements, {label = "Station 3 Paleto", value = "toC"})
    end



    if currentLocation ~= "A" then
        table.insert(elements, {label = "Station 1 Shar", value = "toA"})
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'teleport_menu', {
        title    = "MD Teleporter",
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

                if data.current.value == "toB" then
                    TriggerServerEvent('esx_uniquejobs:AntiCheatExempt', 5000, { teleport = true, speed = true })
                    SetEntityCoords(PlayerPedId(), markerCoordsB.x, markerCoordsB.y, markerCoordsB.z, false, false, false, true)
                elseif data.current.value == "toA" then
                    TriggerServerEvent('esx_uniquejobs:AntiCheatExempt', 5000, { teleport = true, speed = true })
                    SetEntityCoords(PlayerPedId(), markerCoordsA.x, markerCoordsA.y, markerCoordsA.z, false, false, false, true)
                elseif data.current.value == "toC" then
                    TriggerServerEvent('esx_uniquejobs:AntiCheatExempt', 5000, { teleport = true, speed = true })
                    SetEntityCoords(PlayerPedId(), markerCoordsC.x, markerCoordsC.y, markerCoordsC.z, false, false, false, true)
                elseif data.current.value == "toD" then
                    TriggerServerEvent('esx_uniquejobs:AntiCheatExempt', 5000, { teleport = true, speed = true })
                    SetEntityCoords(PlayerPedId(), markerCoordsD.x, markerCoordsD.y, markerCoordsD.z, false, false, false, true)
                end
            end
        end)
    end, function(data, menu)
        menu.close()
    end)
end


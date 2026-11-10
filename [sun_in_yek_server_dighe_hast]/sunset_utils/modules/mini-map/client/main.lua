-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local havePhone = false
Citizen.CreateThread(function()
    StartAudioScene("CHARACTER_CHANGE_IN_SKY_SCENE")
    for i = 1, 15 do
        EnableDispatchService(i, false)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    TriggerEvent('minimap:removeGPS')
    for i=1, #PlayerData.inventory, 1 do
        if PlayerData.inventory[i].name == 'phone' then
            if PlayerData.inventory[i].count > 0 then
                TriggerEvent('minimap:addGPS')
                havePhone = true
            end
        end
    end
end)

RegisterNetEvent('esx:addInventoryItem',function(label, count, name)
    if name == 'phone' and count > 0 then
        TriggerEvent('minimap:addGPS')
        havePhone = true
    end
end)

RegisterNetEvent('esx:removeInventoryItemss',function(label, count, name, newCount)
    if name == 'phone' and newCount <= 0 then
        TriggerEvent('minimap:removeGPS')
        havePhone = false
    end
end)

RegisterNetEvent('minimap:addGPS')
AddEventHandler('minimap:addGPS', function()
    DisplayRadar(true)
end)

RegisterNetEvent('minimap:removeGPS')
AddEventHandler('minimap:removeGPS', function()
    DisplayRadar(false)
end)

AddEventHandler('core:updateHud', function(state)
    DisplayRadar(state and havePhone)
end)

local coordsVisible = false

function DrawGenericText(text)
    SetTextColour(186, 186, 186, 255)
    SetTextFont(7)
    SetTextScale(0.378, 0.378)
    SetTextWrap(0.0, 1.0)
    SetTextCentre(false)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 205)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(0.40, 0.00)
end

FormatCoord = function(coord)
    if coord == nil then
        return "unknown"
    end

    return tonumber(string.format("%.2f", coord))
end

ToggleCoords = function()
    coordsVisible = not coordsVisible

    --
    Citizen.CreateThread(function()
        while coordsVisible do
            local sleepThread = 250

            sleepThread = 5

            local playerPed = PlayerPedId()
            local playerX, playerY, playerZ = table.unpack(GetEntityCoords(playerPed))
            local playerH = GetEntityHeading(playerPed)

            DrawGenericText(("~g~X~w~: %s ~g~Y~w~: %s ~g~Z~w~: %s ~g~H~w~: %s"):format(FormatCoord(playerX), FormatCoord(playerY), FormatCoord(playerZ), FormatCoord(playerH)))

            Citizen.Wait(sleepThread)
        end
    end)
end

RegisterCommand("coords", function()
    ToggleCoords()
end)


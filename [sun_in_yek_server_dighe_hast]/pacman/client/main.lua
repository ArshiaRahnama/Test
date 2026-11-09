-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local ClosestDistance = 20.0
ESX = exports['essentialmode']:getObject()

local arcadeBusy = false
local function StartArcade(fromPhone)
    if arcadeBusy then return end
    arcadeBusy = true
    Citizen.SetTimeout(10000, function()
        arcadeBusy = false
    end)
    ESX.TriggerServerCallback('pacman:payToUse', function(success)
        if success then
            ESX.ShowAdvancedNotification('Pacman', 'Pacman', 'Shoma mablagh ~g~'..ConfigPacman.Price..'$ ~s~pardakht kardid', 'CHAR_BLANK_ENTRY', 9)
            Citizen.Wait(1000)
            StartGame()
        else
            ESX.ShowNotification('Shoma poul kafi nadarid!')
        end
        arcadeBusy = false
    end)
end
exports('StartArcade', StartArcade)

RegisterNetEvent('pacman:client:startArcade')
AddEventHandler('pacman:client:startArcade', function()
    StartArcade(true)
end)

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(1000)
    end
    SetNuiFocus(false, false)
    exports['ox_target']:addModel(ConfigPacman.ArcadeProps, {
        {
            label = "⍩⃝ شروع پک من",
            onSelect = function(entity)
                StartArcade()
            end,
        },
    })
end)

RegisterNUICallback("close", function(data, cb)
    EndGame()
end)

RegisterNUICallback("getscore", function(data, cb)
    ESX.TriggerServerEvent('pacman:PacmanNewScore', data)

    ESX.TriggerServerCallback('pacman:requestPacmanLeaderBoard', function(score)
        SendNUIMessage({
            scoreboard = score
        })
    end)
end)

RegisterNUICallback("win", function(data, cb)
    ESX.TriggerServerEvent('pacman:winLevel', data)
end)

function StartGame()
    ESX.TriggerServerCallback('pacman:requestPacmanLeaderBoard', function(score)
        SendNUIMessage({
            type = "ui",
            display = true,
            scoreboard = score
        })
        SetNuiFocus(true, true)
    end)
end

function EndGame()
    SendNUIMessage({
        type = "ui",
        display = false
    })
    SetNuiFocus(false, false)
end


-- Citizen.CreateThread(function()
--     while true do
--         local playerPed = PlayerPedId()
--         local playerCoords = GetEntityCoords(playerPed)
--         local arcadeCoords = nil
--         local closestDistance = nil

--         for _, arcadeProp in pairs(ConfigPacman.ArcadeProps) do
--             local arcade = GetClosestObjectOfType(playerCoords, 20.0, arcadeProp, false)
--             if DoesEntityExist(arcade) then
--                 arcadeCoords = GetEntityCoords(arcade)
--                 local distance = #(playerCoords - arcadeCoords)
--                 if not closestDistance or distance <= closestDistance then
--                     closestDistance = distance
--                 end
--             end
--         end
--         ClosestDistance = closestDistance
--         Citizen.Wait(2000)
--     end
-- end)

-- local CD = false
-- Citizen.CreateThread(function()
--     while true do
--         if ESX and ClosestDistance and ClosestDistance <= 1.5 then
--             ESX.ShowHelpNotification('Dokme ~INPUT_PICKUP~ jahat shorue ~y~Pacman ~s~(~g~'..ConfigPacman.Price..'$~s~)')
--             if IsControlJustPressed(1, 38) then
--                 if not CD then
--                     CD = true
--                     Citizen.SetTimeout(5000,function()
--                         CD = false
--                     end)
--                     ESX.TriggerServerCallback('pacman:payToUse', function(success)
--                         if success then
--                             ESX.ShowAdvancedNotification('Pacman', 'Pacman', 'Shoma mablagh ~g~'..ConfigPacman.Price..'$ ~s~pardakht kardid', 'CHAR_BLANK_ENTRY', 9)
--                             Citizen.Wait(1000)
--                             StartGame()
--                         else
--                             ESX.ShowNotification('Shoma poul kafi nadarid!')
--                         end
--                     end)
--                 end
--             end
--         end
--         Citizen.Wait(ClosestDistance and 0 or 1000)
--     end
-- end)


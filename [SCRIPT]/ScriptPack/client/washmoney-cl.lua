ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local isWashing = false

local function playWashAnim(ped)
    local animDict = "mini@repair"
    local animName = "fixing_a_ped"

    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(100)
    end

    TaskPlayAnim(ped, animDict, animName, 8.0, 8.0, -1, 1, 0, false, false, false)
end

-- Server tells us when a process is actually accepted; we never start locally on our own say-so
RegisterNetEvent('unique_washmoney:beginProcess')
AddEventHandler('unique_washmoney:beginProcess', function(locationName, duration)
    local playerPed = PlayerPedId()
    isWashing = true
    playWashAnim(playerPed)

    TriggerEvent("mythic_progbar:client:progress", {
        name = "WashMoney",
        duration = duration,
        label = "Dar Hale Shost o Shoo !",
        useWhileDead = false,
        canCancel = false,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
    }, function(cancelled)
        if isWashing then
            if cancelled then
                TriggerServerEvent('unique_washmoney:cancelProcess')
            else
                TriggerServerEvent('unique_washmoney:finishProcess')
            end
        end
        isWashing = false
    end)

    Citizen.CreateThread(function()
        while isWashing do
            Citizen.Wait(0)
            if IsControlJustReleased(0, 73) then -- X
                ClearPedTasks(playerPed)
                isWashing = false
                TriggerEvent('mythic_progbar:client:cancel')
                TriggerServerEvent('unique_washmoney:cancelProcess')
                ESX.ShowNotification("Shoma Pool Shoyi Ro Cancel Kardid !")
                break
            end
        end
    end)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for i, loc in pairs(ConfigWashMoney.Locations) do
            local distance = #(playerCoords - loc.Pos)

            if distance < loc.ViewDistance and not isWashing then
                DrawMarker(6, loc.Pos.x, loc.Pos.y, loc.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.6, 0.6, 0.6, 255, 0, 255, 80, false, true, 2, false, false, false, false)

                if distance < 1.5 then
                    ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ To Wash Money")

                    if IsControlJustReleased(0, 38) then -- E
                        -- Only the location index is sent; server decides the amount/odds itself
                        TriggerServerEvent('unique_washmoney:startProcess', i)
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('unique_washmoney:setBlip')
AddEventHandler('unique_washmoney:setBlip', function(position)
    local blip = AddBlipForCoord(position.x, position.y, position.z)

    SetBlipSprite(blip, 161)
    SetBlipScale(blip, 1.5)
    SetBlipColour(blip, 30)
    PulseBlip(blip)

    Citizen.SetTimeout(60000, function()
        RemoveBlip(blip)
    end)
end)

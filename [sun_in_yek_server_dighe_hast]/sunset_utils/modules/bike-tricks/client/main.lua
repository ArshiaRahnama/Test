-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local lastAnimId = 1

local function PlayTrick(dict, anim, flag, flag2, vehicle, duration)
    ESX.Streaming.RequestAnimDict(dict)
    local pPed = PlayerPedId()
    local animId = math.random(1, 500)
    lastAnimId = animId
    if anim == 'free_back' then
        if not IsEntityInAir(vehicle) then return end
        TaskPlayAnim(pPed, dict, anim, 8.0, -8.0, -1, flag, 0.0, false, flag2, false)
        while true do
            Wait(50)
            if GetEntityHeightAboveGround(vehicle) < bikeTrickConfig.groundHeight or not IsPedInAnyVehicle(pPed) then
                ClearPedSecondaryTask(pPed)
                break
            end
        end
    else
        TaskPlayAnim(pPed, dict, anim, 8.0, -8.0, -1, flag, 0.0, false, flag2, false)
        Wait(duration)
        if IsEntityPlayingAnim(pPed, dict, anim, 3) and animId == lastAnimId then
            ClearPedSecondaryTask(pPed)
        end
    end
end

CreateThread(function()
    for index, trick in pairs(bikeTrickConfig.tricks) do
        RegisterCommand('btrick' .. index, function()
            if not ESX.isPrime() then return end
            local vehicle = GetVehiclePedIsUsing(PlayerPedId())
            local vehicleModel = GetEntityModel(vehicle)
            if bikeTrickConfig.allowedVehicles[vehicleModel] and (GetEntitySpeed(vehicle) * 3.6) > bikeTrickConfig.minimumSpeed then 
                PlayTrick(trick.dict, trick.anim, trick.flag, trick.flag2, vehicle, trick.duration)
            end
        end)
        RegisterKeyMapping('btrick' .. index, trick.label, 'keyboard', '')
    end
end)


RegisterCommand('btrickStand', function()
    local pPed = PlayerPedId()
    local dict = 'veh@bike@dirt@front@base'
    if not ESX.isPrime() then return end
    if IsEntityPlayingAnim(pPed, 'veh@bike@dirt@front@base', 'sit_high', 3) then
        ClearPedSecondaryTask(pPed)
        return
    end
    
    local vehicle = GetVehiclePedIsUsing(pPed)
    local vehicleModel = GetEntityModel(vehicle)
    if bikeTrickConfig.allowedVehicles[vehicleModel] then
        ESX.Streaming.RequestAnimDict(dict)
        TaskPlayAnim(pPed, 'veh@bike@dirt@front@base', 'sit_high', 8.0, -8.0, -1, 35, 0.0, false, 0, false)
    end
end)

RegisterKeyMapping('btrickStand', 'Bike Trick: Stand', 'keyboard', '')

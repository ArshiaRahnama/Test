-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local stress, stressLoaded, timers, checkData, timeCycleChange, timeCycleChangeLastCheck = 0, false, {}, {}, false, false
CreateThread(function()
    waitForLoad()
    ESX.TriggerServerCallback('stress:getData', function(_stress)
        stress = _stress
        stressLoaded = true
        TriggerEvent('stress:update', stress)
    end)
end)

function addStress(value)
    while not stressLoaded do Wait(100) end
    local removePercent = 10
    if doesSkillCompleted('sport_skill') then
        removePercent += 50
    end
    if doesSkillCompleted('police_skill') then
        removePercent += 10
    end
    if doesSkillCompleted('sheriff_skill') then
        removePercent += 10
    end
    if doesSkillCompleted('mt_skill') then
        removePercent += 10
    end
    if doesSkillCompleted('detective_skill') then
        removePercent += 10
    end
    if stressConfig.add[value] then
        value = stressConfig.add[value]
        value -= (value / 100) * removePercent
        stress += value
        if stress > 100 then stress = 100 end
    end
    TriggerEvent('stress:update', stress)
end
exports('addStress', addStress)

function removeStress(value)
    while not stressLoaded do Wait(100) end
    if stressConfig.remove[value] then
        stress -= stressConfig.remove[value]
    end
    if stress < 0 then
        stress = 0
    end
    TriggerEvent('stress:update', stress)
end
exports('removeStress', removeStress)

function getStress()
    while not stressLoaded do Wait(100) end
    return stress
end

exports('getStress', getStress)

CreateThread(function()
    waitForLoad()
    while true do
        Wait(10)
        local gameTime = GetGameTimer()
        if IsPedShooting(SUN.ped) and (not timers.shooting or timers.shooting < gameTime) then
            timers.shooting = gameTime + 100
            addStress('shooting_gun')
        end
        if SUN.isPlayerInVehicle then
            if checkData.vehicleEngineHealth then
                local health = GetVehicleEngineHealth(SUN.vehiclePlayerIsIn)
                if checkData.vehicleEngineHealth - health > 30 then
                    addStress('crash_car')
                end
                checkData.vehicleEngineHealth = health
            else
                checkData.vehicleEngineHealth = GetVehicleEngineHealth(SUN.vehiclePlayerIsIn)
            end
        else
            checkData.vehicleEngineHealth = 0
        end
        if not SUN.admin then
            if stress > 90 then
                timeCycleChange = true
                if not timeCycleChangeLastCheck then
                    timeCycleChangeLastCheck = true
                    SetTimeout(5000, function()
                        timeCycleChangeLastCheck = false
                    end)
                    TriggerEvent('core:applyScreenEffect', 'REDMIST', 0.3 + (stress / 1000), 10)
                end
            elseif timeCycleChange then
                timeCycleChange = false
                timeCycleChangeLastCheck = false
                TriggerEvent('core:applyScreenEffect', 'REDMIST', 0, 10)
                -- ClearTimecycleModifier()
            end
        end
    end
end)

AddEventHandler('KeyDown:space', function()
    if IsPedJumping(SUN.ped) then
        addStress('player_jump')
    end
end)

RegisterNetEvent('stress:add', function(k)
    addStress(k)
end)

RegisterNetEvent('stress:remove', function(k)
    removeStress(k)
end)
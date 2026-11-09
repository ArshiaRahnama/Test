-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local abrisham = {
    vector3(1198.49,491.5,81.54),
    vector3(1269.18,561.26,80.57),
    vector3(1340.36,630.58,80.34),
    vector3(1408.48,703.17,78.52),
    vector3(1467.37,783.16,77.05),
    vector3(1519.25,868.13,77.18),
    vector3(1562.78,957.39,78.17),
    vector3(1598.61,1049.97,80.12),
    vector3(1629.57,1144.0,83.33),
    vector3(1655.71,1239.73,85.05),
    vector3(1688.14,1333.61,87.15),
    vector3(1710.44,1430.91,85.58),
    vector3(1725.48,1529.55,84.66),
    vector3(1739.34,1628.16,83.86),
    vector3(1752.84,1726.63,82.22),
    vector3(1768.84,1825.07,78.08),
    vector3(1788.88,1921.56,71.91),
    vector3(1805.63,2019.2,64.96),
    vector3(1826.78,2116.09,58.46),
    vector3(1836.25,2214.99,55.0),
    vector3(1862.0,2310.9,53.58),
    vector3(1898.66,2403.13,53.87),
    vector3(1942.48,2492.28,54.66),
    vector3(2004.15,2570.39,54.6),
    vector3(2077.04,2637.69,52.15),
    vector3(2151.88,2703.05,48.68),
    vector3(2228.04,2766.13,44.88),
    vector3(2306.23,2827.4,41.61),
    vector3(2384.06,2889.38,40.36),
    vector3(2459.25,2954.25,40.67),
    vector3(2536.11,3017.2,42.52),
    vector3(2606.52,3087.11,46.92),
    vector3(2671.42,3162.46,51.78),
    vector3(2721.89,3248.08,54.98),
    vector3(2768.47,3335.78,56.05),
    vector3(2802.28,3429.27,55.46),
    vector3(2842.65,3520.38,54.06),
    vector3(2876.41,3613.74,52.56),
    vector3(2900.97,3709.31,44.02),
    vector3(2924.25,3806.16,52.52),
    vector3(2927.8,3905.39,51.94),
    vector3(2917.21,4004.55,51.22),
    vector3(2891.63,4100.44,50.4),
    vector3(2862.74,4195.87,50.44),
    vector3(2831.2,4290.66,50.04),
    vector3(2798.76,4385.04,49.61),
    vector3(2770.4,4480.43,47.79),
    vector3(2746.39,4577.13,45.73),
    vector3(2726.32,4675.12,44.53),
    vector3(2704.54,4772.82,44.35),
    vector3(2683.31,4870.15,30.91),
    vector3(2659.44,4966.35,44.79),
    vector3(2637.28,5063.59,44.94),
    vector3(2613.16,5160.05,44.76),
    vector3(2584.69,5255.55,44.65),
    vector3(2557.66,5351.63,44.54),
    vector3(2529.76,5447.29,44.46),
    vector3(2497.82,5541.48,44.79),
    vector3(2460.47,5633.56,44.94),
    vector3(2416.48,5722.87,45.38),
    vector3(2375.14,5813.66,46.34),
    vector3(2323.37,5898.9,48.02),
    vector3(2255.68,5972.15,50.17),
    vector3(2182.26,6039.56,48.61),
    vector3(2099.72,6095.42,50.88),
    vector3(2024.17,6159.81,48.35),
    vector3(1962.21,6237.44,42.63),
    vector3(1892.83,6308.47,41.93),
    vector3(1801.61,6347.83,37.94),
    vector3(1705.69,6373.36,32.89),
    vector3(1613.16,6410.2,27.11),
    vector3(1519.7,6444.32,22.98),
    vector3(1425.53,6475.44,20.51),
    vector3(1327.86,6493.65,19.99),
    vector3(1228.01,6495.57,20.81),
    vector3(1128.2,6490.51,21.07),
    vector3(1028.39,6490.88,21.0),
    vector3(928.37,6490.83,21.09),
    vector3(828.77,6496.64,22.74),
    vector3(730.23,6508.96,26.98),
    vector3(383.77,3562.24,34.06),
    vector3(2423.55,3131.04,48.2),
    vector3(1540.14,6335.79,24.07),
}
local blips = {}
Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/mode', 'Jahat on/off kardan halat TCM', {
    })
    local ups = true
    -- for k , v in pairs(abrisham) do
    --     -- if ups then
    --     --     ups = false
    --     --     local blip = AddBlipForRadius(v.x,v.y,v.z,105.0)
    --     --     SetBlipAlpha(blip, 30)
    --     --     SetBlipColour(blip, 8)
    --     -- else
    --     --     ups = true
    --     -- end
    --     --
    --     local blip = AddBlipForRadius(v.x,v.y,v.z,100.0)
    --     SetBlipAlpha(blip, 15)
    --     SetBlipColour(blip, 1)
    --     --
    --     -- local blip = AddBlipForCoord(v.x,v.y,v.z)
    --     -- SetBlipSprite(blip, 444)
    --     -- SetBlipAlpha(blip, 255)
    --     -- SetBlipColour(blip, 8)
    --     -- SetBlipScale(blip, 1.3)
    -- end
end)

local CurrentWeather = 'EXTRASUNNY'
local lastWeather = CurrentWeather
local baseTime = 0
local timeOffset = 0
local timer = 0
local freezeTime = true
local blackout = false

RegisterNetEvent('vSync:updateWeather')
AddEventHandler('vSync:updateWeather', function(NewWeather, newblackout)
    CurrentWeather = NewWeather
    blackout = newblackout
end)
RegisterCommand('mode',function()
    if GetResourceKvpInt("tcm") == 1 then
        SetResourceKvpInt("tcm",0)
        ESX.ShowNotification('Halat TCM off shod')
    else
        SetResourceKvpInt("tcm",1)
        ESX.ShowNotification('Halat TCM on shod')
    end
end)
Citizen.CreateThread(function()
    if GetResourceKvpInt("tcm") == nil then
        SetResourceKvpInt("tcm",0)
    end
    while true do
        if lastWeather ~= CurrentWeather then
            lastWeather = CurrentWeather
            SetWeatherTypeOverTime(CurrentWeather, 15.0)
            Citizen.Wait(15000)
        end
        Citizen.Wait(1000) -- Wait 0 seconds to prevent crashing.
        SetBlackout(blackout)
        ClearOverrideWeather()
        ClearWeatherTypePersist()
        SetWeatherTypePersist(lastWeather)
        SetWeatherTypeNow(lastWeather)
        SetWeatherTypeNowPersist(lastWeather)
        if lastWeather == 'XMAS' then
            SetForceVehicleTrails(true)
            SetForcePedFootstepsTracks(true)
        else
            SetForceVehicleTrails(false)
            SetForcePedFootstepsTracks(false)
        end
    end
end)

RegisterNetEvent('vSync:updateTime')
AddEventHandler('vSync:updateTime', function(base, offset, freeze)
    freezeTime = freeze
    timeOffset = offset
    baseTime = base
end)
local createdblip = false
Citizen.CreateThread(function()
    local hour = 0
    local minute = 0
    while true do
        Citizen.Wait(1000)
        local newBaseTime = baseTime
        if GetGameTimer() - 500  > timer then
            newBaseTime = newBaseTime + 0.25
            timer = GetGameTimer()
        end
        if freezeTime then
            timeOffset = timeOffset + baseTime - newBaseTime			
        end
        baseTime = newBaseTime
        hour = math.floor(((baseTime+timeOffset)/60)%24)
        minute = math.floor((baseTime+timeOffset)%60)
        if hour >= 6 and hour < 19 and GetResourceKvpInt("tcm") == 1 then
            -- SetExtraTimecycleModifier("lightning")
        else
            -- SetExtraTimecycleModifier("")
        end
        if hour >= 21 or hour < 6 then
            if not createdblip then
                -- for k , v in pairs(abrisham) do
                --     createdblip = true
                --     local blip = AddBlipForRadius(v.x,v.y,v.z,100.0)
                --     SetBlipAlpha(blip, 15)
                --     SetBlipColour(blip, 1)
                --     table.insert(blips,blip)
                -- end
            end
        elseif hour >= 6 then
            if createdblip then
                for k , v in pairs(blips) do
                    RemoveBlip(v)
                end
                createdblip = false
                blips = {}
            end
        end
       -- SetExtraTimecycleModifierStrength(0.0)
        NetworkOverrideClockTime(hour, minute, 0)
    end
end)

AddEventHandler('playerSpawned', function()
    TriggerServerEvent('vSync:requestSync')
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/weather', 'Change the weather.', {{ name="weatherType", help="Available types: extrasunny, clear, neutral, smog, foggy, overcast, clouds, clearing, rain, thunder, snow, blizzard, snowlight, xmas & halloween"}})
    TriggerEvent('chat:addSuggestion', '/time', 'Change the time.', {{ name="hours", help="A number between 0 - 23"}, { name="minutes", help="A number between 0 - 59"}})
    TriggerEvent('chat:addSuggestion', '/freezetime', 'Freeze / unfreeze time.')
    TriggerEvent('chat:addSuggestion', '/freezeweather', 'Enable/disable dynamic weather changes.')
    TriggerEvent('chat:addSuggestion', '/morning', 'Set the time to 09:00')
    TriggerEvent('chat:addSuggestion', '/noon', 'Set the time to 12:00')
    TriggerEvent('chat:addSuggestion', '/evening', 'Set the time to 18:00')
    TriggerEvent('chat:addSuggestion', '/night', 'Set the time to 23:00')
    TriggerEvent('chat:addSuggestion', '/blackout', 'Toggle blackout mode.')
end)

RegisterNetEvent('vSync:notify')
AddEventHandler('vSync:notify', function(message, blink)
    ESX.ShowNotification(message, blink)
end)
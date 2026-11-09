-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX = exports['essentialmode']:getObject()
local loaded = false
point, primeEndTS, primeChecked, primeStatus, primeReward = 0, 0, false, false, {}

CreateThread(function ()
    while not ESX or not ESX.IsPlayerLoaded() do Wait(1000) end
    ESX.TriggerServerCallback('prime:getData', function(_point, _primeEndTS, _primeReward)
        point = _point
        primeEndTS = _primeEndTS
        primeReward = _primeReward
        loaded = true
        if isPrimeActive() then
            initMenu()
        end
    end)
end)

function isPrimeActive()
    while not loaded do Wait(10) end
    if not primeChecked then
        primeChecked = true
        local ts = exports['sunset_utils']:GetServerOSTime()
        primeStatus = primeEndTS > ts
        SetTimeout(60000, function()
            primeChecked = false
        end)
    end
    return primeStatus
end
exports('isPrimeActive', isPrimeActive)

function getPrimePoint()
    while not loaded do Wait(10) end
    return point
end
exports('getPrimePoint', getPrimePoint)

function isPrimeLoaded()
    return loaded
end
exports('isPrimeLoaded', isPrimeLoaded)

RegisterNetEvent('prime:update', function(_primeEndTS, _point, _primeReward)
    if _primeEndTS then
        primeEndTS = _primeEndTS
    end
    if _point then
        point = _point
    end
    if _primeReward then
        primeReward = _primeReward
    end
end)

function IsAccessToReward(key)
    return primeReward[key]
end
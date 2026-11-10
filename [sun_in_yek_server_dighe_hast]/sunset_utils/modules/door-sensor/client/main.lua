-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

configSensor = {}
configSensor.locations = {
    vector4(434.1, -981.39, 30.71, 0.5),     -- pd 1
    vector4(434.13, -982.56, 30.71, 0.5),    -- pd 1
    vector4(-543.8, -207.46, 37.65, 0.5),    -- justic
    vector4(-542.8, -206.8, 37.65, 0.5),     -- justic
    vector4(244.69, -442.36, 47.98, 0.5),    -- justic 2
    vector4(235.96, -421.17, 48.1, 0.5),     -- justic 2
    vector4(229.38, -418.45, 48.1, 0.5),     -- justic 2
}
configSensor.soundtime = 5 * 1000
configSensor.sounddistance = 10
configSensor.whitelist = {
    [`WEAPON_SNIPERRIFLE`] = true,
    [`WEAPON_MINIGUN`] = true,
    [`WEAPON_LUCILLE`] = true,
    [`WEAPON_KATANA`] = true,
    [`WEAPON_KATANA2`] = true,
    [`WEAPON_PETROLCAN`] = true,
    [`WEAPON_HEAVYSNIPER_MK2`] = true,
}

local cooldown = false

local function haveweapon(playerData)
    for _, weapon in ipairs(playerData.loadout) do
        if not configSensor.whitelist[GetHashKey(weapon.name)] then
            return true
        end
    end
    return false
end

Citizen.CreateThread(function()
    while not ESX do Wait(100) end
    while true do
        Wait(100)
        if not cooldown then
            local playerData = ESX.GetPlayerData()
            if haveweapon(playerData) and not ESX.militaryJobs2[playerData.job.name] then
                local coords = GetEntityCoords(PlayerPedId())
                for _, v in ipairs(configSensor.locations) do
                    if #(coords - v.xyz) < v.w then
                        cooldown = true
                        ESX.TriggerServerEvent('sensor:slarm', ESX.Game.GetPlayersToSend(10))
                        SetTimeout(configSensor.soundtime, function()
                            cooldown = false
                        end)
                        break
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('sensor:sync')
AddEventHandler('sensor:sync', function(src)
    if not ESX.Game.PlayerExist(src) then return end
    local targetCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(src)))
    local coords = GetEntityCoords(PlayerPedId())
    if #(coords - targetCoords) < configSensor.sounddistance then
        TriggerEvent('InteractSound_CL:PlayOnOne', 'devicealarm', 0.05)
    end
end)
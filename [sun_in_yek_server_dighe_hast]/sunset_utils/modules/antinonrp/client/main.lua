-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local deadData = {}
local thread = false
local reviveThread = false
local lossData = false
local warnText = [[
    شما در حال نزدیک شدن به مکان مرگ خود هستید
    جهت جلوگیری از زیر پا گذاشتن قانون نیو لایف سریعا از این منطقه فاصله بگیرید
    
    اخطار آخر درصورت دور نشدن با شما برخورد خواهد شد
]]

local function deadCheckThread()
    Citizen.CreateThread(function()
        thread = true
        local sessionId = ESX.GetPlayerData().sessionId
        while thread do
            Citizen.Wait(5000)
            local found = false
            if deadData then
                for k, v in pairs(deadData) do
                    if v.active and v.ts > GetServerOSTime() and v.sessionId == sessionId then
                        found = true
                        v.coords = vec(v.coords.x, v.coords.y, v.coords.z)
                        local distance = ESX.GetDistance(SUN.PlayerCoords, v.coords)
                        if distance < 200 and ESX.GetPlayerData().World == 0 and not ESX.GetPlayerData().inNCZ then
                            if not v.selfAlarm then
                                v.selfAlarm = true
                                Citizen.SetTimeout(60000,function()
                                    v.selfAlarm = false
                                end)
                                --TriggerEvent('txAdminClient:warn','System',warnText)
                                TriggerEvent('chat:addMessage', {
                                    template = '<div style="padding: 0.5vw; direction: rtl; margin: 0.5vw; background-color: rgba(255, 0, 0, 0.4); border-radius: 3px;"><i class="far fa-newspaper"></i><br>  {1}</div>',
                                    args = { 'System', warnText }
                                })
                                TriggerEvent("MpGameMessage:send", 'Ekhtar', 'Az makan new life khod fasele begirid\nDar gheyr in surat punishment e\'emal mishavad', 10000, 'success')
                            end
                            if distance < 100 then
                                if not v.adminAlarm then
                                    v.adminAlarm = true
                                    Citizen.SetTimeout(30000,function()
                                        v.adminAlarm = false
                                    end)
                                    alarm('Man be makan ^1new life^7 nazdik shodam')
                                end
                            end
                        end
                    end
                end
            end
            if not found then
                break
            end
        end
        thread = false
    end)
end


local function getKVPData()
    local data = GetResourceKvpString('deadData')
    if data and json.decode(data) then
        return json.decode(data)
    else
        return {}
    end
end


AddEventHandler('antiNonRP:setNewLifeData',function()
    local coords = SUN.PlayerCoords
    if ESX.GetPlayerData().isInIslandZone then return end
    local lastData = getKVPData()
    local data = {coords = coords,ts = GetServerOSTime() + 30 * 60, sessionId = ESX.GetPlayerData().sessionId}
    table.insert(lastData, data)
    SetResourceKvp('deadData', json.encode(lastData))
    deadData = lastData
    lossData = true
end)

AddEventHandler('antiNonRP:startNewLifeThread',function()
    if deadData ~= nil then
        if ESX.GetPlayerData().isInIslandZone then return end
        local lastData = getKVPData()
        for k, v in pairs(lastData) do
            if #(SUN.PlayerCoords - vec(v.coords.x, v.coords.y, v.coords.z)) < 50 then
                v.active = true
            end
        end
        SetResourceKvp('deadData', json.encode(lastData))
        if not thread then
            deadCheckThread()
        end
        deadData = lastData
        lossData = false
    end
end)

RegisterNetEvent('antiNonRP:clearNewLifeData',function(force)
    if lossData or force then
        SetResourceKvp('deadData', json.encode({}))
        deadData = nil
    end
    if force then
        thread = false
    end
end)

Citizen.CreateThread(function()
    while not SUN.serverTimeReady do Citizen.Wait(1000) end
    waitForLoad()
    local data = getKVPData()
    if data then
        for k, v in pairs(data) do
            v.active = true
            if not (v.ts and v.ts > GetServerOSTime()) then
                table.remove(data, k)
            end
        end
        SetResourceKvp('deadData', json.encode(data))
        if not thread then
            deadCheckThread()
        end
        deadData = data
    end
end)

AddEventHandler('antiNonRP:startReviveThread',function()
    if ESX.GetPlayerData().isInIslandZone then return end
    reviveThread = true
    Citizen.SetTimeout(5 * 60 * 1000,function()
        reviveThread = false
    end)
    CreateThread(function()
        ESX.emoteMenu(false)
        LocalPlayer.state.reviveThread = true
        ESX.startCountdown(5 * 60, 'Recovery Mode', nil, function() return reviveThread end, 0.4)
        while reviveThread do
            Wait(100)
            if IsPedRunning(SUN.ped) or IsPedSprinting(SUN.ped) then
                exports['suncore']:canRagdoll(true, 9000)
                SetPedToRagdoll(SUN.ped, 10000, 10000, 0, 0, 0, 0)
            end
            ResetPedMovementClipset(SUN.ped, 0)
        end
        LocalPlayer.state.reviveThread = nil
        ESX.emoteMenu(true)
    end)
end)

function ripHandler(key)
    -- if (reviveThread and SUN.CurrentWeaponModel ~= `weapon_stungun`) or getStress() >= 95 then
    if (reviveThread and SUN.CurrentWeaponModel ~= `weapon_stungun`) then
        Citizen.Wait(200)
        if (not exports['ox_target']:isActive() or key == 'space') and not (key == 'mouse_left' and SUN.CurrentWeaponModel == `weapon_unarmed`) then
            exports['suncore']:canRagdoll(true, 9000)
            SetPedToRagdoll(SUN.ped, 10000, 10000, 0, 0, 0, 0)
        end
    end
end

AddEventHandler('antiNonRP:stopReviveThread',function()
    reviveThread = false
end)

AddEventHandler('KeyDown:space', function ()
    ripHandler('space')
end)
AddEventHandler('KeyDown:mouse_left',function ()
    ripHandler('mouse_left')
end)
AddEventHandler('KeyDown:mouse_right',function ()
    ripHandler('mouse_right')
end)
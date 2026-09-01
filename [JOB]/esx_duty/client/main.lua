local CurrentAction           = nil
local CurrentActionJob       = nil
local HasAlreadyEnteredMarker = false
local lastDutyChangeTime     = 0 
local lastNotifyTime         = 0 
local dutyChangeCooldown      = 5 
local notifyCooldown           = 5000  
ESX                           = nil

Citizen.CreateThread(function ()
    TriggerEvent('chat:addSuggestion', '/dutyjob', 'Open Menu Time Play jobs')
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

AddEventHandler('esx_duty:hasEnteredMarker', function (zone)
    if zone == 'ambulance' or zone == "police" or zone == "mechanic" or zone == "sheriff" or zone == "taxi" or zone == "weazel" or zone == "fbi" or zone == "mt"
        or zone == "cid" or zone == "cia" or zone == "marshal" or zone == "judge" or zone == "doa"
        or zone == "uwucafe" or zone == "obsidian" or zone == "voltage" or zone == "ember" or zone == "anchor" or zone == "crimson" or zone == "flourish" or zone == "goldcrust" or zone == "static" or zone == "nightjar" or zone == "firebrick" or zone == "slice" or zone == "frostbite" or zone == "sundae" or zone == "koi" or zone == "wasabi" or zone == "carwash" or zone == "meridian" or zone == "blacktide" or zone == "cratecarry" or zone == "turfco" then
        CurrentAction     = 'duty'
        CurrentActionJob  = zone
    end
end)

AddEventHandler('esx_duty:hasExitedMarker', function ()
    CurrentAction = nil
    CurrentActionJob = nil
end)

local typeMap = { info = 'inform', information = 'inform' }

RegisterNetEvent('esx_duty:sendnot')
AddEventHandler('esx_duty:sendnot', function(msg, type, timeout)
    lib.notify({
        description = msg,
        type = typeMap[type] or type or 'inform',
        position = 'bottom',
        duration = timeout or 5000
    })
end)

Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(0)
        if CurrentAction ~= nil then
            SetTextComponentFormat('STRING')
            AddTextComponentString("Az ~INPUT_CONTEXT~ Baraye ~r~OFFDuty~w~/~g~OnDuty ~w~Estefade Konid")
            DisplayHelpTextFromStringLabel(0, 0, 1, -1)
            if IsControlPressed(0, 38) then
                local currentTime = GetGameTimer() -- زمان فعلی بازی
                if currentTime - lastDutyChangeTime >= dutyChangeCooldown then -- چک کردن اینکه آیا زمان کافی گذشته است
                    if CurrentAction == 'duty' then
                        -- FIX: snapshot جاب رو قبل از هر تغییری بگیر تا اگه بازیکن
                        -- سریع از مارکر خارج بشه و CurrentActionJob نال بشه،
                        -- مقدار درست همچنان به سرور فرستاده بشه (رفع باگ concatenate nil سمت سرور)
                        local jobToSend = CurrentActionJob

                        CurrentAction = nil
                        Citizen.Wait(100)

                        if jobToSend then
                            TriggerServerEvent('esx_duty:setjob', jobToSend)
                            TriggerServerEvent('esx_duty:setjob2', jobToSend)
                            lastDutyChangeTime = currentTime -- زمان آخرین تغییر وضعیت را ثبت کنید
                        end
                    end
                else
                    -- در صورت تلاش برای تغییر وضعیت قبل از اتمام زمان
                    if currentTime - lastNotifyTime >= notifyCooldown then
                        TriggerEvent('esx_duty:sendnot', "Lotfan sabr konid, mitavanid ba'd az " .. tostring(math.ceil((dutyChangeCooldown - (currentTime - lastDutyChangeTime)) / 1000)) .. " saniye dige dastoor ra estefade konid!", "error", 5000)
                        lastNotifyTime = currentTime -- زمان آخرین نوتیفیکیشن را ثبت کنید
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function ()
    while true do
        Wait(0)
        local coords = GetEntityCoords(GetPlayerPed(-1))
        for k, v in pairs(Config.Zones) do
        
            if (GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 10.0) then
                DrawMarker(20, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, false, false, false, false)
            end
        end
    end
end)

Citizen.CreateThread(function ()
    while true do
        Wait(0)
        local coords      = GetEntityCoords(GetPlayerPed(-1))
        local isInMarker  = false
        local currentZone = nil
        for k, v in pairs(Config.Zones) do
            if (GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.Size.x) then
                isInMarker  = true
                currentZone = k
            end
        end
        if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker) then
            HasAlreadyEnteredMarker = true
            TriggerEvent('esx_duty:hasEnteredMarker', currentZone)
        end
        if not isInMarker and HasAlreadyEnteredMarker then
            HasAlreadyEnteredMarker = false
            TriggerEvent('esx_duty:hasExitedMarker')
        end
    end
end)


RegisterNetEvent('esx_duty:openDutyJobMenu')
AddEventHandler('esx_duty:openDutyJobMenu', function(players)
   print(json.encode(players))
    SendNUIMessage({
        type = 'openMenu',
        players = players,

    })
    SetNuiFocus(true, true) 
end)


RegisterNUICallback('closeMenu', function(data, cb)
    SetNuiFocus(false, false) 
    cb('ok')
end)


RegisterNUICallback('checkDutyTime', function(data, cb)
    TriggerServerEvent('esx_duty:checkDutyTime', data.steamHex, data.startDate, data.endDate)
    cb({ status = 'ok' })
end)


RegisterNetEvent('esx_duty:displayDutyResult')
AddEventHandler('esx_duty:displayDutyResult', function(resultMessage)
    print(json.encode(resultMessage))
    SendNUIMessage({
        type = 'dutyResult',
        result = resultMessage
    })
end)

-- ===== AFK check for on-duty organ jobs =====
-- If you're on-duty (job doesn't start with "off") and don't move for 15
-- minutes, you get a simple math question. Answer correctly in time and the
-- timer just resets. Answer wrong, or don't answer at all, and you're put
-- off-duty automatically (same as pressing the duty key yourself) with an
-- announcement in /f explaining why.
local Config_AfkCheckInterval  = 15 * 60 * 1000 -- 15 minutes of no movement before a check triggers
local Config_AfkAnswerTimeout  = 30 * 1000      -- 30 seconds to answer the question
local Config_AfkMoveThreshold  = 1.0            -- meters of movement that counts as "not AFK"

local afkLastCoords  = nil
local afkLastMoveTime = 0
local afkCheckRunning = false

-- Only these three organs get the AFK check — everything else in Config.Zones
-- (Holding 1 cafes/businesses etc.) is left alone.
local AfkCheckJobs = {
    -- Department Of Justice
    cid = true, cia = true, marshal = true, fbi = true, judge = true, doa = true,
    -- Law Enforcement
    police = true, sheriff = true, mt = true,
    -- Organ Services
    taxi = true, mechanic = true, ambulance = true, weazel = true,
}

local function isOnDutyOrganJob(jobName)
    if not jobName then return false end
    if string.sub(jobName, 1, 3) == "off" then return false end
    return AfkCheckJobs[jobName] == true
end

local function runAfkCheck(jobName)
    afkCheckRunning = true

    local num1 = math.random(2, 20)
    local num2 = math.random(2, 20)
    local correctAnswer = num1 + num2

    local answered = false
    local wasCorrect = false

    Citizen.CreateThread(function()
        local input = lib.inputDialog('AFK Check', {
            {type = 'input', label = ('Javab Ra Vared Konid: %s + %s = ?'):format(num1, num2), required = true}
        })

        answered = true
        if input and tonumber(input[1]) == correctAnswer then
            wasCorrect = true
        end
    end)

    Citizen.Wait(Config_AfkAnswerTimeout)

    if answered and wasCorrect then
        ESX.ShowNotification('AFK Check: ~g~Dorost Bod~s~')
        afkLastMoveTime = GetGameTimer()
        afkLastCoords = GetEntityCoords(PlayerPedId())
    else
        ExecuteCommand('f Man Be Dalil Afk OffDuty Shodam')
        TriggerServerEvent('esx_duty:setjob', jobName)
        TriggerServerEvent('esx_duty:setjob2', jobName)
    end

    afkCheckRunning = false
end

Citizen.CreateThread(function()
    while ESX == nil do Citizen.Wait(10) end

    while true do
        Citizen.Wait(30000)

        local playerData = ESX.GetPlayerData()
        local jobName = playerData.job and playerData.job.name

        if isOnDutyOrganJob(jobName) and not afkCheckRunning then
            local coords = GetEntityCoords(PlayerPedId())

            if not afkLastCoords then
                afkLastCoords  = coords
                afkLastMoveTime = GetGameTimer()
            elseif #(coords - afkLastCoords) > Config_AfkMoveThreshold then
                afkLastCoords  = coords
                afkLastMoveTime = GetGameTimer()
            elseif GetGameTimer() - afkLastMoveTime >= Config_AfkCheckInterval then
                runAfkCheck(jobName)
            end
        else
            -- not on an organ job right now (or off-duty) — don't accumulate AFK time
            afkLastCoords   = nil
            afkLastMoveTime = GetGameTimer()
        end
    end
end)

RegisterNetEvent('esx_duty:checkDutyTime')
AddEventHandler('esx_duty:checkDutyTime', function(steamHex, startDate, endDate)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)  

 
    local playerJob = xPlayer.job.name

    exports.oxmysql:execute('SELECT total_time, date, job_name FROM duty_logs WHERE steamhex = ? AND job_name = ? AND date BETWEEN ? AND ? ORDER BY date', 
        { steamHex, playerJob, startDate, endDate }, function(results)
            if results and #results > 0 then
                local dutyResults = {}
                for _, result in ipairs(results) do
                    if playerJob == result.job_name then
                        local totalTime = result.total_time
                        local dateTimestamp = math.floor(result.date / 1000) 
                        local formattedDate = os.date("%Y/%m/%d", dateTimestamp) 

                        local hours = math.floor(totalTime / 3600)
                        local minutes = math.floor((totalTime % 3600) / 60)
                        local seconds = totalTime % 60

                        table.insert(dutyResults, {
                            name = xPlayer.getName(), 
                            date = formattedDate,
                            hours = hours,
                            minutes = minutes,
                            seconds = seconds
                        })
                    end
                end

                TriggerClientEvent('esx_duty:displayDutyResult', src, dutyResults)
            else
                TriggerClientEvent('esx_duty:displayDutyResult', src, { message = "هیچ تایمی پیدا نشد." })
            end
    end)
end)
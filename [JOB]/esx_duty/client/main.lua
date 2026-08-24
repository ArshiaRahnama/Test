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
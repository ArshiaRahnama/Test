ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


local activeDutyPlayers = {}

RegisterServerEvent('esx_duty:setjob')
AddEventHandler('esx_duty:setjob', function(job)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer or not job then
        print(('[esx_duty] esx_duty:setjob fired with a missing job (source=%s, job=%s) — check the client trigger'):format(source, tostring(job)))
        return
    end
    local steamIdentifier = GetPlayerIdentifiers(source)[1]  
    local steamName = GetPlayerName(source)                  
    local playerName = xPlayer.get('name')                  
    local playerID = source                                   
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")            
    local unixTime = os.time()                                 

    local dutyText
    local message

    if xPlayer.job.name == job then
       
        xPlayer.setJob('off'..job, xPlayer.job.grade)
        dutyText = "^4[^2^*Off-Duty ^4|"
        message = "Man Off Duty Shodam"
        
       
        TriggerClientEvent('esx:showNotification', source, "Shoma Off Duty Shodid!")

        activeDutyPlayers[source] = nil



       
        local xPlayers = ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local targetPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if targetPlayer.job.name == job or targetPlayer.job.name == "off" .. job then 
                local name = GetPlayerName(xPlayers[i])
                local jobGrade = xPlayer.job.grade_label
                TriggerClientEvent('chatMessage', xPlayers[i], "", {255, 0, 0}, dutyText .. "^1" .. jobGrade .. "^4]: ^3" .. string.gsub(xPlayer.name, "_", " ") .. " ^4(( " .. "^0^*" .. message .. "^4 ))")
            end
        end

       
        PerformHttpRequest(Config.Webhooks[job], function(err, text, headers) end, 'POST', json.encode({
            content = "",
            embeds = {
                {
                    title = "Off-Duty Notification",
                    color = 0xff0000, 
                    fields = {
                        {name = "Player ID", value = tostring(playerID), inline = true},
                        {name = "Player Name", value = playerName, inline = true},
                        {name = "Steam Name", value = steamName, inline = true},
                        {name = "Steam Hex", value = steamIdentifier, inline = true},
                        {name = "Time", value = timestamp, inline = true},
                        {name = "TimeStamp", value = tostring(unixTime), inline = true}
                    },
                    timestamp = timestamp
                }
            }
        }), {['Content-Type'] = 'application/json'})

    elseif xPlayer.job.name == "off"..job then

        xPlayer.setJob(job, xPlayer.job.grade)
        dutyText = "^4[^2^*On-Duty ^4|"
        message = "Man On Duty Shodam"
        

        TriggerClientEvent('esx:showNotification', source, "Shoma On Duty Shodid!")

        local xPlayers = ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local targetPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if targetPlayer.job.name == job or targetPlayer.job.name == "off" .. job then 
                local name = GetPlayerName(xPlayers[i]) 
                local jobGrade = xPlayer.job.grade_label
                TriggerClientEvent('chatMessage', xPlayers[i], "", {255, 0, 0}, dutyText .. "^1" .. jobGrade .. "^4]: ^3" .. string.gsub(xPlayer.name, "_", " ") .. " ^4(( " .. "^0^*" .. message .. "^4 ))")
            end
        end



        activeDutyPlayers[source] = job
       
        PerformHttpRequest(Config.Webhooks[job], function(err, text, headers) end, 'POST', json.encode({
            content = "",
            embeds = {
                {
                    title = "On-Duty Notification",
                    color = 0x00ff00,
                    fields = {
                        {name = "Player ID", value = tostring(playerID), inline = true},
                        {name = "Player Name", value = playerName, inline = true},
                        {name = "Steam Name", value = steamName, inline = true},
                        {name = "Steam Hex", value = steamIdentifier, inline = true},
                        {name = "Time", value = timestamp, inline = true},
                        {name = "TimeStamp", value = tostring(unixTime), inline = true}
                    },
                    timestamp = timestamp
                }
            }
        }), {['Content-Type'] = 'application/json'})

    end
end)






local lastPlayerPosition = {}
local afkTimers = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300000) 

        
        for _, source in pairs(GetPlayers()) do
            local xPlayer = ESX.GetPlayerFromId(source)
            if xPlayer then
                local JobName = xPlayer.job.name
                if xPlayer and (JobName == 'police' or JobName == 'sheriff' or JobName == 'ambulance' or JobName == 'fbi' or JobName == 'mechanic' or JobName == 'weazel' or JobName == 'taxi' or JobName == 'mt'
                    or JobName == 'cid' or JobName == 'cia' or JobName == 'marshal' or JobName == 'judge' or JobName == 'doa'
                    or JobName == 'uwucafe' or JobName == 'obsidian' or JobName == 'voltage' or JobName == 'ember' or JobName == 'anchor' or JobName == 'crimson' or JobName == 'flourish' or JobName == 'goldcrust' or JobName == 'static' or JobName == 'nightjar' or JobName == 'firebrick' or JobName == 'slice' or JobName == 'frostbite' or JobName == 'sundae' or JobName == 'koi' or JobName == 'wasabi' or JobName == 'carwash' or JobName == 'meridian' or JobName == 'blacktide' or JobName == 'cratecarry' or JobName == 'turfco') then
                    local steamHex = GetPlayerIdentifiers(source)[1] 
                    local todayDate = os.date("%Y-%m-%d") 
                    local jgrade = xPlayer.job.grade_label


                    local playerPosition = GetEntityCoords(GetPlayerPed(source))
                    
                    if lastPlayerPosition[source] and #(playerPosition - lastPlayerPosition[source]) < 3.0 then
                        afkTimers[source] = (afkTimers[source] or 0) + 300
                        lastPlayerPosition = GetEntityCoords(GetPlayerPed(source))
                     
                        if afkTimers[source] >= 900 then
                            


                            if xPlayer.permission_level >= 2 then

                            else
                           
                                local job = xPlayer.job.name
                                xPlayer.setJob('off'..job, xPlayer.job.grade)
                                dutyText = "^4[^2^*Off-Duty ^4|"
                                message = "Man Off Duty Shodam Be Dalil Afk"
                                
                                
                                TriggerClientEvent('esx:showNotification', source, "Shoma Off Duty Shodid!")
                        
                                activeDutyPlayers[source] = nil
                        
                        
                        
                                local xPlayers = ESX.GetPlayers()
                                for i=1, #xPlayers, 1 do
                                    local targetPlayer = ESX.GetPlayerFromId(xPlayers[i])
                                    if targetPlayer.job.name == job or targetPlayer.job.name == "off" .. job then -- چک کردن اینکه پلیر جاب مشابه دارد
                                        local name = string.gsub(GetPlayerName(xPlayers[i]), "_", " ")
                                        local jobGrade = xPlayer.job.grade_label
                                        TriggerClientEvent('chatMessage', xPlayers[i], "", {255, 0, 0}, dutyText .. "^1" .. jobGrade .. "^4]: ^3" .. xPlayer.name .. " ^4(( " .. "^0^*" .. message .. "^4 ))")
                                    end
                                end
                        
                         
                                PerformHttpRequest(Config.Webhooks[job], function(err, text, headers) end, 'POST', json.encode({
                                    content = "",
                                    embeds = {
                                        {
                                            title = "Off-Duty Notification",
                                            color = 0xff0000, 
                                            fields = {
                                                {name = "Player ID", value = tostring(playerID), inline = true},
                                                {name = "Player Name", value = playerName, inline = true},
                                                {name = "Steam Name", value = steamName, inline = true},
                                                {name = "Steam Hex", value = steamIdentifier, inline = true},
                                                {name = "Time", value = timestamp, inline = true},
                                                {name = "TimeStamp", value = tostring(unixTime), inline = true}
                                            },
                                            timestamp = timestamp
                                        }
                                    }
                                }), {['Content-Type'] = 'application/json'})
                            



                                
                                activeDutyPlayers[source] = nil
                                afkTimers[source] = nil
                                goto continue 
                            end
                        end
                    else
                        
                        lastPlayerPosition[source] = playerPosition
                        afkTimers[source] = 0
                    end
                   

                    
                    exports.oxmysql:execute('SELECT id, job_name, job_grade FROM duty_logs WHERE steamhex = ? AND date = ?', { steamHex, todayDate }, function(result)
                        if result and #result > 0 then
                            
                            if result[1].job_name ~= JobName then
                               
                                exports.oxmysql:execute('SELECT id FROM duty_logs WHERE steamhex = ? AND date = ? AND job_name = ?', {
                                    steamHex,
                                    todayDate,
                                    JobName,
                                }, function(newJobCheck)
                                    if newJobCheck and #newJobCheck == 0 then
                                        
                                        exports.oxmysql:execute('INSERT INTO duty_logs (steamhex, ic_name, job_name, job_grade, date, total_time) VALUES (?, ?, ?, ?, ?, ?)', {
                                            steamHex,
                                            xPlayer.name,
                                            JobName,
                                            jgrade,
                                            todayDate,
                                            300
                                        })
                                    else
                                        
                                        exports.oxmysql:execute('UPDATE duty_logs SET total_time = total_time + 300 WHERE steamhex = ? AND date = ? AND job_name = ?', {
                                            steamHex,
                                            todayDate,
                                            JobName,
                                        })
                                    end
                                end)
                            else
                              
                                exports.oxmysql:execute('UPDATE duty_logs SET total_time = total_time + 300 WHERE steamhex = ? AND date = ?', {
                                    steamHex,
                                    todayDate
                                })
                            end
                        else
                          
                            exports.oxmysql:execute('INSERT INTO duty_logs (steamhex, ic_name, job_name, job_grade, date, total_time) VALUES (?, ?, ?, ?, ?, ?)', {
                                steamHex,
                                xPlayer.name,
                                JobName,
                                jgrade,
                                todayDate,
                                300
                            })
                        end
                    end)
                    
                    
                    
                end
                ::continue::
            end
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











RegisterNetEvent('esx_duty:sendDutyResult')
AddEventHandler('esx_duty:sendDutyResult', function(dutyTimes)
    local resultMessage = ""

    if #dutyTimes == 0 then
        resultMessage = "هیچ تایمی برای این بازیکن پیدا نشد."
    else
        for _, record in ipairs(dutyTimes) do
          
            local formattedDate = os.date("%Y/%m/%d", record.date / 1000)  
            resultMessage = resultMessage .. string.format("تاریخ: %s - مدت زمان: %d ساعت، %d دقیقه، %d ثانیه\n",
                formattedDate, record.hours, record.minutes, record.seconds)
        end
    end

   
    TriggerClientEvent('esx_duty:displayDutyResult', source, resultMessage)
end)








RegisterCommand('dutyjob', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)

    
    if xPlayer.job.grade <= 11 then
       
        local playerList = {
            { 
                identifier = xPlayer.identifier,  
                name = xPlayer.name,  
                JobName = xPlayer.job.name,  
                jobGrade = xPlayer.job.grade  
            }
        }

        
        TriggerClientEvent('esx_duty:openDutyJobMenu', source, playerList)
    else
       
        exports.oxmysql:execute('SELECT identifier, playerName, job, job_grade FROM users WHERE job = ?', { xPlayer.job.name }, function(players)
            local playerList = {}
            
            
            for _, player in ipairs(players) do
                table.insert(playerList, {
                    identifier = player.identifier, 
                    name = string.gsub(player.playerName, "_", " "),         
                    JobName = player.job,             
                    jobGrade = player.job_grade      
                })
      
            end


            TriggerClientEvent('esx_duty:openDutyJobMenu', source, playerList)
        end)
    end
end)
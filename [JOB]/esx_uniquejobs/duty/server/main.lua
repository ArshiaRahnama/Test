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

       
        PerformHttpRequest(Config_duty.Webhooks[job], function(err, text, headers) end, 'POST', json.encode({
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
       
        PerformHttpRequest(Config_duty.Webhooks[job], function(err, text, headers) end, 'POST', json.encode({
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
                -- BUG FIX: was the same 33-way hardcoded job-name chain as the
                -- client-side one above -- now just checks Config_duty.Zones,
                -- which already has to list every one of these jobs anyway.
                if xPlayer and Config_duty.Zones[JobName] then
                    local steamHex = GetPlayerIdentifiers(source)[1] 
                    local todayDate = os.date("%Y-%m-%d") 
                    local jgrade = xPlayer.job.grade_label
                    -- BUG FIX: these six were referenced further down (inside the
                    -- AFK-kick PerformHttpRequest) but never defined anywhere in
                    -- this scope -- every AFK-triggered off-duty webhook posted
                    -- "nil" for player ID/name/steam name/hex/time/timestamp.
                    -- Computed the same way the esx_duty:setjob handler above does.
                    local playerID = source
                    local steamIdentifier = steamHex
                    local steamName = GetPlayerName(source)
                    local playerName = xPlayer.get('name')
                    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
                    local unixTime = os.time()


                    local playerPosition = GetEntityCoords(GetPlayerPed(source))
                    
                    if lastPlayerPosition[source] and #(playerPosition - lastPlayerPosition[source]) < 3.0 then
                        afkTimers[source] = (afkTimers[source] or 0) + 300
                        -- BUG FIX: was `lastPlayerPosition = GetEntityCoords(...)` with
                        -- no [source] index -- overwrote the WHOLE tracking table with
                        -- a single vector3 instead of updating this one player's entry,
                        -- so every other player's (and this one's, next cycle)
                        -- lastPlayerPosition[source] read came back nil and the AFK
                        -- timer silently reset every 5 minutes instead of accumulating.
                        lastPlayerPosition[source] = playerPosition
                     
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
                        
                         
                                PerformHttpRequest(Config_duty.Webhooks[job], function(err, text, headers) end, 'POST', json.encode({
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

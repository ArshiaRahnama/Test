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

        -- BUG FIX (player never actually goes off-duty): jobs_grades only has
        -- ONE grade (0) defined for the "off<job>" variant of cid/marshal/judge/doa
        -- (and fewer grades than the on-duty job for weazel/fbi too), while the
        -- player's real grade here can be as high as 21 (e.g. Chief Justice).
        -- xPlayer.setJob('offjudge', 21) was being called with a (job, grade)
        -- pair that doesn't exist in jobs_grades, so ESX silently did nothing --
        -- xPlayer.job.name never actually changed to the off-duty job, even
        -- though the code below unconditionally announced "Off-Duty" in chat.
        -- Fix: remember the real on-duty grade, then switch using grade 0 (the
        -- only grade guaranteed to exist for every off<job>), so the setJob
        -- call always succeeds. The grade is restored below when going back
        -- on-duty, so rank isn't lost.
        xPlayer.set('esx_duty_lastGrade', xPlayer.job.grade)
        xPlayer.setJob('off'..job, 0)
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

        -- Restore the grade saved when they went off-duty (falls back to the
        -- current, now-0, grade only if nothing was ever saved).
        local restoreGrade = xPlayer.get('esx_duty_lastGrade') or xPlayer.job.grade
        xPlayer.setJob(job, restoreGrade)
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






-- NOTE: this thread now ONLY logs worked time to duty_logs every 5 minutes
-- for whoever is on an organ job. It used to ALSO run a second, independent
-- AFK-kick system here (position tracking + a 900s idle timer that force
-- off-duty'd the player with zero warning), completely separate from the
-- math-question AFK check in duty/client/main.lua. Removed per request --
-- the client-side math check is now the only thing that ever takes someone
-- off-duty for being AFK, so the two systems can no longer race each other
-- and produce duplicate "Off-Duty" announcements.
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
                if Config_duty.Zones[JobName] then
                    local steamHex = GetPlayerIdentifiers(source)[1]
                    local todayDate = os.date("%Y-%m-%d")
                    local jgrade = xPlayer.job.grade_label

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
            end
        end
    end
end)
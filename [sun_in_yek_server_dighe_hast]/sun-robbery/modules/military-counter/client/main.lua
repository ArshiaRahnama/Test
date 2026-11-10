-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local threadBool, onDuty = false, false
function militaryCheckThread()
    if not threadBool then
        threadBool = true
        CreateThread(function()
            while threadBool do
                local near = false
                if militaryCounter.jobs[ESX.PlayerData.job.name] then
                    local gradeCheck = false
                    if militaryCounter.jobs[ESX.PlayerData.job.name].gradeType then
                        if militaryCounter.jobs[ESX.PlayerData.job.name].gradeType == 1 then
                            if ESX.PlayerData.job.grade == militaryCounter.jobs[ESX.PlayerData.job.name].grade then
                                gradeCheck = true
                            end
                        end
                        if militaryCounter.jobs[ESX.PlayerData.job.name].gradeType == 2 then
                            if ESX.PlayerData.job.grade <= militaryCounter.jobs[ESX.PlayerData.job.name].grade then
                                gradeCheck = true
                            end
                        end
                        if militaryCounter.jobs[ESX.PlayerData.job.name].gradeType == 3 then
                            if ESX.PlayerData.job.grade >= militaryCounter.jobs[ESX.PlayerData.job.name].grade then
                                gradeCheck = true
                            end
                        end
                        if militaryCounter.jobs[ESX.PlayerData.job.name].gradeType == 4 and militaryCounter.jobs[ESX.PlayerData.job.name].grade2 then
                            if ESX.PlayerData.job.grade >= militaryCounter.jobs[ESX.PlayerData.job.name].grade and ESX.PlayerData.job.grade <= militaryCounter.jobs[ESX.PlayerData.job.name].grade2 then
                                gradeCheck = true
                            end
                        end
                    elseif ESX.PlayerData.job.grade >= militaryCounter.jobs[ESX.PlayerData.job.name].grade then
                        gradeCheck = true
                    end

                    if gradeCheck or militaryCounter.jobs[ESX.PlayerData.job.name].divisions[ESX.PlayerData.job.ext] then
                        local coords = GetEntityCoords(PlayerPedId())
                        for k, v in pairs(militaryCounter.coords) do
                            if #(coords - v.xyz) < v.w then
                                near = true
                                break
                            end
                        end
                        if world ~= 0 and not exports['sun-robbery']:doesInRob() and world ~= 102 and world ~= 90 and world ~= 103 then
                            near = true
                        elseif world == 102 or world == 90 or world == 103 then
                            near = false
                        end
                    end
                end
                if near then
                    if not onDuty then
                        onDuty = true
                        TriggerServerEvent('rob:setDuty', true)
                    end
                elseif onDuty then
                    onDuty = false
                    TriggerServerEvent('rob:setDuty', false)
                end
                Wait(5000)
            end
        end)
    end
end
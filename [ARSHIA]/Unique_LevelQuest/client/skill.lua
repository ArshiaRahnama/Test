local ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

function UpdateSkills()
    ESX.TriggerServerCallback('HUD_Menu:GetSkills', function(skills)
        local formatted = {}
        for _, s in ipairs(skills) do
            table.insert(formatted, {
                title       = s.label,
                jobName     = s.jobName,
                value       = s.target > 0 and (s.minutes / s.target) or 0,
                hours       = math.floor(s.minutes / 60),
                targetHours = math.floor(s.target / 60),
                isCurrent   = s.isCurrent,
            })
        end
        SendNUIMessage({ type = "loadSkills", skills = formatted })
    end)

    ESX.TriggerServerCallback('HUD_Menu:GetActivitySkills', function(list)
        SendNUIMessage({ type = "loadActivitySkills", skills = list or {} })
    end)
end

-- Unique skill-up effect: green "+" symbols float up the screen (see html/scripts/skill.js)
RegisterNetEvent('Unique_LevelQuest:skillUp')
AddEventHandler('Unique_LevelQuest:skillUp', function()
    SendNUIMessage({ type = "skillUp" })
end)

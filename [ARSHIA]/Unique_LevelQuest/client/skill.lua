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
end

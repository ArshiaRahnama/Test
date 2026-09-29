CL = {}

CL.Notification = function(message, time, type)
    if type == "success" then
        if GetResourceState("vms_notify") == 'started' then
            exports['vms_notify']:Notification("BARBER", message, time, "#36f230", "fa fa-scissors")
        else
            TriggerEvent('esx:showNotification', message)
            TriggerEvent('QBCore:Notify', message, 'success', time)
        end
    elseif type == "error" then
        if GetResourceState("vms_notify") == 'started' then
            exports['vms_notify']:Notification("BARBER", message, time, "#f23030", "fa fa-scissors")
        else
            TriggerEvent('esx:showNotification', message)
            TriggerEvent('QBCore:Notify', message, 'error', time)
        end
    elseif type == "info" then
        if GetResourceState("vms_notify") == 'started' then
            exports['vms_notify']:Notification("BARBER", message, time, "#4287f5", "fa fa-scissors")
        else
            TriggerEvent('esx:showNotification', message)
            TriggerEvent('QBCore:Notify', message, 'primary', time)
        end
    end
end

CL.TextUI = {
    Enabled = false,
    Open = function(message)
        if GetResourceState("interact") == 'started' then
            exports["interact"]:Open("E", message) -- Here you can use your TextUI or use my free one - https://github.com/vames-dev/interact
            
        elseif GetResourceState("okokTextUI") == 'started' then
            exports['okokTextUI']:Open('[E] '..message, 'darkgreen', 'right')
            
        else
            if Config.Core == "ESX" then
                ESX.TextUI(message)
                
            else
                exports['qb-core']:DrawText(message, 'right')
            end
        end
        
    end,
    Close = function()
        if GetResourceState("interact") == 'started' then
            exports["interact"]:Close() -- Here you can use your TextUI or use my free one - https://github.com/vames-dev/interact
            
        elseif GetResourceState("okokTextUI") == 'started' then
            exports['okokTextUI']:Close()
            
        else
            if Config.Core == "ESX" then
                ESX.HideUI()
                
            else
                exports['qb-core']:HideText()
                
            end
        end
    end
}

-- ▀█▀ ▄▀▄ █▀▄ ▄▀  ██▀ ▀█▀
--  █  █▀█ █▀▄ ▀▄█ █▄▄  █ 
CL.Target = function(type, data, cb)
    if Config.TargetResource == 'ox_target' then
        if type == "point" then
            return exports['ox_target']:addBoxZone({
                coords = vec(data.coords.x, data.coords.y, data.coords.z),
                size = data.size,
                debug = false,
                useZ = true,
                rotation = data.rotation or 0.0,
                options = {
                    {
                        distance = 1.8,
                        name = 'vms_barber',
                        icon = data.icon,
                        label = data.label,
                        groups = data.job or nil,
                        onSelect = function()
                            cb()
                        end
                    }
                }
            })
        elseif type == "remove_point" then
            exports['ox_target']:removeZone(data.targetId)
        end
    elseif Config.TargetResource == "qb-target" then
        if type == "point" then
            exports['qb-target']:AddBoxZone('vms_barber-'..data.uniqueName, vec(data.coords.x, data.coords.y, data.coords.z), data.size.x, data.size.y, {
                name = 'vms_barber-'..data.uniqueName,
                heading = data.rotation - 90.0 or 0.0,
                debugPoly = false,
                minZ = data.coords.z - (data.size.y),
                maxZ = data.coords.z + (data.size.y),
            }, {
                options = {
                    {
                        num = 1,
                        icon = data.icon,
                        label = data.label,
                        job = data.job or nil,
                        action = function()
                            cb()
                        end,
                    }
                },
                distance = 1.8,
            })
            return 'vms_barber-'..data.uniqueName
        elseif type == "remove_point" then
            exports['qb-target']:RemoveZone(data.targetId)
        end
    else
        print("Configuration for " .. Config.TargetResource .. " doesn't exist, you have to adjust CL.Target for the target system...")
    end
end


CL.GetClosestPlayers = function()
    if Config.Core == "ESX" then
        local playerInArea = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 5.0)
        return playerInArea
    elseif Config.Core == "QB-Core" then
        local playerInArea = QBCore.Functions.GetPlayersFromCoords(GetEntityCoords(PlayerPedId()), 5.0)
        return playerInArea
    end
end

CL.IsEmployee = function(jobName)
    if Config.Core == "ESX" then
        return PlayerData.job.name == jobName
    elseif Config.Core == "QB-Core" then
        return PlayerData.job.name == jobName
    end
end

CL.IsManager = function(jobName, barberPointId)
    local managerGrades = Config.Barbers[barberPointId].manager_grades
    
    if Config.Core == "ESX" then
        if PlayerData.job.name ~= jobName then
            return false
        end
        
        if type(managerGrades) == 'table' then
            for _, grade in ipairs(managerGrades) do
                if PlayerData.job.grade_name == grade then
                    return true
                end
            end
        else
            return PlayerData.job.grade_name == managerGrades
        end
    elseif Config.Core == "QB-Core" then
        if PlayerData.job.name ~= jobName then
            return false
        end

        if type(managerGrades) == 'table' then
            for _, grade in ipairs(managerGrades) do
                if PlayerData.job.grade.name == grade then
                    return true
                end
            end
        else
            return PlayerData.job.grade.name == managerGrades
        end
        
    end
end

CL.IsBoss = function(jobName, barberPointId)
    local bossGrades = Config.Barbers[barberPointId].boss_grades
    if Config.Core == "ESX" then
        if PlayerData.job.name ~= jobName then
            return false
        end

        if type(bossGrades) == 'table' then
            for _, grade in ipairs(bossGrades) do
                if PlayerData.job.grade_name == grade then
                    return true
                end
            end
        else
            return PlayerData.job.grade_name == bossGrades
        end
        
    elseif Config.Core == "QB-Core" then
        if PlayerData.job.name ~= jobName then
            return false
        end

        if type(bossGrades) == 'table' then
            for _, grade in ipairs(bossGrades) do
                if PlayerData.job.grade.name == grade then
                    return true
                end
            end
        else
            return PlayerData.job.grade.name == bossGrades
        end

    end
end

CL.IsAllowedCityhall = function(jobName, barberPointId)
    local allowed = {}
    local options = Config.Barbers[barberPointId].cityhall_grades
    if Config.Core == "ESX" then
        if PlayerData.job.name ~= jobName then
            return false
        end

        if options['resumes'] then
            if type(options['resumes']) == 'table' then
                for _, grade in ipairs(options['resumes']) do
                    if PlayerData.job.grade_name == grade then
                        allowed['resumes'] = true
                        break
                    end
                end
            else
                if PlayerData.job.grade_name == options['resumes'] then
                    allowed['resumes'] = true
                end
            end
        end

        if options['taxes'] then
            if type(options['taxes']) == 'table' then
                for _, grade in ipairs(options['taxes']) do
                    if PlayerData.job.grade_name == grade then
                        allowed['taxes'] = true
                        break
                    end
                end
            else
                if PlayerData.job.grade_name == options['taxes'] then
                    allowed['taxes'] = true
                end
            end
        end
        
    elseif Config.Core == "QB-Core" then
        if PlayerData.job.name ~= jobName then
            return false
        end

        if options['resumes'] then
            if type(options['resumes']) == 'table' then
                for _, grade in ipairs(options['resumes']) do
                    if PlayerData.job.grade.name == grade then
                        allowed['resumes'] = true
                        break
                    end
                end
            else
                if PlayerData.job.grade.name == options['resumes'] then
                    allowed['resumes'] = true
                end
            end
        end

        if options['taxes'] then
            if type(options['taxes']) == 'table' then
                for _, grade in ipairs(options['taxes']) do
                    if PlayerData.job.grade.name == grade then
                        allowed['taxes'] = true
                        break
                    end
                end
            else
                if PlayerData.job.grade.name == options['taxes'] then
                    allowed['taxes'] = true
                end
            end
        end
        
    end

    return allowed
end

CL.GetEmployees = function(cb, jobName)
    if Config.Core == "ESX" then
        ESX.TriggerServerCallback('esx_society:getEmployees', function(employees)
            cb(employees)
        end, jobName)

        -- local employees = lib.callback.await('esx_society:getEmployees', false, jobName) -- OX_LIB ESX_SOCIETY
        -- cb(employees)

    elseif Config.Core == "QB-Core" then
        QBCore.Functions.TriggerCallback('qb-bossmenu:server:GetEmployees', function(employees)
            cb(employees)
        end, jobName)
        
    end
end
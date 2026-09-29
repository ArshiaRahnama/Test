if Config.Dispatch then
    return
end

function DispatchAlertClient(property, type)
    -- Nothing
end

RegisterNetEvent('vms_housing:cl:dispatchAlert', function(propertyId, coords, alarmType)
    local hasJob = false
    
    local property = Properties[propertyId]

    if Config.Alarm.AlarmJobs then
        local myJob = CL.GetPlayerJob('name')

        if type(Config.Alarm.AlarmJobs) == 'table' then
            for _, jobName in ipairs(Config.Alarm.AlarmJobs) do
                if myJob == jobName then
                    hasJob = true
                    break
                end
            end
        else
            if myJob == Config.Alarm.AlarmJobs then
                hasJob = true
            end
        end
    end

    if hasJob then
        CL.Notification(TRANSLATE('notify.lockpick:alarm_' .. alarmType), 12000, 'dispatch')

        local blipId = #AlarmBlips + 1

        AlarmBlips[blipId] = {
            alpha = 220,
            blip = AddBlipForCoord(coords),
            radius = AddBlipForRadius(coords, 25.0),
        }

        SetBlipSprite(AlarmBlips[blipId].blip, 480)
        SetBlipDisplay(AlarmBlips[blipId].blip, 4)
        SetBlipScale(AlarmBlips[blipId].blip, 1.0)
        SetBlipColour(AlarmBlips[blipId].blip, 1)
        SetBlipAsShortRange(AlarmBlips[blipId].blip, false)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(TRANSLATE('blip.alarm'))
        EndTextCommandSetBlipName(AlarmBlips[blipId].blip)

        SetBlipHighDetail(AlarmBlips[blipId].radius, true)
        SetBlipColour(AlarmBlips[blipId].radius, 1)
        SetBlipAlpha(AlarmBlips[blipId].radius, 90)
        SetBlipAsShortRange(AlarmBlips[blipId].radius, true)

        Citizen.CreateThread(function()
            Citizen.Wait(30000)
            while AlarmBlips[blipId].alpha ~= 0 do
                AlarmBlips[blipId].alpha = AlarmBlips[blipId].alpha - 1
                SetBlipAlpha(AlarmBlips[blipId].radius, AlarmBlips[blipId].alpha)

                if AlarmBlips[blipId].alpha <= 0 then
                    RemoveBlip(AlarmBlips[blipId].radius)
                    RemoveBlip(AlarmBlips[blipId].blip)
                    AlarmBlips[blipId] = nil
                    break
                end

                Citizen.Wait(200)
            end
        end)
    end
end)


InAdminNui = false

RegisterKeyMapping('adminradial', 'Open Admin Quick Actions Radial Menu', 'keyboard', 'F7')
RegisterKeyMapping('adminreports', 'Open Admin Report Queue', 'keyboard', 'F12')

function OpenReportsMenu()
    if not aduty then return end
    ESX.TriggerServerCallback('Unique_AdminMenu:GetReports', function(reports)
        reports = reports or {}
        local options = {}

        for id, r in pairs(reports) do
            local statusIcon = r.status == 'open' and 'circle-exclamation' or 'clock'
            local statusColor = r.status == 'open' and '#c85450' or '#d6a83a'



            lib.registerContext({
                id = 'report_actions_' .. id,
                title = ('Report #%s'):format(id),
                menu = 'reports_menu',
                options = {
                    {
                        title = 'Accept Report',
                        icon = 'check',
                        iconColor = '#5fae72',
                        disabled = r.status ~= 'open',
                        onSelect = function()
                            ExecuteCommand('ar ' .. id)
                            Citizen.SetTimeout(300, OpenReportsMenu)
                        end,
                    },
                    {
                        title = 'Close Report',
                        icon = 'xmark',
                        iconColor = '#c85450',
                        disabled = r.status ~= 'pending',
                        onSelect = function()
                            ExecuteCommand('cr ' .. id)
                            Citizen.SetTimeout(300, OpenReportsMenu)
                        end,
                    },
                }
            })

            options[#options + 1] = {
                title = ('%s (id: %s) - %s'):format(r.owner and r.owner.name or 'Unknown', r.owner and r.owner.id or '?', r.category or ''),
                description = (r.Detail or '') .. '\nstatus: ' .. (r.status or 'open'),
                icon = statusIcon,
                iconColor = statusColor,
                menu = 'report_actions_' .. id,
                arrow = true,
            }
        end

        if #options == 0 then
            options[1] = { title = 'No open reports', disabled = true }
        end

        lib.registerContext({
            id = 'reports_menu',
            title = ('Report Queue (%s)'):format(#options),
            options = options,
        })
        lib.showContext('reports_menu')
    end)
end

RegisterCommand('adminreports', OpenReportsMenu, false)

RegisterCommand('adminradial', function()
    if not aduty then return end
    if InAdminNui then return end
    InAdminNui = true
    SetNuiFocus(true, true)
    SendNUIMessage({ type = 'showRadial' })
end, false)

RegisterNUICallback('closePanel', function(_, cb)
    InAdminNui = false
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('closeRadial', function(_, cb)
    InAdminNui = false
    SetNuiFocus(false, false)
    cb('ok')
end)

local function GetNearestPlayerServerId()
    local myPed = PlayerPedId()
    local myCoords = GetEntityCoords(myPed)
    local closestId, closestDist = nil, 15.0
    for _, playerId in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(playerId)
        if ped ~= myPed and DoesEntityExist(ped) then
            local dist = #(myCoords - GetEntityCoords(ped))
            if dist < closestDist then
                closestDist = dist
                closestId = GetPlayerServerId(playerId)
            end
        end
    end
    return closestId
end

RegisterNUICallback('radialAction', function(payload, cb)
    local action = payload.action

    if action == 'freeze' then
        local target = GetNearestPlayerServerId()
        if target then
            TriggerServerEvent('Unique_AdminMenu:FreezePlayer', target)
        else
            drawNotification("~r~No nearby player to freeze")
        end
    elseif action == 'heal' then
        TriggerServerEvent('Unique_AdminMenu:HealPlayer', GetPlayerServerId(PlayerId()))
    elseif action == 'revive' then
        TriggerServerEvent('Unique_AdminMenu:RevivePlayer', GetPlayerServerId(PlayerId()))
    elseif action == 'spawncar' then
        TriggerServerEvent('Unique_AdminMenu:SpawnVehicle', 'adder', '')
    elseif action == 'fixcar' then
        TriggerServerEvent('Unique_AdminMenu:VehicleAction', 'fix')
    elseif action == 'tpwp' then
        local waypoint = GetFirstBlipInfoId(8)
        if DoesBlipExist(waypoint) then
            local coords = GetBlipInfoIdCoord(waypoint)
            local groundZ = getGroundZ(coords.x, coords.y, 1000.0)
            TriggerServerEvent('Unique_AdminMenu:TeleportCoords', coords.x, coords.y, groundZ > 0 and groundZ or coords.z)
        else
            drawNotification("~r~No waypoint set on the map")
        end
    end

    InAdminNui = false
    SetNuiFocus(false, false)
    cb('ok')
end)

local lastOpenReports = 0
Citizen.CreateThread(function()
    while true do
        if aduty then
            ESX.TriggerServerCallback('Unique_AdminMenu:GetServerStats', function(stats)
                if stats then
                    SendNUIMessage({ type = 'stats', data = stats })
                    local openReports = stats.openReports or 0
                    if openReports > lastOpenReports then
                        PlaySoundFrontend(-1, "CHALLENGE_UNLOCKED", "HUD_AWARDS", true)
                        SendNUIMessage({ type = 'newReportAlert', count = openReports - lastOpenReports })
                    end
                    lastOpenReports = openReports
                end
            end)
            Citizen.Wait(8000)
        else
            lastOpenReports = 0
            Citizen.Wait(2000)
        end
    end
end)

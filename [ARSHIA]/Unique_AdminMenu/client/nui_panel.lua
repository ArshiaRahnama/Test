

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

-- Ban History Search + Unban, matching the OpenReportsMenu pattern above.
-- Permanent bans (external_ban_id set) route the unban through
-- exports.UNIQUE_AC:UnbanPlayer server-side; temp bans just get deactivated.
-- Ban Presets: consistent reason+duration for common infractions, so
-- different admins don't freehand different wordings/durations for the
-- same thing. Falls through to the same /aban command everything else uses.
function OpenBanPresetMenu(targetId)
    ESX.TriggerServerCallback('Unique_AdminMenu:GetBanPresets', function(presets)
        if not presets or #presets == 0 then return end

        local options = {}
        for _, p in ipairs(presets) do
            options[#options + 1] = {
                title = p.label,
                description = p.minutes == 0 and 'Permanent' or (p.minutes .. ' minutes'),
                icon = 'gavel',
                iconColor = '#c85450',
                onSelect = function()
                    local durArg = p.minutes == 0 and 'perm' or tostring(p.minutes)
                    ShowPunishmentConfirm(targetId, "Ban - " .. p.label, function()
                        ExecuteCommand('aban ' .. targetId .. ' ' .. durArg .. ' ' .. p.reason)
                    end)
                end,
            }
        end

        lib.registerContext({
            id = 'ban_preset_menu',
            title = 'Ban - Common Reason',
            options = options,
        })
        lib.showContext('ban_preset_menu')
    end)
end

-- Impound Yard: search + release, same pattern as OpenBanSearch above.
function OpenImpoundYard()
    if not aduty then return end
    local query = lib.inputDialog('Impound Yard Search', {
        { type = 'input', label = 'Plate or owner name', description = 'Leave empty to show the 30 most recent impounds' },
    })
    if not query then return end

    ESX.TriggerServerCallback('Unique_AdminMenu:SearchImpoundYard', function(rows)
        rows = rows or {}
        local options = {}

        for _, r in ipairs(rows) do
            options[#options + 1] = {
                title = ('%s - %s'):format(r.plate or '?', r.model_label or 'Unknown model'),
                description = ('Owner: %s\nReason: %s\nImpounded: %s (by %s)'):format(r.owner_name or '?', r.reason or '', r.impounded_at or '', r.impounded_by or '?'),
                icon = 'warehouse',
                iconColor = '#c9a24b',
                onSelect = function()
                    local alert = lib.alertDialog({
                        header = 'Release ' .. (r.plate or ''),
                        content = "Returns it to the owner's garage. Continue?",
                        centered = true,
                        cancel = true,
                    })
                    if alert == 'confirm' then
                        TriggerServerEvent('Unique_AdminMenu:ReleaseImpound', r.id)
                        Citizen.SetTimeout(300, OpenImpoundYard)
                    end
                end,
            }
        end

        if #options == 0 then
            options[1] = { title = 'No matching impounds', disabled = true }
        end

        lib.registerContext({
            id = 'impound_yard_menu',
            title = ('Impound Yard (%s)'):format(#options),
            options = options,
        })
        lib.showContext('impound_yard_menu')
    end, query[1] or '')
end

-- Character Transfer: two-identifier input + a hard confirmation step
-- (type the destination identifier again) before anything happens - this
-- moves money/bank/inventory/loadout/vehicles between two accounts.
-- Faction/Society Treasury Audit: list view + per-account history chart,
-- with a separate (higher-permission, hard-coded floor server-side)
-- Add Money action.
function OpenFactionAudit()
    ESX.TriggerServerCallback('Unique_AdminMenu:GetFactionAccounts', function(accounts)
        accounts = accounts or {}
        local options = {}

        for _, a in ipairs(accounts) do
            options[#options + 1] = {
                title = a.account_name,
                description = ('Balance: $%s'):format(a.money),
                icon = 'building-columns',
                iconColor = '#5fae72',
                menu = 'faction_actions_' .. a.account_name,
                arrow = true,
            }
            lib.registerContext({
                id = 'faction_actions_' .. a.account_name,
                title = a.account_name,
                menu = 'faction_audit_menu',
                options = {
                    {
                        title = 'View Balance History',
                        icon = 'chart-line',
                        iconColor = '#5fae72',
                        onSelect = function()
                            ESX.TriggerServerCallback('Unique_AdminMenu:GetFactionHistory', function(points)
                                SendNUIMessage({ type = 'factionchart', data = { accountName = a.account_name, points = points or {} } })
                                SetNuiFocus(true, true)
                                InAdminNui = true
                            end, a.account_name)
                        end,
                    },
                    {
                        title = '⚠ Add Money (High Rank Only)',
                        icon = 'plus',
                        iconColor = '#c9a24b',
                        onSelect = function()
                            local amount = tonumber(GetUserInput("Amount to add", "1000"))
                            local reason = GetUserInput("Reason", "") or ""
                            if amount then
                                TriggerServerEvent('Unique_AdminMenu:AddFactionMoney', a.account_name, amount, reason)
                            end
                        end,
                    },
                },
            })
        end

        if #options == 0 then
            options[1] = { title = 'No society accounts found', disabled = true }
        end

        lib.registerContext({
            id = 'faction_audit_menu',
            title = 'Faction Treasury Audit',
            options = options,
        })
        lib.showContext('faction_audit_menu')
    end)
end

function OpenCharacterTransfer()
    if not aduty then return end
    local input = lib.inputDialog('Character Transfer', {
        { type = 'input', label = 'Source identifier (data copied FROM here)', required = true },
        { type = 'input', label = 'Destination identifier (data copied TO here, overwritten)', required = true },
    })
    if not input or not input[1] or not input[2] then return end

    local srcId, destId = input[1], input[2]

    local confirmInput = lib.inputDialog('Confirm Transfer', {
        {
            type = 'input',
            label = ('Type the destination identifier again to confirm:\n%s'):format(destId),
            required = true,
        },
    })
    if not confirmInput or confirmInput[1] ~= destId then
        drawNotification("~r~Confirmation didn't match - transfer cancelled.")
        return
    end

    TriggerServerEvent('Unique_AdminMenu:TransferCharacter', srcId, destId)
end

-- Confirmation card for irreversible/high-impact actions (ban/kick/jail):
-- shows the target's name, job, permission level, Trust Score, warning/ban
-- count, and flag status in one glance before the action actually runs -
-- catches "wrong target" and "didn't know they already had 3 warnings"
-- mistakes before they happen, not after.
function ShowPunishmentConfirm(targetId, actionLabel, onConfirm)
    ESX.TriggerServerCallback('Unique_AdminMenu:GetConfirmSummary', function(data)
        if not data then
            drawNotification("~r~Could not load that player's info - action cancelled.")
            return
        end

        local trustColor = data.trustScore >= 80 and 'Good' or data.trustScore >= 50 and 'Mixed' or 'Poor'
        local content = ("**%s** (id: %s)\nJob: %s | Permission: %s\n\n**Trust Score: %s/100** (%s)\n%s warnings &middot; %s prior bans"):format(
            data.name, targetId, data.job, data.permission_level, data.trustScore, trustColor, data.warnings, data.bans)

        if data.flagNote then
            content = content .. ("\n\n🚩 **FLAGGED:** %s"):format(data.flagNote)
        end

        local alert = lib.alertDialog({
            header = actionLabel .. ' - Confirm Target',
            content = content,
            centered = true,
            cancel = true,
        })
        if alert == 'confirm' then
            onConfirm()
        end
    end, targetId)
end

function OpenBanSearch()
    if not aduty then return end
    local query = lib.inputDialog('Ban History Search', {
        { type = 'input', label = 'Player name or identifier', description = 'Leave empty to show the 25 most recent active bans' },
    })
    if not query then return end

    ESX.TriggerServerCallback('Unique_AdminMenu:SearchBans', function(rows)
        rows = rows or {}
        local options = {}

        for _, r in ipairs(rows) do
            local isPermanent = r.expire_at == nil
            options[#options + 1] = {
                title = ('%s (%s)'):format(r.playername or 'Unknown', isPermanent and 'PERMANENT' or 'temp'),
                description = ('Reason: %s\nBy: %s\nRecord #%s'):format(r.reason or '', r.admin_name or '?', r.id),
                icon = 'gavel',
                iconColor = '#c85450',
                onSelect = function()
                    local alert = lib.alertDialog({
                        header = 'Unban ' .. (r.playername or r.identifier or ''),
                        content = 'This will lift the ban immediately. Continue?',
                        centered = true,
                        cancel = true,
                    })
                    if alert == 'confirm' then
                        ExecuteCommand('aunban ' .. r.id)
                        Citizen.SetTimeout(300, OpenBanSearch)
                    end
                end,
            }
        end

        if #options == 0 then
            options[1] = { title = 'No matching active bans', disabled = true }
        end

        lib.registerContext({
            id = 'ban_search_menu',
            title = ('Ban History (%s)'):format(#options),
            options = options,
        })
        lib.showContext('ban_search_menu')
    end, query[1] or '')
end

RegisterCommand('adminbans', OpenBanSearch, false)

-- Duty History Search: real persistent sessions from server/duty_log.lua,
-- same search-dialog pattern as OpenBanSearch above.
function OpenDutyHistory()
    if not aduty then return end

    ESX.TriggerServerCallback('Unique_AdminMenu:GetAdminNameList', function(names)
        names = names or {}
        local selectOptions = { { value = '', label = 'All Admins (30 most recent sessions)' } }
        for _, n in ipairs(names) do
            selectOptions[#selectOptions + 1] = { value = n.name, label = n.name }
        end

        local input = lib.inputDialog('Duty History Search', {
            { type = 'select', label = 'Admin', options = selectOptions, default = '' },
        })
        if not input or not input[1] then return end
        local query = input[1]

        ESX.TriggerServerCallback('Unique_AdminMenu:GetDutyHistory', function(rows)
            rows = rows or {}
            local options = {}

            for _, r in ipairs(rows) do
                local duration = r.totaltime and (r.totaltime .. ' min') or '-'
                options[#options + 1] = {
                    title = ('%s'):format(r.name or r.identifier or 'Unknown'),
                    description = ('%s -> %s (%s)'):format(r.onTimeStr or '?', r.offTimeStr or '?', duration),
                    icon = 'user-clock',
                    iconColor = r.offduty and '#5fae72' or '#c9a24b',
                    disabled = true,
                }
            end

            if #options == 0 then
                options[1] = { title = 'No matching duty sessions', disabled = true }
            end

            lib.registerContext({
                id = 'duty_history_menu',
                title = ('Duty History (%s)'):format(#options),
                options = options,
            })
            lib.showContext('duty_history_menu')
        end, query)
    end)
end

RegisterCommand('adminduty', OpenDutyHistory, false)

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

RegisterNUICallback('setButtonPerm', function(payload, cb)
    if payload and payload.id then
        TriggerServerEvent('Unique_AdminMenu:SetButtonPerm', payload.id, payload.level)
    end
    cb('ok')
end)

-- ------------------------------------------------------- BAN APPEALS ---
-- Deliberately NOT a new appeal system - UNIQUE_AC already has one
-- (uniqueac_appeals table + its own external "Central Hub" website where
-- banned players actually submit appeals, since they're banned and can't
-- get in-game). This reads/writes the SAME uniqueac_appeals data, just
-- through our own server events (server/appeals.lua) instead of
-- UNIQUE_AC:getAppeals/reviewAppeal directly - those gate on UNIQUE_AC's
-- own separate admin check, which could silently no-op for an admin who's
-- fine in OUR permission system but not set up on UNIQUE_AC's side. Same
-- underlying data either way, just one permission system instead of two
-- that can disagree.

function OpenBanAppeals()
    ESX.TriggerServerCallback('Unique_AdminMenu:GetPendingAppeals', function(rows)
        rows = rows or {}
        local options = {}

        for _, a in ipairs(rows) do
            options[#options + 1] = {
                title = a.player_name or a.identifier or ('Appeal #' .. a.id),
                description = a.message or '',
                icon = 'scale-balanced',
                iconColor = '#c9a24b',
                menu = 'appeal_actions_' .. a.id,
                arrow = true,
            }
            lib.registerContext({
                id = 'appeal_actions_' .. a.id,
                title = a.player_name or a.identifier or ('Appeal #' .. a.id),
                menu = 'ban_appeals_menu',
                options = {
                    {
                        title = 'Approve (Unban)',
                        icon = 'check',
                        iconColor = '#5fae72',
                        onSelect = function()
                            TriggerServerEvent('Unique_AdminMenu:ReviewAppeal', a.id, true)
                            Citizen.SetTimeout(500, OpenBanAppeals)
                        end,
                    },
                    {
                        title = 'Reject',
                        icon = 'xmark',
                        iconColor = '#c85450',
                        onSelect = function()
                            TriggerServerEvent('Unique_AdminMenu:ReviewAppeal', a.id, false)
                            Citizen.SetTimeout(500, OpenBanAppeals)
                        end,
                    },
                },
            })
        end

        if #options == 0 then
            options[1] = { title = 'No pending appeals', disabled = true }
        end

        lib.registerContext({
            id = 'ban_appeals_menu',
            title = ('Ban Appeals (%s pending)'):format(#rows),
            options = options,
        })
        lib.showContext('ban_appeals_menu')
    end)
end

-- ----------------------------------------------------- REPORT RATING ---
RegisterNetEvent('Unique_AdminMenu:AskReportRating')
AddEventHandler('Unique_AdminMenu:AskReportRating', function(reportId, closerName)
    lib.registerContext({
        id = 'report_rating_menu',
        title = 'How was the response to your report?',
        options = {
            {
                title = '😊 Satisfied',
                icon = 'face-smile',
                iconColor = '#5fae72',
                onSelect = function() TriggerServerEvent('Unique_AdminMenu:SubmitReportRating', reportId, 3, closerName) end,
            },
            {
                title = '😐 Neutral',
                icon = 'face-meh',
                iconColor = '#c9a24b',
                onSelect = function() TriggerServerEvent('Unique_AdminMenu:SubmitReportRating', reportId, 2, closerName) end,
            },
            {
                title = '😞 Unsatisfied',
                icon = 'face-frown',
                iconColor = '#c85450',
                onSelect = function() TriggerServerEvent('Unique_AdminMenu:SubmitReportRating', reportId, 1, closerName) end,
            },
        },
    })
    lib.showContext('report_rating_menu')
end)

function OpenButtonPermsPanel()
    ESX.TriggerServerCallback('Unique_AdminMenu:GetButtonPermsPanel', function(data)
        SendNUIMessage({ type = 'buttonperms', data = data })
        SetNuiFocus(true, true)
        InAdminNui = true
    end)
end

function OpenEconomyChart()
    ESX.TriggerServerCallback('Unique_AdminMenu:GetEconomyHistory', function(points)
        SendNUIMessage({ type = 'economychart', data = { points = points or {} } })
        SetNuiFocus(true, true)
        InAdminNui = true
    end)
end

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

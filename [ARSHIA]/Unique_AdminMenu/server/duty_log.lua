-- Persistent admin duty log: real start/end timestamps in the DB, so it
-- survives resource restarts (unlike DutySessionStart in admin_tag.lua,
-- which only backs the live Staff Dashboard). Hooked into the same
-- esx_aduty:ChangeMenuStatus signal admin_tag.lua already listens for.

local function GoOnDuty(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    local identifier = xPlayer.identifier
    local playerName = GetPlayerName(source)
    local today = os.date("%Y-%m-%d")

    MySQL.Async.fetchScalar('SELECT onduty FROM admin_duty WHERE identifier = @id AND offduty IS NULL ORDER BY onduty DESC LIMIT 1', {
        ['@id'] = identifier
    }, function(result)
        if not result then
            MySQL.Async.execute('INSERT INTO admin_duty (name, identifier, date, onduty) VALUES (@name, @id, @date, @time)', {
                ['@name'] = playerName, ['@id'] = identifier, ['@date'] = today, ['@time'] = os.time(),
            })
        end
    end)
end

local function GoOffDuty(identifier, source)
    local endTime = os.time()
    local MIN_DURATION_SECONDS = 60

    MySQL.Async.fetchScalar('SELECT onduty FROM admin_duty WHERE identifier = @id AND offduty IS NULL ORDER BY onduty DESC LIMIT 1', {
        ['@id'] = identifier
    }, function(startTime)
        if not startTime then return end
        local durationSeconds = endTime - startTime

        if durationSeconds < MIN_DURATION_SECONDS then
            -- Too short to bother keeping (e.g. an accidental duty toggle).
            MySQL.Async.execute('DELETE FROM admin_duty WHERE identifier = @id AND offduty IS NULL', { ['@id'] = identifier })
        else
            local totalMinutes = math.floor(durationSeconds / 60)
            MySQL.Async.execute('UPDATE admin_duty SET offduty = @endTime, totaltime = @totalMinutes WHERE identifier = @id AND onduty = @startTime', {
                ['@endTime'] = endTime, ['@totalMinutes'] = totalMinutes, ['@id'] = identifier, ['@startTime'] = startTime,
            })
        end
    end)
end

RegisterServerEvent('Unique_AdminMenu:DutyLogToggle')
AddEventHandler('Unique_AdminMenu:DutyLogToggle', function(isOnDuty)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    if isOnDuty then
        GoOnDuty(source)
    else
        GoOffDuty(xPlayer.identifier, source)
    end
end)

AddEventHandler('playerDropped', function()
    -- Force-close any open session so a disconnect-while-on-duty doesn't
    -- leave a dangling row forever.
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        GoOffDuty(xPlayer.identifier, source)
    end
end)

ESX.RegisterServerCallback('Unique_AdminMenu:GetDutyHistory', function(source, cb, query)
    if not IsOnDutyAdminFor(source, 'btn_dutyhist') then cb({}) return end
    query = tostring(query or ''):sub(1, 60)
    MySQL.Async.fetchAll(
        "SELECT `name`, `identifier`, `date`, `onduty`, `offduty`, `totaltime` FROM `admin_duty` WHERE `name` LIKE @q ORDER BY `onduty` DESC LIMIT 30",
        { ['@q'] = '%' .. query .. '%' },
        function(rows)
            rows = rows or {}
            -- `os` isn't available client-side in FiveM, so format the
            -- display strings here (server-side) instead of asking the
            -- client to call os.date on the raw timestamps.
            for _, r in ipairs(rows) do
                r.onTimeStr = r.onduty and os.date('%Y-%m-%d %H:%M', r.onduty) or '?'
                r.offTimeStr = r.offduty and os.date('%H:%M', r.offduty) or 'still on duty'
            end
            cb(rows)
        end
    )
end)

-- Distinct admin names that have ever logged a duty session, for the
-- Duty History Search dropdown (pick a name instead of typing it).
ESX.RegisterServerCallback('Unique_AdminMenu:GetAdminNameList', function(source, cb)
    if not IsOnDutyAdminFor(source, 'btn_dutyhist') then cb({}) return end
    MySQL.Async.fetchAll(
        "SELECT DISTINCT `name` FROM `admin_duty` WHERE `name` IS NOT NULL ORDER BY `name` ASC",
        {}, function(rows) cb(rows or {}) end
    )
end)

-- ------------------------------------------------------- PLAYER FLAGS ---
-- Persistent, keeps actively reminding every on-duty admin in chat every
-- 5s for as long as the flagged player is online - unlike a regular note,
-- which only shows up when someone opens Inspect on them.

RegisterServerEvent('Unique_AdminMenu:SetFlag')
AddEventHandler('Unique_AdminMenu:SetFlag', function(targetId, note)
    local source = source
    if not IsOnDutyAdmin(source) then return end
    local Target = ESX.GetPlayerFromId(tonumber(targetId))
    if not Target then return end
    note = tostring(note or ''):sub(1, 255)
    if note == '' then return end

    MySQL.Async.execute(
        "INSERT INTO `admin_player_flags` (`identifier`, `note`, `admin_name`, `created_at`) VALUES (@identifier, @note, @admin, @createdat) ON DUPLICATE KEY UPDATE `note` = @note, `admin_name` = @admin, `created_at` = @createdat",
        { ['@identifier'] = Target.identifier, ['@note'] = note, ['@admin'] = GetPlayerName(source), ['@createdat'] = os.date('%Y-%m-%d %H:%M:%S') }
    )
    LogAdminAction(source, "flag-player", ("target: %s | note: %s"):format(GetPlayerName(targetId), note), Target.identifier, GetPlayerName(targetId))
    TriggerClientEvent('esx:showNotification', source, "~b~Player flagged - on-duty admins will be reminded while they're online.")
end)

RegisterServerEvent('Unique_AdminMenu:ClearFlag')
AddEventHandler('Unique_AdminMenu:ClearFlag', function(targetId)
    local source = source
    if not IsOnDutyAdmin(source) then return end
    local Target = ESX.GetPlayerFromId(tonumber(targetId))
    if not Target then return end

    MySQL.Async.execute("DELETE FROM `admin_player_flags` WHERE `identifier` = @identifier", { ['@identifier'] = Target.identifier })
    LogAdminAction(source, "unflag-player", ("target: %s"):format(GetPlayerName(targetId)), Target.identifier, GetPlayerName(targetId))
end)

-- Only pings chat ONCE, when a flagged player connects - not on a
-- repeating timer. A repeating ping (the original design) spams every
-- on-duty admin every 5s for every flagged player online, drowns out real
-- chat fast, and just trains people to ignore it. The persistent,
-- always-visible part now lives in the Online Players panel and Inspect
-- instead (see GetOnlinePlayers/InspectPlayer below) - open either any
-- time to see who's flagged.
AddEventHandler('esx:playerLoaded', function(playerId)
    Citizen.SetTimeout(3000, function()
        local xPlayer = ESX.GetPlayerFromId(playerId)
        if not xPlayer then return end

        MySQL.Async.fetchAll('SELECT note, admin_name FROM admin_player_flags WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier
        }, function(rows)
            local flag = rows and rows[1]
            if not flag then return end

            for _, src in ipairs(ESX.GetPlayers()) do
                if IsOnDutyAdmin(src) then
                    TriggerClientEvent('chat:addMessage', src, {
                        color = { 255, 165, 0 },
                        args = { "[FLAG]", ("%s (id:%s) just connected - %s (by %s)"):format(GetPlayerName(playerId), playerId, flag.note, flag.admin_name) },
                    })
                end
            end
        end)
    end)
end)

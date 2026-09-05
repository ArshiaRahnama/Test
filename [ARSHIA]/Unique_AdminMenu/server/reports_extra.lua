-- ----------------------------------------------------- REPORT RATINGS ---
-- Fired by the small addition to esx_aduty/Server/ReportMenu_sv.lua's `cr`
-- command whenever a report gets closed. Asks the ORIGINAL REPORTER
-- (everyone has this resource loaded, not just admins, so ox_lib is
-- available to them too) how the response was.

AddEventHandler('Unique_AdminMenu:ReportClosed', function(reporterId, reportId, closerName, openedAt)
    reporterId = tonumber(reporterId)

    -- Response-time tracking: independent of whether the reporter is even
    -- still online, so this runs before the online-check below.
    openedAt = tonumber(openedAt)
    if openedAt and openedAt > 0 then
        local responseSeconds = os.time() - openedAt
        if responseSeconds >= 0 then
            MySQL.Async.execute(
                "INSERT INTO `admin_report_response_times` (`admin_name`, `response_seconds`, `created_at`) VALUES (@admin, @seconds, @createdat)",
                { ['@admin'] = closerName, ['@seconds'] = responseSeconds, ['@createdat'] = os.date('%Y-%m-%d %H:%M:%S') }
            )
        end
    end

    if not reporterId or not GetPlayerName(reporterId) then return end -- reporter already disconnected

    Citizen.SetTimeout(1500, function()
        if GetPlayerName(reporterId) then -- still online a moment later
            TriggerClientEvent('Unique_AdminMenu:AskReportRating', reporterId, reportId, closerName)
        end
    end)
end)

RegisterServerEvent('Unique_AdminMenu:SubmitReportRating')
AddEventHandler('Unique_AdminMenu:SubmitReportRating', function(reportId, rating, adminName)
    rating = tonumber(rating)
    if not rating or rating < 1 or rating > 3 then return end

    MySQL.Async.execute(
        "INSERT INTO `admin_report_ratings` (`report_id`, `admin_name`, `rating`, `created_at`) VALUES (@rid, @admin, @rating, @createdat)",
        { ['@rid'] = tostring(reportId), ['@admin'] = adminName, ['@rating'] = rating, ['@createdat'] = os.date('%Y-%m-%d %H:%M:%S') }
    )
end)

ESX.RegisterServerCallback('Unique_AdminMenu:GetReportSatisfaction', function(source, cb)
    if not IsOnDutyAdmin(source) then cb({}) return end
    MySQL.Async.fetchAll(
        "SELECT `admin_name`, AVG(`rating`) AS avg_rating, COUNT(*) AS cnt FROM `admin_report_ratings` GROUP BY `admin_name` ORDER BY avg_rating DESC",
        {}, function(rows) cb(rows or {}) end
    )
end)

-- --------------------------------------------------- NEW PLAYER ALERT ---
-- Posts to on-duty admins in chat when someone's `users` row was created
-- within the last few minutes - i.e. they just made their account/character,
-- not based on `playtime` (which isn't reliably updated by everything on
-- this server).

AddEventHandler('esx:playerLoaded', function(playerId)
    Citizen.SetTimeout(4000, function()
        local xPlayer = ESX.GetPlayerFromId(playerId)
        if not xPlayer then return end

        MySQL.Async.fetchScalar("SELECT TIMESTAMPDIFF(MINUTE, `created_at`, NOW()) FROM `users` WHERE `identifier` = @id", {
            ['@id'] = xPlayer.identifier
        }, function(minutesSinceCreated)
            if minutesSinceCreated == nil or minutesSinceCreated > 5 then return end -- account existed before now, not a fresh signup

            local name = GetPlayerName(playerId)
            for _, src in ipairs(ESX.GetPlayers()) do
                if IsOnDutyAdmin(src) then
                    TriggerClientEvent('chat:addMessage', src, {
                        color = { 90, 200, 140 },
                        args = { "[BAZIKON JADID]", ("%s (id:%s) Taze Akaunt Sakht - Alan Avalin Bareshe Vasl Shode!"):format(name, playerId) },
                    })
                end
            end
        end)
    end)
end)

-- --------------------------------------------------- RESPONSE TIMES ---

ESX.RegisterServerCallback('Unique_AdminMenu:GetResponseTimes', function(source, cb)
    if not IsOnDutyAdmin(source) then cb({}) return end
    MySQL.Async.fetchAll(
        "SELECT `admin_name`, AVG(`response_seconds`) AS avg_seconds, COUNT(*) AS cnt FROM `admin_report_response_times` GROUP BY `admin_name` ORDER BY avg_seconds ASC",
        {}, function(rows) cb(rows or {}) end
    )
end)

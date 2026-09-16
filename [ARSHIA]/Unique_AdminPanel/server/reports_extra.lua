-- ----------------------------------------------------- REPORT RATINGS ---
-- Fired by the small addition to esx_aduty/Server/ReportMenu_sv.lua's `cr`
-- command whenever a report gets closed. Asks the ORIGINAL REPORTER
-- (everyone has this resource loaded, not just admins, so ox_lib is
-- available to them too) how the response was.

-- NOTE (Unique Report System): this handler used to do two things that the
-- report system now owns itself, and doing them twice corrupted the stats:
--
--   1. INSERT into `admin_report_response_times`. server/report_main.lua's
--      CloseReport() already writes that row, so every closed report was
--      counted TWICE and the "average response time" per admin was computed
--      over duplicated samples.
--   2. TriggerClientEvent('Unique_AdminPanel:AskReportRating', ...) - an
--      ox_lib prompt that fired on top of the report system's own rating
--      card, so the reporter got asked to rate the same report twice, and
--      a second row landed in `admin_report_ratings`.
--
-- Both are removed. The event is kept (other files may listen to it) and the
-- SubmitReportRating handler below is kept for backwards compatibility with
-- anything still calling it directly.

RegisterServerEvent('Unique_AdminPanel:SubmitReportRating')
AddEventHandler('Unique_AdminPanel:SubmitReportRating', function(reportId, rating, adminName)
    rating = tonumber(rating)
    if not rating or rating < 1 or rating > 5 then return end -- 1..5 (سیستم جدید ۵ ستاره‌ای است)

    MySQL.Async.execute(
        "INSERT INTO `admin_report_ratings` (`report_id`, `admin_name`, `rating`, `created_at`) VALUES (@rid, @admin, @rating, @createdat)",
        { ['@rid'] = tostring(reportId), ['@admin'] = adminName, ['@rating'] = rating, ['@createdat'] = os.date('%Y-%m-%d %H:%M:%S') }
    )
end)

RegisterServerCallbackSafe('Unique_AdminPanel:GetReportSatisfaction', function(source, cb)
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

RegisterServerCallbackSafe('Unique_AdminPanel:GetResponseTimes', function(source, cb)
    if not IsOnDutyAdmin(source) then cb({}) return end
    MySQL.Async.fetchAll(
        "SELECT `admin_name`, AVG(`response_seconds`) AS avg_seconds, COUNT(*) AS cnt FROM `admin_report_response_times` GROUP BY `admin_name` ORDER BY avg_seconds ASC",
        {}, function(rows) cb(rows or {}) end
    )
end)

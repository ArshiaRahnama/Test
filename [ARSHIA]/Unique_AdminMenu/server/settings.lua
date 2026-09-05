-- ------------------------------------------------------ ECONOMY CHART ---

-- Server-side mirror of client/general_utils.lua's ButtonCatalog (labels
-- shown in the NUI settings panel come from here, not the client, so a
-- non-admin can't tamper with what the panel displays).
ButtonCatalogServer = {
    { id = 'btn_ban',        label = 'Ban (minutes)',              category = 'Punishment' },
    { id = 'btn_ban_preset', label = 'Ban (Common Reason)',         category = 'Punishment' },
    { id = 'btn_unban',      label = 'Ban History Search / Unban',  category = 'Punishment' },
    { id = 'btn_kick',       label = 'Kick',                        category = 'Punishment' },
    { id = 'btn_jail',       label = 'Send to Jail',                category = 'Punishment' },
    { id = 'btn_cs',         label = 'Send to Community Service',   category = 'Punishment' },
    { id = 'btn_godmode',    label = 'Toggle God Mode (Target)',    category = 'Player Control' },
    { id = 'btn_givemoney',  label = 'Give Money',                  category = 'Economy' },
    { id = 'btn_setmoney',   label = 'Remove Money',                category = 'Economy' },
    { id = 'btn_clearinv',   label = 'Clear Inventory',             category = 'Player Control' },
    { id = 'btn_spawnveh',   label = 'Spawn Vehicle',                category = 'Vehicle' },
    { id = 'btn_weather',    label = 'Set Weather',                  category = 'World' },
    { id = 'btn_time',       label = 'Set Time',                     category = 'World' },
    { id = 'btn_impound',    label = 'Impound Vehicle',              category = 'Vehicle' },
    { id = 'btn_impound_yard', label = 'Impound Yard (Search / Release)', category = 'Vehicle' },
    { id = 'btn_restart',    label = 'Restart Resource',             category = 'Server' },
    { id = 'btn_bulk',       label = 'Bulk Actions (All Players)',   category = 'Server' },
    { id = 'btn_dutyhist',   label = 'Duty History Search',          category = 'Server' },
    { id = 'btn_appeals',    label = 'Review Ban Appeals',           category = 'Punishment' },
    { id = 'btn_transfer',   label = 'Character Transfer (Support)', category = 'Server' },
    { id = 'btn_faction',    label = 'Faction Treasury Audit',        category = 'Economy' },
}

local function TakeEconomySnapshot()
    MySQL.Async.fetchAll("SELECT SUM(`money`) AS cash, SUM(`bank`) AS bank, COUNT(*) AS cnt FROM `users`", {}, function(rows)
        local row = rows and rows[1]
        if not row then return end
        MySQL.Async.execute(
            "INSERT INTO `admin_economy_snapshots` (`taken_at`, `total_cash`, `total_bank`, `player_count`) VALUES (@t, @cash, @bank, @cnt)",
            { ['@t'] = os.time(), ['@cash'] = row.cash or 0, ['@bank'] = row.bank or 0, ['@cnt'] = row.cnt or 0 }
        )
    end)
end

Citizen.CreateThread(function()
    Citizen.Wait(60000) -- let the DB/ESX settle after a fresh restart
    TakeEconomySnapshot()
    while true do
        Citizen.Wait(30 * 60 * 1000) -- every 30 minutes
        TakeEconomySnapshot()
    end
end)

ESX.RegisterServerCallback('Unique_AdminMenu:GetEconomyHistory', function(source, cb)
    if not IsOnDutyAdmin(source) then cb({}) return end
    MySQL.Async.fetchAll(
        "SELECT `taken_at`, `total_cash`, `total_bank`, `player_count` FROM `admin_economy_snapshots` ORDER BY `taken_at` ASC LIMIT 200",
        {}, function(rows) cb(rows or {}) end
    )
end)

-- ------------------------------------------------------- BUTTON PERMS ---

ESX.RegisterServerCallback('Unique_AdminMenu:GetButtonPermsPanel', function(source, cb)
    if not IsOnDutyAdmin(source) then cb({ catalog = {}, perms = {}, defaultLevel = Config.MinPermissionLevel }) return end
    MySQL.Async.fetchAll('SELECT button_id, min_level FROM admin_button_perms', {}, function(rows)
        local perms = {}
        for _, r in ipairs(rows or {}) do perms[r.button_id] = r.min_level end
        cb({ catalog = ButtonCatalogServer, perms = perms, defaultLevel = Config.MinPermissionLevel })
    end)
end)

-- ----------------------------------------------------- ADMIN LEADERBOARD ---
-- Posts a weekly "who did the most this week" summary to Discord, reusing
-- the same shared logging channel LogAdminAction already uses.

local function PostWeeklyLeaderboard()
    local weekAgo = os.time() - (7 * 24 * 60 * 60)

    MySQL.Async.fetchAll(
        "SELECT `name`, SUM(COALESCE(`totaltime`, 0)) AS minutes FROM `admin_duty` WHERE `onduty` >= @weekago GROUP BY `name` ORDER BY minutes DESC LIMIT 10",
        { ['@weekago'] = weekAgo },
        function(dutyRows)
            MySQL.Async.fetchAll(
                "SELECT `admin_name`, COUNT(*) AS cnt FROM `admin_action_log` WHERE UNIX_TIMESTAMP(`created_at`) >= @weekago GROUP BY `admin_name` ORDER BY cnt DESC LIMIT 10",
                { ['@weekago'] = weekAgo },
                function(actionRows)
                    if (not dutyRows or #dutyRows == 0) and (not actionRows or #actionRows == 0) then return end

                    local actionsByName = {}
                    for _, r in ipairs(actionRows or {}) do actionsByName[r.admin_name] = r.cnt end

                    local lines = {}
                    for i, r in ipairs(dutyRows or {}) do
                        lines[#lines + 1] = ("%d. **%s** - %dh %dm on duty, %d actions"):format(
                            i, r.name, math.floor(r.minutes / 60), r.minutes % 60, actionsByName[r.name] or 0)
                    end

                    local description = #lines > 0 and table.concat(lines, "\n") or "No duty sessions logged this week."

                    TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'Weekly Admin Leaderboard', description, 'user', true, nil, false)

                    if Config.DiscordWebhook ~= "" then
                        PerformHttpRequest(Config.DiscordWebhook, function() end, 'POST',
                            json.encode({ username = "Admin Leaderboard", embeds = { { title = "📊 Weekly Admin Leaderboard", type = "rich", color = 3447003, description = description } } }),
                            { ['Content-Type'] = 'application/json' })
                    end
                end
            )
        end
    )
end

Citizen.CreateThread(function()
    while true do
        -- Wait until the next real-world Monday 09:00 server time, then
        -- repeat every 7 days from there.
        local now = os.date("*t")
        local daysUntilMonday = (8 - now.wday) % 7 -- os.date wday: 1=Sunday..7=Saturday
        if daysUntilMonday == 0 and now.hour >= 9 then daysUntilMonday = 7 end
        local target = os.time({ year = now.year, month = now.month, day = now.day, hour = 9, min = 0, sec = 0 }) + daysUntilMonday * 86400
        local waitSeconds = target - os.time()
        Citizen.Wait(math.max(waitSeconds, 60) * 1000)
        PostWeeklyLeaderboard()
        Citizen.Wait(7 * 24 * 60 * 60 * 1000)
    end
end)

-- Manual trigger too, for testing or an off-schedule report.
RegisterCommand('adminleaderboard', function(source)
    if not IsOnDutyAdmin(source) then return end
    PostWeeklyLeaderboard()
    TriggerClientEvent('esx:showNotification', source, "~g~Leaderboard posted to Discord.")
end, false)

-- --------------------------------------------------- TARGETED MESSAGE ---

RegisterCommand('ajobmsg', function(source, args)
    if not IsOnDutyAdmin(source) then return end
    local jobName = args[1]
    local message = table.concat(args, ' ', 2)
    if not jobName or message == '' then
        TriggerClientEvent('esx:showNotification', source, "~r~Usage: /ajobmsg <job_name> <message>")
        return
    end

    local sent = 0
    for _, playerId in ipairs(ESX.GetPlayers()) do
        local xPlayer = ESX.GetPlayerFromId(playerId)
        if xPlayer and xPlayer.job and xPlayer.job.name == jobName then
            TriggerClientEvent('chat:addMessage', playerId, {
                color = { 90, 160, 220 },
                args = { ("[%s ANNOUNCEMENT]"):format(string.upper(jobName)), message },
            })
            sent = sent + 1
        end
    end

    LogAdminAction(source, "job-message", ("job: %s | sent to: %s | %s"):format(jobName, sent, message))
    TriggerClientEvent('esx:showNotification', source, ("~g~Sent to %s player(s) with job '%s'."):format(sent, jobName))
end, false)

RegisterCommand('agangmsg', function(source, args)
    if not IsOnDutyAdmin(source) then return end
    local gangName = args[1]
    local message = table.concat(args, ' ', 2)
    if not gangName or message == '' then
        TriggerClientEvent('esx:showNotification', source, "~r~Usage: /agangmsg <gang_name> <message>")
        return
    end

    local sent = 0
    for _, playerId in ipairs(ESX.GetPlayers()) do
        local xPlayer = ESX.GetPlayerFromId(playerId)
        if xPlayer and xPlayer.gang and xPlayer.gang.name == gangName then
            TriggerClientEvent('chat:addMessage', playerId, {
                color = { 200, 90, 160 },
                args = { ("[%s ANNOUNCEMENT]"):format(string.upper(gangName)), message },
            })
            sent = sent + 1
        end
    end

    LogAdminAction(source, "gang-message", ("gang: %s | sent to: %s | %s"):format(gangName, sent, message))
    TriggerClientEvent('esx:showNotification', source, ("~g~Sent to %s player(s) in gang '%s'."):format(sent, gangName))
end, false)

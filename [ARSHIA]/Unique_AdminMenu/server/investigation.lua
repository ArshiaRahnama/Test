-- Voice proximity: continuously tracks everyone's last-known coordinates
-- server-side, so an admin can ask "who was in voice range of X" when
-- investigating a report where the audio wasn't recorded/heard directly.
-- Position snapshots refresh every 5s - good enough for "who was nearby
-- around the time of the report", not frame-perfect.

PositionSnapshots = {} -- source -> { x, y, z, updated_at }

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        for _, playerId in ipairs(ESX.GetPlayers()) do
            local ped = GetPlayerPed(playerId)
            if ped and ped ~= 0 then
                local coords = GetEntityCoords(ped)
                PositionSnapshots[playerId] = { x = coords.x, y = coords.y, z = coords.z, updated_at = os.time() }
            end
        end
    end
end)

AddEventHandler('playerDropped', function()
    PositionSnapshots[source] = nil
end)

-- Default in-game voice range is ~15-20m depending on the voice resource's
-- config; 20m is a reasonable default guess for "could plausibly have
-- heard them".
ESX.RegisterServerCallback('Unique_AdminMenu:GetVoiceProximity', function(source, cb, targetId, range)
    if not IsOnDutyAdmin(source) then cb({}) return end
    targetId = tonumber(targetId)
    range = tonumber(range) or 20.0

    local targetPos = PositionSnapshots[targetId]
    if not targetPos then cb({}) return end

    local nearby = {}
    for _, playerId in ipairs(ESX.GetPlayers()) do
        if playerId ~= targetId then
            local pos = PositionSnapshots[playerId]
            if pos then
                local dist = math.sqrt((pos.x - targetPos.x) ^ 2 + (pos.y - targetPos.y) ^ 2 + (pos.z - targetPos.z) ^ 2)
                if dist <= range then
                    nearby[#nearby + 1] = {
                        id = playerId,
                        name = GetPlayerName(playerId),
                        distance = math.floor(dist * 10) / 10,
                        ageSeconds = os.time() - pos.updated_at,
                    }
                end
            end
        end
    end
    table.sort(nearby, function(a, b) return a.distance < b.distance end)
    cb(nearby)
end)

-- ------------------------------------------------- MONEY SPIKE SCANNER ---
-- Snapshots everyone's cash+bank periodically; if someone's total jumps by
-- more than Config.MoneySpikeThreshold within one interval, auto-flags
-- them (reuses the existing flag system - shows up in Online Players,
-- Inspect, and pings on-duty admins once when they next connect).

local Config_MoneySpike = {
    CheckIntervalMs = 5 * 60 * 1000, -- every 5 minutes
    Threshold = 500000, -- flag if total wealth jumps more than this in one interval
}

local LastKnownTotal = {} -- identifier -> total

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config_MoneySpike.CheckIntervalMs)

        for _, playerId in ipairs(ESX.GetPlayers()) do
            local xPlayer = ESX.GetPlayerFromId(playerId)
            if xPlayer then
                local money = xPlayer.getMoney and xPlayer.getMoney() or xPlayer.money or 0
                local bank = (xPlayer.getAccount and xPlayer.getAccount('bank') and xPlayer.getAccount('bank').money) or xPlayer.bank or 0
                local total = money + bank
                local last = LastKnownTotal[xPlayer.identifier]

                if last and (total - last) > Config_MoneySpike.Threshold then
                    local note = ("Auto-flag: wealth jumped +%s in <=5min (possible dupe/exploit)"):format(total - last)
                    MySQL.Async.execute(
                        "INSERT INTO `admin_player_flags` (`identifier`, `note`, `admin_name`, `created_at`) VALUES (@identifier, @note, @admin, @createdat) ON DUPLICATE KEY UPDATE `note` = @note, `admin_name` = @admin, `created_at` = @createdat",
                        { ['@identifier'] = xPlayer.identifier, ['@note'] = note, ['@admin'] = 'SYSTEM', ['@createdat'] = os.date('%Y-%m-%d %H:%M:%S') }
                    )
                    for _, src in ipairs(ESX.GetPlayers()) do
                        if IsOnDutyAdmin(src) then
                            TriggerClientEvent('chat:addMessage', src, {
                                color = { 255, 80, 80 },
                                args = { "[MONEY SPIKE]", ("%s (id:%s): %s"):format(GetPlayerName(playerId), playerId, note) },
                            })
                        end
                    end
                    print(("[Unique_AdminMenu] SYSTEM auto-flag: %s (id:%s) -> %s"):format(GetPlayerName(playerId), playerId, note))
                end

                LastKnownTotal[xPlayer.identifier] = total
            end
        end
    end
end)

AddEventHandler('playerDropped', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then LastKnownTotal[xPlayer.identifier] = nil end
end)

-- ------------------------------------------------- OLD FLAG CLEANUP ---
-- Auto-clears flags nobody has touched (created_at) in Config_FlagMaxAgeDays,
-- so stale flags don't linger forever. Runs once a day.

local Config_FlagMaxAgeDays = 14

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(24 * 60 * 60 * 1000) -- once a day
        MySQL.Async.execute(
            "DELETE FROM `admin_player_flags` WHERE `created_at` < DATE_SUB(NOW(), INTERVAL @days DAY)",
            { ['@days'] = Config_FlagMaxAgeDays },
            function(rowsAffected)
                if rowsAffected and rowsAffected > 0 then
                    print(("[Unique_AdminMenu] Auto-cleared %s flag(s) older than %s days."):format(rowsAffected, Config_FlagMaxAgeDays))
                end
            end
        )
    end
end)

RegisterCommand('acleanflags', function(source, args)
    if not IsOnDutyAdmin(source) then return end
    local days = tonumber(args[1]) or Config_FlagMaxAgeDays
    MySQL.Async.execute(
        "DELETE FROM `admin_player_flags` WHERE `created_at` < DATE_SUB(NOW(), INTERVAL @days DAY)",
        { ['@days'] = days },
        function(rowsAffected)
            TriggerClientEvent('esx:showNotification', source, ("~g~Cleared %s flag(s) older than %s days."):format(rowsAffected or 0, days))
            LogAdminAction(source, "clean-old-flags", ("cleared: %s | older than: %s days"):format(rowsAffected or 0, days))
        end
    )
end, false)

-- ------------------------------------------------------- BAN PRESETS ---
-- Common infractions with a consistent default reason + duration, so
-- different admins ban the same thing the same way instead of freehanding
-- a reason/duration every time.

BanPresets = {
    { id = 'speedhack',   label = 'Speedhack',            minutes = 0,    reason = 'Speedhack / movement exploit' }, -- 0 = permanent
    { id = 'noclip',      label = 'Unauthorized Noclip',  minutes = 0,    reason = 'Unauthorized noclip usage' },
    { id = 'dupe',        label = 'Item/Money Dupe',      minutes = 0,    reason = 'Duplication exploit' },
    { id = 'rdm',         label = 'RDM',                  minutes = 60,   reason = 'Random Deathmatch (RDM)' },
    { id = 'vdm',         label = 'VDM',                  minutes = 60,   reason = 'Vehicle Deathmatch (VDM)' },
    { id = 'toxicity',    label = 'Toxicity / Chat Abuse', minutes = 120,  reason = 'Toxic behavior in chat/voice' },
    { id = 'metagaming',  label = 'Metagaming',            minutes = 180,  reason = 'Metagaming' },
    { id = 'ncz',         label = 'NCZ Violation',         minutes = 60,   reason = 'Non-combat zone violation' },
}

ESX.RegisterServerCallback('Unique_AdminMenu:GetBanPresets', function(source, cb)
    if not IsOnDutyAdminFor(source, 'btn_ban') then cb({}) return end
    cb(BanPresets)
end)

-- --------------------------------------------------- STALE TICKET NUDGE ---
-- Gentle reminder (every 10 min, not a spam loop) to on-duty admins about
-- reports that are still open while the reporter is still online - easy to
-- lose track of during a busy shift.

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10 * 60 * 1000)

        local ok, reports = pcall(function() return exports.esx_aduty:GetReports() end)
        if ok and reports then
            for id, r in pairs(reports) do
                if r.status == 'open' or r.status == 'pending' then
                    local reporterId = r.owner and r.owner.id
                    if reporterId and GetPlayerName(reporterId) then
                        for _, src in ipairs(ESX.GetPlayers()) do
                            if IsOnDutyAdmin(src) then
                                TriggerClientEvent('chat:addMessage', src, {
                                    color = { 200, 160, 90 },
                                    args = { "[OPEN TICKET]", ("#%s from %s is still unanswered (they're still online)."):format(id, r.owner.name or reporterId) },
                                })
                            end
                        end
                    end
                end
            end
        end
    end
end)

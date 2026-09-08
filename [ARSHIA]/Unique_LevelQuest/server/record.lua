-- ================================================================= --
-- RECORD TAB — a read-only "rap sheet" for the player's own account:
-- current jail/community-service status (from Unique_Punishment's own
-- live columns) plus their full punishment history (from the new
-- `punishment_history` table added in Unique_Punishment/server/
-- migrations.lua, hooked into its jail.lua/cs.lua sentencing code).
-- This resource only ever READS punishment_history — Unique_Punishment
-- owns writing to it.
-- ================================================================= --

ESX.RegisterServerCallback('HUD_Menu:GetRecord', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        cb(nil)
        return
    end

    MySQL.Async.fetchAll('SELECT jail FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(userResult)
        local currentJail = nil
        local rawJail = userResult and userResult[1] and userResult[1].jail
        if rawJail and rawJail ~= '0' and rawJail ~= '' then
            local ok, decoded = pcall(json.decode, rawJail)
            if ok and type(decoded) == 'table' and decoded.time then
                local elapsedMinutes = math.floor((os.time() - (decoded.startedAt or os.time())) / 60)
                local remainingMinutes = math.max(0, (tonumber(decoded.time) or 0) - elapsedMinutes)
                currentJail = {
                    reason           = decoded.reason,
                    remainingMinutes = remainingMinutes,
                    sentenceType     = decoded.type,
                }
            end
        end

        MySQL.Async.fetchAll('SELECT actions_remaining, reason FROM communityservice WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier
        }, function(csResult)
            local currentCS = csResult and csResult[1] and {
                remaining = tonumber(csResult[1].actions_remaining) or 0,
                reason    = csResult[1].reason,
            } or nil

            MySQL.Async.fetchAll([[
                SELECT type, reason, duration, issued_by_name, issued_by_type, created_at
                FROM punishment_history
                WHERE identifier = @identifier
                ORDER BY created_at DESC
                LIMIT 20
            ]], { ['@identifier'] = xPlayer.identifier }, function(historyResult)
                local history = {}
                for i = 1, #(historyResult or {}) do
                    local row = historyResult[i]
                    table.insert(history, {
                        type         = row.type,
                        reason       = row.reason,
                        duration     = row.duration,
                        issuedByName = row.issued_by_name,
                        issuedByType = row.issued_by_type,
                        date         = row.created_at,
                    })
                end

                cb({
                    currentJail = currentJail,
                    currentCS   = currentCS,
                    history     = history,
                })
            end)
        end)
    end)
end)

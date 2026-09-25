-- Combined risk score: pulls together signals that already exist in this
-- resource (server/investigation.lua's money-spike auto-flag and
-- server/spawn_pattern.lua's spawn-burst auto-flag both write into the
-- SAME `admin_player_flags` table, plus admin_warnings) into one number,
-- instead of an admin having to check each source separately.
--
-- NOTE ON SCOPE: this deliberately does NOT include a "report count"
-- signal. The report/ticket system in server/aduty_reports.lua is a
-- support-queue (the `owner` on each ticket is the REPORTER asking for
-- admin help, not an accused player) - there is no "reports filed against
-- this identifier" data in the current schema to pull from. Adding that
-- would need a real "target player" field on tickets first.

local Config_RiskScore = {
    FlagPoints          = 40, -- has an active admin_player_flags row (money spike / spawn pattern / collusion)
    WarningPoints       = 15, -- per admin_warnings row, capped
    WarningCap          = 3,
    NewAccountBonus     = 15, -- <= NewAccountAuditRows entries in `audit` (type='Enter') = treated as a new/rarely-seen account
    NewAccountAuditRows = 3,
}

local function ClampScore(n)
    if n > 100 then return 100 end
    if n < 0 then return 0 end
    return n
end

-- Core, resource-internal function. cb(result) is called with:
--   { identifier = <id>, score = 0-100, reasons = { "...", ... } }
-- Any server-side file in this resource can call this directly (no need
-- to go through ESX.TriggerServerCallback for server->server use).
function GetRiskScoreForIdentifier(identifier, cb)
    if not identifier or identifier == '' then cb(nil) return end

    local result = { identifier = identifier, score = 0, reasons = {} }

    MySQL.Async.fetchAll(
        "SELECT `note` FROM `admin_player_flags` WHERE `identifier` = @id",
        { ['@id'] = identifier },
        function(flagRows)
            if flagRows and flagRows[1] then
                result.score = result.score + Config_RiskScore.FlagPoints
                result.reasons[#result.reasons + 1] = ('Active flag: %s'):format(flagRows[1].note or '?')
            end

            MySQL.Async.fetchScalar(
                "SELECT COUNT(*) FROM `admin_warnings` WHERE `identifier` = @id",
                { ['@id'] = identifier },
                function(warnCount)
                    warnCount = tonumber(warnCount) or 0
                    local counted = math.min(warnCount, Config_RiskScore.WarningCap)
                    if counted > 0 then
                        result.score = result.score + (counted * Config_RiskScore.WarningPoints)
                        result.reasons[#result.reasons + 1] = ('%s prior warning(s)'):format(warnCount)
                    end

                    MySQL.Async.fetchScalar(
                        "SELECT COUNT(*) FROM `audit` WHERE `identifier` = @id AND `type` = 'Enter'",
                        { ['@id'] = identifier },
                        function(enterCount)
                            enterCount = tonumber(enterCount) or 0
                            if enterCount > 0 and enterCount <= Config_RiskScore.NewAccountAuditRows then
                                result.score = result.score + Config_RiskScore.NewAccountBonus
                                result.reasons[#result.reasons + 1] = ('New/rarely-seen account (%s server visits on record)'):format(enterCount)
                            end

                            result.score = ClampScore(result.score)
                            if #result.reasons == 0 then
                                result.reasons[1] = 'No risk signals on file.'
                            end
                            cb(result)
                        end
                    )
                end
            )
        end
    )
end

-- Thin wrapper for client/NUI use.
RegisterServerCallbackSafe('Unique_AdminPanel:GetRiskScore', function(source, cb, identifier)
    if not IsOnDutyAdmin(source) then cb(nil) return end
    GetRiskScoreForIdentifier(identifier, cb)
end)

-- Quick chat-command wrapper so this is usable right away without any NUI
-- changes. Wiring it into the Inspect panel later is just one more
-- ESX.TriggerServerCallback call from client/admin_tools_menu.lua.
RegisterCommand('ariskscore', function(source, args)
    if not IsOnDutyAdmin(source) then return end

    local targetId = tonumber(args[1])
    local identifier = args[1]

    if targetId then
        local xTarget = ESX.GetPlayerFromId(targetId)
        if not xTarget then
            TriggerClientEvent('esx:showNotification', source, '~r~Player not online / invalid ID')
            return
        end
        identifier = xTarget.identifier
    end

    if not identifier then
        TriggerClientEvent('esx:showNotification', source, '~r~Estefade: /ariskscore [id ya identifier]')
        return
    end

    GetRiskScoreForIdentifier(identifier, function(result)
        if not result then
            TriggerClientEvent('esx:showNotification', source, '~r~Khata dar mohasebe risk score.')
            return
        end
        TriggerClientEvent('chatMessage', source, '[RISK SCORE]', { 255, 200, 0 },
            ('^0%s -> ^1%s^0/100'):format(result.identifier, result.score))
        for _, reason in ipairs(result.reasons) do
            TriggerClientEvent('chatMessage', source, '[RISK SCORE]', { 255, 200, 0 }, '^0 - ' .. reason)
        end
    end)
end, false)

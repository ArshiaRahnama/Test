-- ================================================================= --
-- DUTY TAB — replaces esx_duty's standalone `/dutyjob` command + its
-- separate NUI terminal with a tab inside this HUD instead.
--
-- esx_duty itself KEEPS RUNNING: the duty on/off toggle at job zones,
-- the AFK check, and the background thread that logs +300 seconds to
-- `duty_logs` every 5 minutes are untouched by this. Only its
-- `/dutyjob` command and dutyjob.html menu become redundant, since
-- this tab reads the exact same `duty_logs` table that thread already
-- writes into — nothing needs to be ported or re-logged.
--
-- IMPORTANT IDENTIFIER NOTE: esx_duty writes rows keyed by whatever
-- GetPlayerIdentifiers(source)[1] happens to be (first identifier in
-- the list) under the column `steamhex` — this is NOT necessarily the
-- same value as essentialmode's own xPlayer.identifier, which
-- essentialmode resolves by explicitly searching for the identifier
-- that starts with "steam:" (essentialmode/server/main.lua). On a
-- server where the first identifier in the list isn't the Steam one,
-- those two differ. This file deliberately calls GetPlayerIdentifiers
-- the same way esx_duty does, to match rows that already exist in the
-- table, rather than "fixing" it to use xPlayer.identifier and
-- silently querying against a key nothing was ever written under.
-- ================================================================= --

-- Same leadership threshold the original /dutyjob command used to
-- decide "can see everyone's hours" (full roster) vs "can only see
-- your own" (grade <= 11 there meant self-only).
local DUTY_LEADERSHIP_GRADE = 11

ESX.RegisterServerCallback('HUD_Menu:GetDuty', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not xPlayer.job or xPlayer.job.name == 'nojob' then
        cb({ isMember = false })
        return
    end

    -- Off-duty members ("offpolice" etc.) are still org members — the
    -- tab should stay visible and show their org's stats, not vanish
    -- the moment they clock off.
    local jobName = xPlayer.job.name
    local orgName = (string.sub(jobName, 1, 3) == 'off') and string.sub(jobName, 4) or jobName
    local steamHex = GetPlayerIdentifiers(source)[1]
    local isLeadership = xPlayer.job.grade > DUTY_LEADERSHIP_GRADE

    -- Letting MySQL's own date functions (CURDATE/DATE_SUB) do the
    -- day-boundary math server-side, rather than pulling raw `date`
    -- values into Lua and doing epoch arithmetic on them the way
    -- esx_duty's own client/main.lua did (it treats `duty_logs.date` —
    -- a SQL DATE column — as if it were a millisecond epoch number,
    -- which depends entirely on how the DB driver happens to
    -- serialize DATE columns and isn't reliable to replicate here).
    MySQL.Async.fetchAll([[
        SELECT
            SUM(CASE WHEN date = CURDATE() THEN total_time ELSE 0 END) AS todaySeconds,
            SUM(CASE WHEN date >= DATE_SUB(CURDATE(), INTERVAL 6 DAY) THEN total_time ELSE 0 END) AS weekSeconds,
            SUM(total_time) AS allSeconds
        FROM duty_logs
        WHERE steamhex = @steamHex AND job_name = @jobName
    ]], { ['@steamHex'] = steamHex, ['@jobName'] = orgName }, function(ownResult)
        local own = (ownResult and ownResult[1]) or {}

        local response = {
            isMember     = true,
            orgName      = orgName,
            isLeadership = isLeadership,
            todaySeconds = tonumber(own.todaySeconds) or 0,
            weekSeconds  = tonumber(own.weekSeconds) or 0,
            allSeconds   = tonumber(own.allSeconds) or 0,
        }

        if not isLeadership then
            cb(response)
            return
        end

        -- Leadership also gets a whole-org roster (all-time hours per
        -- member) — a simpler, always-up-to-date replacement for
        -- esx_duty's manual player-picker + date-range form.
        MySQL.Async.fetchAll([[
            SELECT ic_name, SUM(total_time) AS allSeconds
            FROM duty_logs
            WHERE job_name = @jobName
            GROUP BY steamhex, ic_name
            ORDER BY allSeconds DESC
            LIMIT 20
        ]], { ['@jobName'] = orgName }, function(rosterResult)
            local roster = {}
            for i = 1, #(rosterResult or {}) do
                table.insert(roster, {
                    name       = rosterResult[i].ic_name,
                    allSeconds = tonumber(rosterResult[i].allSeconds) or 0,
                })
            end
            response.roster = roster
            cb(response)
        end)
    end)
end)

-- Used by the DUTY tab's calendar date picker. Leadership gets the
-- whole org's roster for that day (like before); everyone else now
-- gets their OWN total for that day instead of being rejected — any
-- member should be able to check "how long was I on duty that day",
-- not just leadership.
ESX.RegisterServerCallback('HUD_Menu:GetDutyByDate', function(source, cb, dateStr)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not xPlayer.job or xPlayer.job.name == 'nojob' then
        cb({ ok = false })
        return
    end
    -- Expect exactly what the calendar widget sends (YYYY-MM-DD).
    -- Anything else gets rejected rather than handed to the query
    -- as-is.
    if type(dateStr) ~= 'string' or not string.match(dateStr, '^%d%d%d%d%-%d%d%-%d%d$') then
        cb({ ok = false })
        return
    end

    local jobName = xPlayer.job.name
    local orgName = (string.sub(jobName, 1, 3) == 'off') and string.sub(jobName, 4) or jobName
    local isLeadership = xPlayer.job.grade > DUTY_LEADERSHIP_GRADE

    if isLeadership then
        MySQL.Async.fetchAll([[
            SELECT ic_name, SUM(total_time) AS seconds
            FROM duty_logs
            WHERE job_name = @jobName AND date = @date
            GROUP BY steamhex, ic_name
            ORDER BY seconds DESC
            LIMIT 20
        ]], { ['@jobName'] = orgName, ['@date'] = dateStr }, function(result)
            local roster = {}
            for i = 1, #(result or {}) do
                table.insert(roster, {
                    name    = result[i].ic_name,
                    seconds = tonumber(result[i].seconds) or 0,
                })
            end
            cb({ ok = true, mode = 'roster', date = dateStr, orgName = orgName, roster = roster })
        end)
        return
    end

    local steamHex = GetPlayerIdentifiers(source)[1]
    MySQL.Async.fetchAll([[
        SELECT SUM(total_time) AS seconds
        FROM duty_logs
        WHERE steamhex = @steamHex AND job_name = @jobName AND date = @date
    ]], { ['@steamHex'] = steamHex, ['@jobName'] = orgName, ['@date'] = dateStr }, function(result)
        local seconds = (result and result[1] and tonumber(result[1].seconds)) or 0
        cb({ ok = true, mode = 'personal', date = dateStr, orgName = orgName, seconds = seconds })
    end)
end)

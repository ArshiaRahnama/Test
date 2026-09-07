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
        -- esx_duty's manual player-picker + date-range form. Capped
        -- at the top 5 by design — a big org can have far more
        -- members than fit comfortably in this panel, and the rest
        -- are reachable through the search box (HUD_Menu:SearchDutyRoster
        -- below) instead of an ever-growing list.
        MySQL.Async.fetchAll([[
            SELECT ic_name, SUM(total_time) AS allSeconds
            FROM duty_logs
            WHERE job_name = @jobName
            GROUP BY steamhex, ic_name
            ORDER BY allSeconds DESC
            LIMIT 5
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

-- Used by the DUTY tab's calendar range picker. Leadership gets the
-- whole org's roster totalled across the selected date range (like
-- before, just range instead of single-day); everyone else gets
-- their OWN total for that range instead of being rejected — any
-- member should be able to check "how long was I on duty those
-- days", not just leadership.
ESX.RegisterServerCallback('HUD_Menu:GetDutyByDate', function(source, cb, startDate, endDate)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not xPlayer.job or xPlayer.job.name == 'nojob' then
        cb({ ok = false })
        return
    end
    -- Expect exactly what the calendar widget sends (YYYY-MM-DD) for
    -- both ends. Anything else gets rejected rather than handed to
    -- the query as-is.
    local function isValidDate(d)
        return type(d) == 'string' and string.match(d, '^%d%d%d%d%-%d%d%-%d%d$') ~= nil
    end
    if not isValidDate(startDate) or not isValidDate(endDate) then
        cb({ ok = false })
        return
    end
    -- YYYY-MM-DD strings sort correctly with plain string comparison,
    -- so swapping here is enough to guard against a reversed range
    -- without needing to parse them into real dates.
    if startDate > endDate then
        startDate, endDate = endDate, startDate
    end

    local jobName = xPlayer.job.name
    local orgName = (string.sub(jobName, 1, 3) == 'off') and string.sub(jobName, 4) or jobName
    local isLeadership = xPlayer.job.grade > DUTY_LEADERSHIP_GRADE

    if isLeadership then
        MySQL.Async.fetchAll([[
            SELECT ic_name, SUM(total_time) AS seconds
            FROM duty_logs
            WHERE job_name = @jobName AND date BETWEEN @startDate AND @endDate
            GROUP BY steamhex, ic_name
            ORDER BY seconds DESC
            LIMIT 5
        ]], { ['@jobName'] = orgName, ['@startDate'] = startDate, ['@endDate'] = endDate }, function(result)
            local roster = {}
            for i = 1, #(result or {}) do
                table.insert(roster, {
                    name    = result[i].ic_name,
                    seconds = tonumber(result[i].seconds) or 0,
                })
            end
            cb({ ok = true, mode = 'roster', startDate = startDate, endDate = endDate, orgName = orgName, roster = roster })
        end)
        return
    end

    local steamHex = GetPlayerIdentifiers(source)[1]
    MySQL.Async.fetchAll([[
        SELECT SUM(total_time) AS seconds
        FROM duty_logs
        WHERE steamhex = @steamHex AND job_name = @jobName AND date BETWEEN @startDate AND @endDate
    ]], { ['@steamHex'] = steamHex, ['@jobName'] = orgName, ['@startDate'] = startDate, ['@endDate'] = endDate }, function(result)
        local seconds = (result and result[1] and tonumber(result[1].seconds)) or 0
        cb({ ok = true, mode = 'personal', startDate = startDate, endDate = endDate, orgName = orgName, seconds = seconds })
    end)
end)

-- Leadership-only: search the WHOLE org roster by name (not capped at
-- the top 5 shown by default), since a bigger org can have far more
-- members with recorded duty time than fit comfortably in the panel.
-- Always searches all-time totals, independent of whatever date range
-- (if any) is currently displayed — keeps this one predictable rather
-- than silently depending on other UI state.
ESX.RegisterServerCallback('HUD_Menu:SearchDutyRoster', function(source, cb, searchTerm)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not xPlayer.job or xPlayer.job.name == 'nojob' then
        cb({ ok = false })
        return
    end
    if xPlayer.job.grade <= DUTY_LEADERSHIP_GRADE then
        cb({ ok = false })
        return
    end
    if type(searchTerm) ~= 'string' or #searchTerm < 1 or #searchTerm > 50 then
        cb({ ok = false })
        return
    end

    local jobName = xPlayer.job.name
    local orgName = (string.sub(jobName, 1, 3) == 'off') and string.sub(jobName, 4) or jobName

    -- Names are stored with underscores ("Sohrab_Qaderi") and only
    -- turned into spaces for display client-side, so a search typed
    -- with spaces needs the same substitution to actually match.
    local dbSearchTerm = string.gsub(searchTerm, ' ', '_')

    MySQL.Async.fetchAll([[
        SELECT ic_name, SUM(total_time) AS allSeconds
        FROM duty_logs
        WHERE job_name = @jobName AND ic_name LIKE @search
        GROUP BY steamhex, ic_name
        ORDER BY allSeconds DESC
        LIMIT 15
    ]], { ['@jobName'] = orgName, ['@search'] = '%' .. dbSearchTerm .. '%' }, function(result)
        local roster = {}
        for i = 1, #(result or {}) do
            table.insert(roster, {
                name       = result[i].ic_name,
                allSeconds = tonumber(result[i].allSeconds) or 0,
            })
        end
        cb({ ok = true, roster = roster })
    end)
end)

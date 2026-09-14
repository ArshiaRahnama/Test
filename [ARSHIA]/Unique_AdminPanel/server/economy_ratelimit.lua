-- Rate-limit watcher for admin money/item commands (setmoney, giveitem, ...).
-- Does NOT block the admin or punish them - only posts a Discord log alert
-- (via the same LogAdminAction() used everywhere else in this resource) if
-- one admin fires these commands unusually often in a short window, so a
-- senior admin can review it later. Same "auto-flag, don't auto-punish"
-- philosophy as server/investigation.lua's money-spike scanner.

local Config_EconomyRateLimit = {
    WindowMs        = 5 * 60 * 1000, -- 5 minutes
    Threshold       = 6,             -- more than N economy commands in the window = alert
    AlertCooldownSec = 5 * 60,       -- don't re-alert for the same admin more than once per 5 min
}

local CommandTimestamps = {} -- source -> { {t=, cmd=, details=}, ... }
local LastAlert = {}         -- source -> os.time() of last alert

-- Call this from inside an economy command's handler AFTER the action
-- succeeds, e.g. TrackEconomyCommand(source, "setmoney", "target: X | cash: 5000")
function TrackEconomyCommand(source, cmdName, details)
    local now = GetGameTimer()
    local list = CommandTimestamps[source] or {}
    list[#list + 1] = { t = now, cmd = cmdName, details = details }

    local pruned = {}
    for _, entry in ipairs(list) do
        if now - entry.t <= Config_EconomyRateLimit.WindowMs then
            pruned[#pruned + 1] = entry
        end
    end
    CommandTimestamps[source] = pruned

    if #pruned < Config_EconomyRateLimit.Threshold then return end

    local lastAlertAt = LastAlert[source]
    local realNow = os.time()
    if lastAlertAt and (realNow - lastAlertAt) < Config_EconomyRateLimit.AlertCooldownSec then return end
    LastAlert[source] = realNow

    local lines = {}
    for _, entry in ipairs(pruned) do
        lines[#lines + 1] = entry.details and (entry.cmd .. ' - ' .. entry.details) or entry.cmd
    end

    LogAdminAction(
        source,
        'rate-limit-warning',
        ('%s economy command(s) in <=%smin:\n%s'):format(
            #pruned, math.floor(Config_EconomyRateLimit.WindowMs / 60000), table.concat(lines, '\n'))
    )
end

AddEventHandler('playerDropped', function()
    CommandTimestamps[source] = nil
    LastAlert[source] = nil
end)

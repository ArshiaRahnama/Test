if not ESX then TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) end
-- Organisation ON/OFF. An OFF organisation: its job holders are sent to unemployed,
-- nobody can be given its job, and its blips/menus are hidden on the client.
-- Government (chief/management) can switch them.

OrgState = {}   -- [job] = true (on) / false (off); missing = on

local ORG_JOBS = {}
for _, d in ipairs(Departments or {}) do
    if d.id ~= 'gov' then for _, j in ipairs(d.jobs) do ORG_JOBS[j] = true end end
end

MySQL.ready(function()
    MySQL.Async.execute('CREATE TABLE IF NOT EXISTS org_state (job VARCHAR(32) PRIMARY KEY, enabled TINYINT NOT NULL DEFAULT 1)', {})
    MySQL.Async.fetchAll('SELECT job, enabled FROM org_state', {}, function(rows)
        for _, r in ipairs(rows or {}) do OrgState[r.job] = (tonumber(r.enabled) == 1) end
    end)
end)

function OrgIsEnabled(job)
    return OrgState[job] ~= false
end

exports('OrgIsEnabled', function(job) return OrgState[job] ~= false end)

local function canSwitch(xPlayer)
    return xPlayer and xPlayer.job and xPlayer.job.name == 'government' and (tonumber(xPlayer.job.grade) or 0) >= 2
end

local function setOrg(job, enabled)
    OrgState[job] = enabled
    MySQL.Async.execute('INSERT INTO org_state (job, enabled) VALUES (@j, @e) ON DUPLICATE KEY UPDATE enabled = @e',
        { ['@j'] = job, ['@e'] = enabled and 1 or 0 })
    TriggerClientEvent('org_state:changed', -1, job, enabled)
    if not enabled then
        -- send the online members home (unemployed)
        for _, pid in ipairs(GetPlayers()) do
            local x = ESX.GetPlayerFromId(tonumber(pid))
            if x and x.job and x.job.name == job then
                x.setJob('unemployed', 0)
                TriggerClientEvent('esx:showNotification', x.source, 'Ergan-e shoma tavasot-e Government khamoosh shod.')
            end
        end
    end
end

RegisterNetEvent('org_state:request')
AddEventHandler('org_state:request', function()
UJLog('SERVER', ('org_state:request src=%s '):format(tostring(source)))
    TriggerClientEvent('org_state:sync', source, OrgState)
end)

RegisterNetEvent('org_state:toggle')
AddEventHandler('org_state:toggle', function(job, enabled)
UJLog('SERVER', ('org_state:toggle src=%s job=%s enabled=%s'):format(tostring(source), tostring(job), tostring(enabled)))
    local src = source
    local x = ESX.GetPlayerFromId(src)
    if not canSwitch(x) then return TriggerClientEvent('esx:showNotification', src, 'Faghat chief/management-e Government mitoone.') end
    if not ORG_JOBS[job] then return end
    setOrg(job, enabled and true or false)
    TriggerClientEvent('esx:showNotification', -1, ('Ergan %s %s shod.'):format(job, enabled and 'ROSHAN' or 'KHAMOOSH'))
    -- Government members get a clear chat line
    local by = GetPlayerName(src)
    local line = enabled
        and ('^3^*[GOVERNMENT] ^2^*Ergan ^7' .. string.upper(job) .. ' ^2^*ROSHAN shod ^7tavasot ^3' .. by)
        or  ('^3^*[GOVERNMENT] ^1^*Ergan ^7' .. string.upper(job) .. ' ^1^*KHAMOOSH shod ^7tavasot ^3' .. by .. ' ^7- hame-ye aza az job bargashtand.')
    for _, pid in ipairs(GetPlayers()) do
        local tx = ESX.GetPlayerFromId(tonumber(pid))
        if tx and tx.job and tx.job.name == 'government' then
            TriggerClientEvent('chatMessage', tx.source, '', {255, 215, 0}, line)
        end
    end
end)

-- A switched-OFF organisation can not be given to anybody (admin /setjob, Government,
-- or an old saved job at login): the player goes back to unemployed with a clear message.
local function refuseIfOff(src, job)
    if not (job and job.name and OrgState[job.name] == false) then return end
    SetTimeout(300, function()
        local x = ESX.GetPlayerFromId(src)
        if x and x.job and x.job.name == job.name then
            x.setJob('unemployed', 0)
            TriggerClientEvent('esx:showNotification', src,
                ('~r~Ergan %s khamoosh ast~s~ - ke job dashtan dar an momken nist. Az Government bekhahid roshan konad.'):format(job.name))
            UJLog('ORG_OFF', ('job %s refused for player %s (organisation is OFF)'):format(job.name, tostring(src)))
        end
    end)
end

AddEventHandler('esx:setJob', function(source, job, lastJob)
    refuseIfOff(source, job)
end)

AddEventHandler('esx:playerLoaded', function(source, xPlayer)
    local x = xPlayer or ESX.GetPlayerFromId(source)
    if x and x.job then refuseIfOff(source, x.job) end
end)


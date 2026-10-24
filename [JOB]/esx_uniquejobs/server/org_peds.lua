if not ESX then TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) end
-- Org pads: which ped models an organisation has, which are ON, and the minimum rank.
-- Table org_peds: (job, ped) -> enabled, min_grade.
-- Changed by: Government (chief/management) for any organisation,
--             the organisation's boss (grade_name 'boss') for its own pads' ranks.

local PedState = {}   -- [job] = { [ped] = { enabled = bool, min_grade = int } }
local ExtraPeds = {}  -- [job] = { [ped] = true }  pads added by Government (table org_ped_list)
local HiddenPeds = {} -- [job] = { [ped] = true }  pads Government removed for everybody (table org_ped_hidden)

-- every pad of a job: the shared list + the ones Government added
local function pedsFor(job)
    local out, seen = {}, {}
    local hidden = HiddenPeds[job] or {}
    for _, p in ipairs((OrgPeds and OrgPeds[job]) or {}) do
        if not seen[p] and not hidden[p] then out[#out + 1] = p; seen[p] = true end
    end
    for p in pairs(ExtraPeds[job] or {}) do
        if not seen[p] and not hidden[p] then out[#out + 1] = p; seen[p] = true end
    end
    return out
end

local function hiddenList(job)
    local out = {}
    for p in pairs(HiddenPeds[job] or {}) do out[#out + 1] = p end
    table.sort(out)
    return out
end

local function hasPed(job, ped)
    for _, p in ipairs(pedsFor(job)) do if p == ped then return true end end
    return false
end

MySQL.ready(function()
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS org_peds (
            job VARCHAR(32) NOT NULL,
            ped VARCHAR(64) NOT NULL,
            enabled TINYINT NOT NULL DEFAULT 1,
            min_grade INT NOT NULL DEFAULT 0,
            PRIMARY KEY (job, ped)
        )
    ]], {})
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS org_ped_list (
            job VARCHAR(32) NOT NULL,
            ped VARCHAR(64) NOT NULL,
            PRIMARY KEY (job, ped)
        )
    ]], {})
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS org_ped_hidden (
            job VARCHAR(32) NOT NULL,
            ped VARCHAR(64) NOT NULL,
            PRIMARY KEY (job, ped)
        )
    ]], {})
    MySQL.Async.fetchAll('SELECT job, ped FROM org_ped_hidden', {}, function(rows)
        for _, r in ipairs(rows or {}) do
            HiddenPeds[r.job] = HiddenPeds[r.job] or {}
            HiddenPeds[r.job][r.ped] = true
        end
    end)
    MySQL.Async.fetchAll('SELECT job, ped FROM org_ped_list', {}, function(rows)
        for _, r in ipairs(rows or {}) do
            ExtraPeds[r.job] = ExtraPeds[r.job] or {}
            ExtraPeds[r.job][r.ped] = true
        end
    end)
    MySQL.Async.fetchAll('SELECT job, ped, enabled, min_grade FROM org_peds', {}, function(rows)
        for _, r in ipairs(rows or {}) do
            PedState[r.job] = PedState[r.job] or {}
            PedState[r.job][r.ped] = { enabled = tonumber(r.enabled) == 1, min_grade = tonumber(r.min_grade) or 0 }
        end
    end)
end)

local function stateOf(job, ped)
    PedState[job] = PedState[job] or {}
    return PedState[job][ped] or { enabled = false, min_grade = 0 }
end

local function canGovern(xPlayer)
    return xPlayer and xPlayer.job and xPlayer.job.name == 'government' and (tonumber(xPlayer.job.grade) or 0) >= 2
end

local function canManage(xPlayer, job)
    if canGovern(xPlayer) then return true end
    return xPlayer and xPlayer.job and xPlayer.job.name == job and (xPlayer.job.grade_name == 'boss' or xPlayer.job.name == 'government')
end

-- list for the menu: every ped of the job with its state
ESX.RegisterServerCallback('OrgPeds:List', function(source, cb, job)
UJLog('SERVER', ('OrgPeds:List source=%s job=%s'):format(tostring(source), tostring(job)))
    local out = {}
    for _, ped in ipairs(pedsFor(job)) do
        local st = stateOf(job, ped)
        out[#out + 1] = { ped = ped, enabled = st.enabled, min_grade = st.min_grade }
    end
    cb(out)
end)

-- the pads this player may wear now
ESX.RegisterServerCallback('OrgPeds:Mine', function(source, cb)
UJLog('SERVER', ('OrgPeds:Mine source=%s'):format(tostring(source)))
    local x = ESX.GetPlayerFromId(source)
    local out = {}
    if x and x.job then
        local job = x.job.name
        local grade = tonumber(x.job.grade) or 0
        do
            for _, ped in ipairs(pedsFor(job)) do
                local st = stateOf(job, ped)
                if st.enabled and grade >= st.min_grade then out[#out + 1] = ped end
            end
        end
    end
    cb(out)
end)

-- change one pad: enabled and/or min_grade
RegisterNetEvent('org_peds:set')
AddEventHandler('org_peds:set', function(job, ped, enabled, minGrade)
UJLog('SERVER', ('org_peds:set src=%s job=%s ped=%s enabled=%s minGrade=%s'):format(tostring(source), tostring(job), tostring(ped), tostring(enabled), tostring(minGrade)))
    local src = source
    local x = ESX.GetPlayerFromId(src)
    if not canManage(x, job) then return TriggerClientEvent('esx:showNotification', src, 'Dastresi nadari.') end
    if not hasPed(job, ped) then return end
    local st = stateOf(job, ped)
    if enabled ~= nil and canGovern(x) then st.enabled = enabled and true or false end
    if minGrade ~= nil then st.min_grade = math.max(0, math.floor(tonumber(minGrade) or 0)) end
    PedState[job] = PedState[job] or {}
    PedState[job][ped] = st
    MySQL.Async.execute('INSERT INTO org_peds (job, ped, enabled, min_grade) VALUES (@j, @p, @e, @m) ON DUPLICATE KEY UPDATE enabled = @e, min_grade = @m',
        { ['@j'] = job, ['@p'] = ped, ['@e'] = st.enabled and 1 or 0, ['@m'] = st.min_grade })
    TriggerClientEvent('esx:showNotification', src, ('%s: %s | aktiv=%s | rank>=%d'):format(job, ped, tostring(st.enabled), st.min_grade))
end)

-- Government adds a pad model to a job (any job, any name)
RegisterNetEvent('org_peds:add')
AddEventHandler('org_peds:add', function(job, ped)
UJLog('SERVER', ('org_peds:add src=%s job=%s ped=%s'):format(tostring(source), tostring(job), tostring(ped)))
    local src = source
    local x = ESX.GetPlayerFromId(src)
    if not canGovern(x) then return TriggerClientEvent('esx:showNotification', src, 'Faghat Government mitoone pad ezafe kone.') end
    ped = tostring(ped or '')
    if not ped:match('^[%w_]+$') or #ped > 64 then
        return TriggerClientEvent('esx:showNotification', src, 'Esm pad na-motabar ast (faghat harf, adad, _).')
    end
    if not (OrgPeds and OrgPeds[job]) and not ExtraPeds[job] then
        local known = false
        for _, d in ipairs(Departments or {}) do for _, j in ipairs(d.jobs) do if j == job then known = true end end end
        if not known then return TriggerClientEvent('esx:showNotification', src, 'Job na-motabar.') end
    end
    if hasPed(job, ped) then return TriggerClientEvent('esx:showNotification', src, 'In pad az ghabl hast.') end
    ExtraPeds[job] = ExtraPeds[job] or {}
    ExtraPeds[job][ped] = true
    MySQL.Async.execute('INSERT INTO org_ped_list (job, ped) VALUES (@j, @p)', { ['@j'] = job, ['@p'] = ped })
    TriggerClientEvent('esx:showNotification', src, ('Pad %s baraye %s ezafe shod.'):format(ped, job))
end)

RegisterNetEvent('org_peds:remove')
AddEventHandler('org_peds:remove', function(job, ped)
UJLog('SERVER', ('org_peds:remove src=%s job=%s ped=%s'):format(tostring(source), tostring(job), tostring(ped)))
    local src = source
    local x = ESX.GetPlayerFromId(src)
    if not canGovern(x) then return TriggerClientEvent('esx:showNotification', src, 'Faghat Government mitoone pad hazf kone.') end
    ped = tostring(ped or '')
    if ExtraPeds[job] and ExtraPeds[job][ped] then
        ExtraPeds[job][ped] = nil
        MySQL.Async.execute('DELETE FROM org_ped_list WHERE job = @j AND ped = @p', { ['@j'] = job, ['@p'] = ped })
    else
        local listed = false
        for _, p in ipairs((OrgPeds and OrgPeds[job]) or {}) do if p == ped then listed = true end end
        if not listed then return TriggerClientEvent('esx:showNotification', src, 'Pad peyda nashod.') end
        HiddenPeds[job] = HiddenPeds[job] or {}
        HiddenPeds[job][ped] = true
        MySQL.Async.execute('INSERT IGNORE INTO org_ped_hidden (job, ped) VALUES (@j, @p)', { ['@j'] = job, ['@p'] = ped })
    end
    TriggerClientEvent('esx:showNotification', src, ('Pad %s az %s baraye hame hazf shod.'):format(ped, job))
end)

-- Government brings a hidden pad back
RegisterNetEvent('org_peds:restore')
AddEventHandler('org_peds:restore', function(job, ped)
UJLog('SERVER', ('org_peds:restore src=%s job=%s ped=%s'):format(tostring(source), tostring(job), tostring(ped)))
    local src = source
    local x = ESX.GetPlayerFromId(src)
    if not canGovern(x) then return end
    if not (HiddenPeds[job] and HiddenPeds[job][ped]) then return end
    HiddenPeds[job][ped] = nil
    MySQL.Async.execute('DELETE FROM org_ped_hidden WHERE job = @j AND ped = @p', { ['@j'] = job, ['@p'] = ped })
    TriggerClientEvent('esx:showNotification', src, ('Pad %s baraye %s bargasht.'):format(ped, job))
end)

-- the hidden pads of a job (for Government's restore list)
ESX.RegisterServerCallback('OrgPeds:Hidden', function(source, cb, job)
UJLog('SERVER', ('OrgPeds:Hidden source=%s job=%s'):format(tostring(source), tostring(job)))
    local x = ESX.GetPlayerFromId(source)
    if not canGovern(x) then return cb({}) end
    cb(hiddenList(job))
end)

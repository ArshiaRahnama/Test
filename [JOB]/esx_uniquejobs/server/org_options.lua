if not ESX then TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) end

-- Option rights per rank. No row = allowed. A row with enabled = 0 = switched OFF.
-- Table org_options(job, grade, option, enabled). Changed by Government (grade 2+)
-- for any organisation, or by the boss of that organisation.

local Denied = {}   -- [job][grade][option] = true

MySQL.ready(function()
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS org_options (
            job VARCHAR(32) NOT NULL,
            grade INT NOT NULL,
            opt VARCHAR(32) NOT NULL,
            enabled TINYINT NOT NULL DEFAULT 1,
            PRIMARY KEY (job, grade, opt)
        )
    ]], {})
    MySQL.Async.fetchAll('SELECT job, grade, opt, enabled FROM org_options', {}, function(rows)
        for _, r in ipairs(rows or {}) do
            if tonumber(r.enabled) == 0 then
                Denied[r.job] = Denied[r.job] or {}
                Denied[r.job][tonumber(r.grade)] = Denied[r.job][tonumber(r.grade)] or {}
                Denied[r.job][tonumber(r.grade)][r.opt] = true
            end
        end
    end)
end)

local function validOption(id)
    for _, o in ipairs(OrgOptionList) do if o.id == id then return true end end
    return false
end

local function isDenied(job, grade, opt)
    return Denied[job] and Denied[job][tonumber(grade)] and Denied[job][tonumber(grade)][opt] == true
end

function UJHasOption(src, opt)
    local x = ESX.GetPlayerFromId(src)
    if not x or not x.job then return false end
    if x.job.name == 'government' then return true end
    return not isDenied(x.job.name, x.job.grade, opt)
end
exports('HasOption', UJHasOption)

local function canManage(x, job)
    if not x or not x.job then return false end
    if x.job.name == 'government' and (tonumber(x.job.grade) or 0) >= 2 then return true end
    return x.job.name == job and x.job.grade_name == 'boss'
end

-- the options switched OFF for the caller's rank (the client keeps this as a cache)
ESX.RegisterServerCallback('OrgOptions:Mine', function(source, cb)
    local x = ESX.GetPlayerFromId(source)
    local out = {}
    if x and x.job and x.job.name ~= 'government' then
        for _, o in ipairs(OrgOptionList) do
            if isDenied(x.job.name, x.job.grade, o.id) then out[o.id] = true end
        end
    end
    cb(out)
end)

-- every rank of a job with the state of every option
ESX.RegisterServerCallback('OrgOptions:List', function(source, cb, job)
    local x = ESX.GetPlayerFromId(source)
    if not canManage(x, job) then return cb({}) end
    MySQL.Async.fetchAll('SELECT grade, label FROM job_grades WHERE job_name = @j ORDER BY grade', { ['@j'] = job }, function(rows)
        local out = {}
        for _, r in ipairs(rows or {}) do
            local opts = {}
            for _, o in ipairs(OrgOptionsFor(job)) do
                opts[#opts + 1] = { id = o.id, label = o.label, enabled = not isDenied(job, r.grade, o.id) }
            end
            out[#out + 1] = { grade = tonumber(r.grade), label = r.label, options = opts }
        end
        cb(out)
    end)
end)

RegisterNetEvent('org_options:set')
AddEventHandler('org_options:set', function(job, grade, opt, enabled)
    local src = source
    local x = ESX.GetPlayerFromId(src)
    if not canManage(x, job) then
        return TriggerClientEvent('esx:showNotification', src, '~r~Dastresi kafi nadarid.')
    end
    if not validOption(opt) then return end
    grade = tonumber(grade)
    if not grade then return end
    enabled = enabled and true or false
    Denied[job] = Denied[job] or {}
    Denied[job][grade] = Denied[job][grade] or {}
    Denied[job][grade][opt] = (not enabled) or nil
    MySQL.Async.execute('INSERT INTO org_options (job, grade, opt, enabled) VALUES (@j, @g, @o, @e) ON DUPLICATE KEY UPDATE enabled = @e',
        { ['@j'] = job, ['@g'] = grade, ['@o'] = opt, ['@e'] = enabled and 1 or 0 })
    TriggerClientEvent('org_options:changed', -1)
    TriggerClientEvent('esx:showNotification', src, ('%s | rank %d | %s: %s'):format(job, grade, opt, enabled and 'ROSHAN' or 'KHAMOOSH'))
end)

if not ESX then TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) end
-- /job editor (server half): only the Chief Of Government may open it or save an edit.
-- Edits are stored as a list of small ops (see client/job_manager.lua) and replayed on every
-- client at join, so a change is permanent and identical for everybody.

local Ops = {}        -- ordered list of { job = , op = {...} }
local Loaded = false

MySQL.ready(function()
    MySQL.Async.execute([[CREATE TABLE IF NOT EXISTS `uj_job_ops` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `job` VARCHAR(40) NOT NULL,
        `op` LONGTEXT NOT NULL,
        `by_name` VARCHAR(80) DEFAULT NULL,
        `created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (`id`)
    )]], {}, function()
        MySQL.Async.fetchAll('SELECT job, op FROM uj_job_ops ORDER BY id ASC', {}, function(rows)
            for _, r in ipairs(rows or {}) do
                local ok, op = pcall(json.decode, r.op)
                if ok and type(op) == 'table' then Ops[#Ops + 1] = { job = r.job, op = op } end
            end
            Loaded = true
        end)
    end)
end)

local function isChief(xPlayer)
    if not xPlayer or not xPlayer.job or xPlayer.job.name ~= 'government' then return false end
    local top = 0
    local jd = ESX.Jobs and ESX.Jobs['government']
    if jd and jd.grades then
        for g in pairs(jd.grades) do top = math.max(top, tonumber(g) or 0) end
    else
        top = 3
    end
    return (tonumber(xPlayer.job.grade) or 0) >= top
end

local function validJob(job)
    for _, d in ipairs(Departments or {}) do
        if d.id ~= 'gov' then
            for _, j in ipairs(d.jobs) do if j == job then return true end end
        end
    end
    return false
end

local function num(v) v = tonumber(v) return v and v == v and math.abs(v) < 100000 end
local function cleanPath(p) return type(p) == 'string' and #p > 0 and #p < 200 and not p:find('[^%w_/%-%. ]') end

local STYLE_OK = { MarkerType = true, MarkerTypeboss = true, MarkerTypeveh = true, MarkerTypevehdel = true,
                   DrawDistance = true, MarkerSize = true, MarkerColor = true }

-- the op has to look exactly like one of the four shapes; everything else is dropped
local function sanitize(op)
    if type(op) ~= 'table' then return nil end
    if op.op == 'set' and cleanPath(op.path) and num(op.x) and num(op.y) and num(op.z) then
        return { op = 'set', path = op.path, x = tonumber(op.x), y = tonumber(op.y), z = tonumber(op.z), h = tonumber(op.h) }
    elseif op.op == 'add' and cleanPath(op.sec) and num(op.x) and num(op.y) and num(op.z) then
        return { op = 'add', sec = op.sec, x = tonumber(op.x), y = tonumber(op.y), z = tonumber(op.z), h = tonumber(op.h) }
    elseif op.op == 'del' and cleanPath(op.path) then
        return { op = 'del', path = op.path }
    elseif op.op == 'cfg' and type(op.cfg) == 'string' and op.cfg:match('^Config_%a+$') and STYLE_OK[op.key] then
        if type(op.value) == 'table' then
            local v = {}
            for _, k in ipairs({ 'x', 'y', 'z', 'r', 'g', 'b' }) do if op.value[k] ~= nil and num(op.value[k]) then v[k] = tonumber(op.value[k]) end end
            return { op = 'cfg', cfg = op.cfg, key = op.key, value = v }
        elseif num(op.value) then
            return { op = 'cfg', cfg = op.cfg, key = op.key, value = tonumber(op.value) }
        end
    end
    return nil
end

ESX.RegisterServerCallback('ujjob:getOps', function(source, cb)
    local out = {}
    for _, o in ipairs(Ops) do out[#out + 1] = o.op end
    cb(out)
end)

RegisterNetEvent('ujjob:open')
AddEventHandler('ujjob:open', function()
    local src = source
    local x = ESX.GetPlayerFromId(src)
    if not isChief(x) then
        return TriggerClientEvent('esx:showNotification', src, '~r~Faghat Chief Of Government mitavanad /job ra baz konad.')
    end
    local off = {}
    for _, d in ipairs(Departments or {}) do
        for _, j in ipairs(d.jobs) do
            if OrgIsEnabled and OrgIsEnabled(j) == false then off[j] = true end
        end
    end
    TriggerClientEvent('ujjob:openOk', src, off)
end)

RegisterNetEvent('ujjob:save')
AddEventHandler('ujjob:save', function(job, op)
    local src = source
    local x = ESX.GetPlayerFromId(src)
    if not isChief(x) then return end
    if not Loaded or not validJob(job) then return end
    local clean = sanitize(op)
    if not clean then return end
    local by = GetPlayerName(src)
    MySQL.Async.execute('INSERT INTO uj_job_ops (job, op, by_name) VALUES (@j, @o, @b)',
        { ['@j'] = job, ['@o'] = json.encode(clean), ['@b'] = by }, function()
            Ops[#Ops + 1] = { job = job, op = clean }
            TriggerClientEvent('ujjob:op', -1, clean, #Ops)
        end)
    if SLog then SLog('JOBMANAGER', ('%s (%s) %s %s'):format(by, src, clean.op, job)) end
end)

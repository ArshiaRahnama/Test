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
    if job == 'jail' then return true end   -- jail zones (managed in /job, applied in Unique_AdminPanel)
    for _, d in ipairs(Departments or {}) do
        for _, j in ipairs(d.jobs) do if j == job then return true end end
    end
    return false
end

local function num(v) v = tonumber(v) return v and v == v and math.abs(v) < 100000 end
local function cleanPath(p) return type(p) == 'string' and #p > 0 and #p < 200 and not p:find('[^%w_/%-%. ]') end

local STYLE_OK = { MarkerType = true, MarkerTypeboss = true, MarkerTypeveh = true, MarkerTypevehdel = true,
                   DrawDistance = true, MarkerSize = true, MarkerColor = true }

-- the op has to look exactly like one of the four shapes; everything else is dropped
local function cleanId(v) return type(v) == 'string' and #v > 0 and #v < 50 and not v:find('[^%w_]') end
local function inr(v, lo, hi) v = tonumber(v) return v and v >= lo and v <= hi end
local function cleanText(v, max) v = tostring(v or ''):gsub('[^%w %-_%.]', ''):sub(1, max) return v end
local CATS = { Blip = true, Boss = true, Locker = true, Armory = true, Veh = true, ['V-Spawn'] = true, Heli = true, ['H-Spawn'] = true, Boat = true, ['B-Spawn'] = true, Other = true }

local function sanitize(op, job)
    if type(op) ~= 'table' then return nil end
    if op.op == 'blipadd' and cleanId(op.id) and num(op.x) and num(op.y) and num(op.z) and inr(op.sprite, 0, 900) and inr(op.color, 0, 90) and inr(op.scale, 0.1, 3) then
        return { op = 'blipadd', id = op.id, job = job, x = tonumber(op.x), y = tonumber(op.y), z = tonumber(op.z),
                 sprite = math.floor(tonumber(op.sprite)), color = math.floor(tonumber(op.color)), scale = tonumber(op.scale), label = cleanText(op.label, 40) }
    elseif op.op == 'blipdel' and cleanId(op.id) then
        return { op = 'blipdel', id = op.id, job = job }
    elseif op.op == 'bliphide' and num(op.x) and num(op.y) and num(op.z) then
        return { op = 'bliphide', job = job, x = tonumber(op.x), y = tonumber(op.y), z = tonumber(op.z) }
    elseif op.op == 'undecor' and cleanId(op.id) then
        return { op = 'undecor', id = op.id, job = job }
    elseif op.op == 'decor' and cleanId(op.id) and CATS[op.cat] and num(op.x) and num(op.y) and num(op.z)
        and (op.kind == 'marker' or op.kind == 'ped' or op.kind == 'object') then
        local model
        if op.kind == 'marker' then
            if not inr(op.model, 0, 43) then return nil end
            model = math.floor(tonumber(op.model))
        else
            if type(op.model) ~= 'string' or #op.model < 1 or #op.model > 60 or op.model:find('[^%w_]') then return nil end
            model = op.model
        end
        return { op = 'decor', id = op.id, job = job, cat = op.cat, sec = cleanPath(op.sec) and op.sec or nil, kind = op.kind, model = model,
                 x = tonumber(op.x), y = tonumber(op.y), z = tonumber(op.z), h = tonumber(op.h) or 0.0,
                 r = inr(op.r, 0, 255) and math.floor(tonumber(op.r)) or 212, g = inr(op.g, 0, 255) and math.floor(tonumber(op.g)) or 175, b = inr(op.b, 0, 255) and math.floor(tonumber(op.b)) or 55,
                 sx = inr(op.sx, 0.1, 20) and tonumber(op.sx) or 1.5, sy = inr(op.sy, 0.1, 20) and tonumber(op.sy) or 1.5, sz = inr(op.sz, 0.1, 20) and tonumber(op.sz) or 0.8 }
    end
    if op.op == 'set' and cleanPath(op.path) and num(op.x) and num(op.y) and num(op.z) then
        return { op = 'set', path = op.path, x = tonumber(op.x), y = tonumber(op.y), z = tonumber(op.z), h = tonumber(op.h) }
    elseif op.op == 'jailorg' and inr(op.zone, 1, 500) and cleanId(op.org) and type(op.enabled) == 'boolean' then
        return { op = 'jailorg', zone = math.floor(tonumber(op.zone)), org = op.org, enabled = op.enabled }
    elseif op.op == 'zonehide' and cleanPath(op.path) then
        return { op = 'zonehide', path = op.path }
    elseif op.op == 'add' and cleanPath(op.sec) and num(op.x) and num(op.y) and num(op.z) then
        return { op = 'add', sec = op.sec, org = cleanId(op.org) and op.org or nil, tpl = cleanPath(op.tpl) and op.tpl or nil, sfx = (type(op.sfx) == 'string' and not op.sfx:find('[^%d]') and #op.sfx < 16) and op.sfx or nil, x = tonumber(op.x), y = tonumber(op.y), z = tonumber(op.z), h = tonumber(op.h) }
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

-- UNDO LAST / RESET ORGAN: remove saved ops of one organisation, then every client rebuilds it
local function rebuild(job)
    local mine = {}
    for _, o in ipairs(Ops) do if o.job == job then mine[#mine + 1] = o.op end end
    TriggerClientEvent('ujjob:rebuild', -1, job, mine, #Ops)
end

RegisterNetEvent('ujjob:undo')
AddEventHandler('ujjob:undo', function(job)
    local src = source
    if not isChief(ESX.GetPlayerFromId(src)) or not Loaded or not validJob(job) then return end
    local idx
    for i = #Ops, 1, -1 do if Ops[i].job == job then idx = i break end end
    if not idx then return end
    table.remove(Ops, idx)
    MySQL.Async.execute('DELETE FROM uj_job_ops WHERE job = @j ORDER BY id DESC LIMIT 1', { ['@j'] = job }, function() rebuild(job) end)
end)

RegisterNetEvent('ujjob:reset')
AddEventHandler('ujjob:reset', function(job)
    local src = source
    if not isChief(ESX.GetPlayerFromId(src)) or not Loaded or not validJob(job) then return end
    for i = #Ops, 1, -1 do if Ops[i].job == job then table.remove(Ops, i) end end
    MySQL.Async.execute('DELETE FROM uj_job_ops WHERE job = @j', { ['@j'] = job }, function() rebuild(job) end)
end)

RegisterNetEvent('ujjob:save')
AddEventHandler('ujjob:save', function(job, op)
    local src = source
    local x = ESX.GetPlayerFromId(src)
    if not isChief(x) then return end
    if not Loaded or not validJob(job) then return end
    local clean = sanitize(op, job)
    if not clean then return end
    local by = GetPlayerName(src)
    MySQL.Async.execute('INSERT INTO uj_job_ops (job, op, by_name) VALUES (@j, @o, @b)',
        { ['@j'] = job, ['@o'] = json.encode(clean), ['@b'] = by }, function()
            Ops[#Ops + 1] = { job = job, op = clean }
            TriggerClientEvent('ujjob:op', -1, clean, #Ops)
        end)
    if SLog then SLog('JOBMANAGER', ('%s (%s) %s %s'):format(by, src, clean.op, job)) end
end)

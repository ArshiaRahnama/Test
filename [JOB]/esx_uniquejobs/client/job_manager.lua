-- =====================================================================
-- /job  -  Government (Chief Of Government only) organisation point editor.
-- The window itself is the Unique_JobManager resource. This file:
--   * reads every blip / marker / spawn point out of the Config_<job> tables
--   * applies saved edits ("ops") on top of them (on join + live)
--   * turns NUI clicks into ops which the server saves + broadcasts
-- An op is plain data:  set / add / del (a point)  or  cfg (marker style).
-- The config tables are changed IN PLACE, so every loop that already reads them
-- (markers, armory, garage ...) uses the new position at once.
-- =====================================================================

local REG = {
    { job = 'cid',       label = 'CID',       cfg = 'Config_cid' },
    { job = 'cia',       label = 'CIA',       cfg = 'Config_cia' },
    { job = 'marshal',   label = 'Marshal',   cfg = 'Config_marshal' },
    { job = 'fbi',       label = 'FBI',       cfg = 'Config_fbi' },
    { job = 'judge',     label = 'Judge',     cfg = 'Config_judge' },
    { job = 'doa',       label = 'DOA',       cfg = 'Config_doa' },
    { job = 'police',    label = 'Police',    cfg = 'Config_police' },
    { job = 'sheriff',   label = 'Sheriff',   cfg = 'Config_sheriff' },
    { job = 'mt',        label = 'MT',        cfg = 'Config_mt' },
    { job = 'taxi',      label = 'Taxi',      cfg = 'Config_taxi' },
    { job = 'mechanic',  label = 'Mechanic',  cfg = 'Config_mechanic' },
    { job = 'ambulance', label = 'Medic',     cfg = 'Config_ambulance' },
    { job = 'weazel',    label = 'Weazel',    cfg = 'Config_weazel' },
}
local BYJOB = {}
for _, r in ipairs(REG) do BYJOB[r.job] = r end

-- tables inside a config that are NOT positions (sizes, colours, big lists)
local SKIP = { Marker = true, MarkerSize = true, MarkerColor = true, MarkerDeletersColor = true,
               Size = true, Scale = true, Color = true, Uniforms = true, NPCJobEarnings = true }
local function skipKey(k)
    if type(k) ~= 'string' then return false end
    return SKIP[k] or k:sub(1, 10) == 'Authorized' or k:sub(1, 11) == 'Blacklisted'
end

local STYLE_KEYS = { MarkerType = true, MarkerTypeboss = true, MarkerTypeveh = true, MarkerTypevehdel = true, DrawDistance = true }

local function isPoint(v)
    local t = type(v)
    if t == 'vector3' or t == 'vector4' then return true end
    if t == 'table' then return tonumber(v.x) ~= nil and tonumber(v.y) ~= nil and tonumber(v.z) ~= nil end
    return false
end

local function isArray(t)
    return type(t) == 'table' and t[1] ~= nil
end

local function headingKey(v)
    if type(v) ~= 'table' then return nil end
    if v.heading ~= nil then return 'heading' end
    if v.Heading ~= nil then return 'Heading' end
    if v.h ~= nil then return 'h' end
    return nil
end

local function category(path)
    local p = path:lower()
    if p:find('blip') then return 'Blip' end
    if p:find('boss') then return 'Boss' end
    if p:find('cloak') then return 'Locker' end
    if p:find('armor') then return 'Armory' end
    if p:find('heli') then return p:find('spawnpoint') and 'H-Spawn' or 'Heli' end
    if p:find('boat') then return p:find('spawnpoint') and 'B-Spawn' or 'Boat' end
    if p:find('spawnpoint') then return 'V-Spawn' end
    if p:find('vehicle') or p:find('spawner') or p:find('delet') then return 'Veh' end
    return 'Other'
end

-- ---------------------------------------------------------------- path helpers
local function split(path)
    local out = {}
    for seg in tostring(path):gmatch('[^/]+') do out[#out + 1] = seg end
    return out
end

local function child(t, seg)
    if type(t) ~= 'table' then return nil, nil end
    local n = tonumber(seg)
    if n and t[n] ~= nil then return t[n], n end
    if t[seg] ~= nil then return t[seg], seg end
    return nil, nil
end

-- returns value, parent, key
local function resolve(path)
    local segs = split(path)
    local cfgName = segs[1]
    local node = _G[cfgName]
    if type(node) ~= 'table' then return nil end
    local parent, key = nil, nil
    for i = 2, #segs do
        local nxt, k = child(node, segs[i])
        if nxt == nil then return nil end
        parent, key, node = node, k, nxt
    end
    return node, parent, key
end

local function deepCopy(v)
    if type(v) ~= 'table' then return v end
    local o = {}
    for k, x in pairs(v) do o[k] = deepCopy(x) end
    return o
end

local function writePoint(v, x, y, z, h)
    if type(v) == 'vector3' then return vector3(x, y, z) end
    if type(v) == 'vector4' then return vector4(x, y, z, h or v.w) end
    v.x, v.y, v.z = x, y, z
    local hk = headingKey(v)
    if hk and h then v[hk] = h end
    return v
end

local function setAllPoints(t, x, y, z, h)
    if type(t) ~= 'table' then return end
    if isPoint(t) then writePoint(t, x, y, z, h) return end
    for k, v in pairs(t) do
        if type(v) == 'table' and not skipKey(k) then
            if isPoint(v) then writePoint(v, x, y, z, h) else setAllPoints(v, x, y, z, h) end
        end
    end
end

-- ----------------------------------------------------------------- apply an op
local function applyOp(op)
    if type(op) ~= 'table' then return end
    local ok, err = pcall(function()
        if op.op == 'set' then
            local v, parent, key = resolve(op.path)
            if v == nil or not parent then return end
            local nv = writePoint(v, tonumber(op.x), tonumber(op.y), tonumber(op.z), tonumber(op.h))
            parent[key] = nv
        elseif op.op == 'add' then
            local list = resolve(op.sec)
            if type(list) ~= 'table' then return end
            local x, y, z, h = tonumber(op.x), tonumber(op.y), tonumber(op.z), tonumber(op.h)
            local last = list[#list]
            if last == nil then
                list[1] = { x = x, y = y, z = z }
            elseif type(last) == 'vector3' or type(last) == 'vector4' then
                list[#list + 1] = writePoint(last, x, y, z, h)
            else
                local clone = deepCopy(last)
                setAllPoints(clone, x, y, z, h)
                list[#list + 1] = clone
            end
        elseif op.op == 'del' then
            local v, parent, key = resolve(op.path)
            if v == nil or not parent then return end
            if type(key) == 'number' and isArray(parent) then table.remove(parent, key) else parent[key] = nil end
        elseif op.op == 'cfg' then
            local cfg = _G[op.cfg]
            if type(cfg) ~= 'table' then return end
            if op.key == 'MarkerSize' and type(op.value) == 'table' then
                cfg.MarkerSize = { x = tonumber(op.value.x) or 1.5, y = tonumber(op.value.y) or 1.5, z = tonumber(op.value.z) or 1.0 }
            elseif op.key == 'MarkerColor' and type(op.value) == 'table' then
                local c = cfg.MarkerColor or {}
                cfg.MarkerColor = { r = tonumber(op.value.r) or c.r or 255, g = tonumber(op.value.g) or c.g or 255, b = tonumber(op.value.b) or c.b or 255 }
            elseif STYLE_KEYS[op.key] and tonumber(op.value) then
                cfg[op.key] = tonumber(op.value)
            end
        end
    end)
    if not ok then print(('[UJ][JOBMANAGER] op failed: %s'):format(tostring(err))) end
end

-- ------------------------------------------------------------ read all points
local function collect(cfgName, node, path, arrPath, delPath, out, depth)
    if depth > 7 or type(node) ~= 'table' then return end
    for k, v in pairs(node) do
        if not skipKey(k) and (type(v) == 'table' or type(v) == 'vector3' or type(v) == 'vector4') then
            local p = path .. '/' .. tostring(k)
            local isArr = type(k) == 'number'
            local nArr = isArr and path or arrPath       -- nearest list that holds this element
            local nDel = isArr and p or delPath          -- element to delete
            if isPoint(v) then
                local rec = { id = p, cat = category(p), x = v.x + 0.0, y = v.y + 0.0, z = v.z + 0.0 }
                local hk = headingKey(v)
                if hk then rec.h = tonumber(v[hk]) elseif type(v) == 'vector4' then rec.h = v.w end
                rec.sec = nArr
                rec.del = nDel
                local parts = split(p)
                rec.label = table.concat(parts, ' > ', 2)
                out[#out + 1] = rec
            else
                collect(cfgName, v, p, nArr, nDel, out, depth + 1)
            end
        end
    end
end

local function snapshotOrg(r)
    local cfg = _G[r.cfg]
    if type(cfg) ~= 'table' then return nil end
    local pts = {}
    collect(r.cfg, cfg, r.cfg, nil, nil, pts, 0)
    table.sort(pts, function(a, b) return a.id < b.id end)
    local style = {}
    for k in pairs(STYLE_KEYS) do style[k] = cfg[k] end
    if type(cfg.MarkerSize) == 'table' then style.sx, style.sy, style.sz = cfg.MarkerSize.x, cfg.MarkerSize.y, cfg.MarkerSize.z end
    if type(cfg.MarkerColor) == 'table' then style.r, style.g, style.b = cfg.MarkerColor.r, cfg.MarkerColor.g, cfg.MarkerColor.b end
    return { job = r.job, label = r.label, points = pts, style = style }
end

local OpCount = 0
local OffJobs = {}
local Open = false

local function buildPayload(toast)
    local orgs = {}
    for _, r in ipairs(REG) do
        local o = snapshotOrg(r)
        if o then
            o.off = OffJobs[r.job] == true
            orgs[#orgs + 1] = o
        end
    end
    local depts = {}
    for _, d in ipairs(Departments or {}) do
        if d.id ~= 'gov' then depts[#depts + 1] = { id = d.id, label = d.label, jobs = d.jobs } end
    end
    return { orgs = orgs, depts = depts, ops = OpCount, who = 'GOVERNMENT', toast = toast }
end

local function refreshUI(toast)
    if Open then pcall(function() exports['Unique_JobManager']:Update(buildPayload(toast)) end) end
end

-- ----------------------------------------------------------- server <-> client
RegisterNetEvent('ujjob:op')
AddEventHandler('ujjob:op', function(op, count)
    applyOp(op)
    OpCount = tonumber(count) or OpCount
    refreshUI('Zakhire shod')
end)

RegisterNetEvent('ujjob:openOk')
AddEventHandler('ujjob:openOk', function(off)
    OffJobs = off or {}
    Open = true
    exports['Unique_JobManager']:Open(buildPayload())
end)

AddEventHandler('ujjob:closed', function() Open = false end)

-- replay every saved edit on top of the base config (join / resource restart)
CreateThread(function()
    while ESX == nil do Wait(500) end
    Wait(2500)
    ESX.TriggerServerCallback('ujjob:getOps', function(ops)
        for _, op in ipairs(ops or {}) do applyOp(op) end
        OpCount = #(ops or {})
    end)
end)

RegisterCommand('job', function()
    TriggerServerEvent('ujjob:open')
end, false)

-- ------------------------------------------------------------------ NUI actions
local function myPos()
    local ped = PlayerPedId()
    local c = GetEntityCoords(ped)
    return math.floor(c.x * 100) / 100, math.floor(c.y * 100) / 100, math.floor(c.z * 100) / 100, math.floor(GetEntityHeading(ped) * 100) / 100
end

local function validJob(j) return type(j) == 'string' and BYJOB[j] ~= nil end
local function validPath(job, p)
    return type(p) == 'string' and #p < 200 and p:sub(1, #BYJOB[job].cfg) == BYJOB[job].cfg and not p:find('[^%w_/%-%. ]')
end

AddEventHandler('ujjob:nui', function(d)
    if type(d) ~= 'table' or not validJob(d.job) and d.a ~= 'noop' then return end
    local a = d.a
    if a == 'goto' then
        local v = resolve(d.id)
        if v and isPoint(v) then
            local ped = PlayerPedId()
            SetEntityCoords(ped, v.x + 0.0, v.y + 0.0, v.z + 0.0, false, false, false, false)
        end
    elseif a == 'set' then
        if not validPath(d.job, d.id) then return end
        local x, y, z, h = myPos()
        TriggerServerEvent('ujjob:save', d.job, { op = 'set', path = d.id, x = x, y = y, z = z, h = h })
    elseif a == 'add' then
        if not validPath(d.job, d.sec) then return end
        local x, y, z, h = myPos()
        TriggerServerEvent('ujjob:save', d.job, { op = 'add', sec = d.sec, x = x, y = y, z = z, h = h })
    elseif a == 'del' then
        if not validPath(d.job, d.id) then return end
        TriggerServerEvent('ujjob:save', d.job, { op = 'del', path = d.id })
    elseif a == 'style' then
        local r = BYJOB[d.job]
        local v = type(d.values) == 'table' and d.values or {}
        for k in pairs(STYLE_KEYS) do
            if tonumber(v[k]) then TriggerServerEvent('ujjob:save', d.job, { op = 'cfg', cfg = r.cfg, key = k, value = tonumber(v[k]) }) end
        end
        if v.sx or v.sy or v.sz then
            local cur = _G[r.cfg] and _G[r.cfg].MarkerSize or {}
            TriggerServerEvent('ujjob:save', d.job, { op = 'cfg', cfg = r.cfg, key = 'MarkerSize',
                value = { x = tonumber(v.sx) or cur.x, y = tonumber(v.sy) or cur.y, z = tonumber(v.sz) or cur.z } })
        end
        if v.r or v.g or v.b then
            TriggerServerEvent('ujjob:save', d.job, { op = 'cfg', cfg = r.cfg, key = 'MarkerColor',
                value = { r = tonumber(v.r), g = tonumber(v.g), b = tonumber(v.b) } })
        end
    end
end)

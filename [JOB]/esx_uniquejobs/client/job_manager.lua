-- =====================================================================
-- /job  -  Government (Chief Of Government only) organisation point editor.
-- The window is jobmanager/html (an iframe hosted by ui.html). This file:
--   * reads every blip / marker / spawn point out of the Config_<job> tables
--   * applies saved edits ("ops") on top of them (on join + live)
--   * turns NUI clicks into ops which the server saves + broadcasts
-- An op is plain data:  set / add / del (a point)  or  cfg (marker style).
-- The config tables are changed IN PLACE, so every loop that already reads them
-- (markers, armory, garage ...) uses the new position at once.
-- =====================================================================

Config_jail = { Zones = {} }   -- filled from Unique_AdminPanel (jail zones) at start

local REG = {
    { job = 'government', label = 'Government', cfg = 'Config_government' },
    { job = 'jail',       label = 'Jail Zones', cfg = 'Config_jail' },
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
    if p:find('config_jail') then return 'Jail' end
    if p:find('config_duty') then return 'Duty' end
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

-- ------------------------------------------------- custom blips / hidden blips / decor
local CBlips, Hidden, Decor = {}, {}, {}     -- data (replayed from the saved ops)
local BlipHandles, DecorEnts = {}, {}        -- live handles
local BLIP_SCALE = 0.8                       -- every organisation blip is shown at this size

-- DOJ organisations show "Department Of Justice", Law organisations show "Law Enforcement" on the map
local function defaultBlipName(job)
    for _, d in ipairs(Departments or {}) do
        for _, j in ipairs(d.jobs) do if j == job then return d.label end end
    end
    return nil
end
-- default = the department name (Department Of Justice / Law Enforcement / Organ Services / Government);
-- a name typed in /job replaces it
local function blipName(b)
    if b.label and b.label ~= '' then return b.label end
    return defaultBlipName(b.job) or 'Blip'
end

local function militaryJobs()
    local out = {}
    for _, d in ipairs(Departments or {}) do
        if d.id == 'doj' or d.id == 'le' then for _, j in ipairs(d.jobs) do out[j] = true end end
    end
    return out
end

local function removeCustomBlip(id)
    local h = BlipHandles[id]
    if h and DoesBlipExist(h) then RemoveBlip(h) end
    BlipHandles[id] = nil
end
local function removeDecorEntity(id)
    local e = DecorEnts[id]
    if e and DoesEntityExist(e) then
        pcall(function() exports.ox_target:removeLocalEntity(e) end)
        DeleteEntity(e)
    end
    DecorEnts[id] = nil
end
local function clearJobVisuals(job)
    for id, b in pairs(CBlips) do if b.job == job then removeCustomBlip(id) CBlips[id] = nil end end
    for id, d in pairs(Decor) do if d.job == job then removeDecorEntity(id) Decor[id] = nil end end
    for i = #Hidden, 1, -1 do if Hidden[i].job == job then table.remove(Hidden, i) end end
end

local function isHidden(job, x, y, z)
    for _, h in ipairs(Hidden) do
        if h.job == job and math.abs(h.x - x) < 1.0 and math.abs(h.y - y) < 1.0 then return true end
    end
    return false
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
        elseif op.op == 'jailorg' then
            local z = Config_jail and Config_jail.Zones and Config_jail.Zones[tonumber(op.zone)]
            if type(z) ~= 'table' then return end
            if z.orgs == nil then z.orgs = militaryJobs() end   -- a shared zone becomes an explicit list first
            z.orgs[op.org] = op.enabled and true or nil
        elseif op.op == 'zonehide' then
            local z = resolve(op.path)
            if type(z) == 'table' and type(z.Pos) == 'table' then z.Pos.x, z.Pos.y, z.Pos.z = 0.0, 0.0, -5000.0 end
        elseif op.op == 'add' and op.tpl then
            local zones, tpl = resolve(op.sec), resolve(op.tpl)
            if type(zones) ~= 'table' or type(tpl) ~= 'table' then return end
            local base = split(op.tpl)[3]:gsub('__%d+$', '')
            local clone = deepCopy(tpl)
            setAllPoints(clone, tonumber(op.x), tonumber(op.y), tonumber(op.z), tonumber(op.h))
            zones[base .. '__' .. tostring(op.sfx or '1')] = clone
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
                if op.org and type(op.sec) == 'string' and op.sec:sub(1, 11) == 'Config_jail' then clone.orgs = { [op.org] = true } end
                list[#list + 1] = clone
            end
        elseif op.op == 'del' then
            local v, parent, key = resolve(op.path)
            if v == nil or not parent then return end
            if type(key) == 'number' and isArray(parent) then table.remove(parent, key) else parent[key] = nil end
        elseif op.op == 'blipadd' then
            removeCustomBlip(op.id)
            CBlips[op.id] = { id = op.id, job = op.job, x = op.x, y = op.y, z = op.z,
                              sprite = op.sprite, color = op.color, scale = op.scale, label = op.label }
        elseif op.op == 'blipdel' then
            removeCustomBlip(op.id) CBlips[op.id] = nil
        elseif op.op == 'bliphide' then
            Hidden[#Hidden + 1] = { job = op.job, x = op.x, y = op.y, z = op.z }
        elseif op.op == 'decor' then
            removeDecorEntity(op.id) Decor[op.id] = op
        elseif op.op == 'undecor' then
            removeDecorEntity(op.id) Decor[op.id] = nil
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
                local zp = split(p)
                if zp[2] == 'Zones' and zp[3] then            -- name-keyed zones (taxi / mechanic / weazel)
                    local zonePath = zp[1] .. '/Zones/' .. zp[3]
                    rec.sec, rec.tpl = zp[1] .. '/Zones', zonePath
                    if zp[3]:find('__%d+$') then rec.zoneDel = zonePath      -- a zone we added: real delete
                    else rec.zoneHide = zonePath end                           -- original: hidden (code uses it by name)
                    nArr, nDel = nil, nil
                end
                local hk = headingKey(v)
                if hk then rec.h = tonumber(v[hk]) elseif type(v) == 'vector4' then rec.h = v.w end
                rec.sec = rec.sec or nArr
                rec.del = rec.zoneDel or nDel
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
    local dz = type(Config_duty) == 'table' and Config_duty.Zones and Config_duty.Zones[r.job]
    if dz and isPoint(dz.Pos) then
        local pp = dz.Pos
        pts[#pts + 1] = { id = 'Config_duty/Zones/' .. r.job .. '/Pos', cat = 'Duty', label = 'Duty point (on / off duty)',
                          x = pp.x + 0.0, y = pp.y + 0.0, z = pp.z + 0.0 }
    end
    local jailOther
    if militaryJobs()[r.job] and Config_jail and type(Config_jail.Zones) == 'table' then
        jailOther = {}
        for i, z in ipairs(Config_jail.Zones) do
            if z.orgs == nil or z.orgs[r.job] then
                pts[#pts + 1] = { id = 'Config_jail/Zones/' .. i .. '/coords', cat = 'Jail', label = ('Jail zone %d - jail point'):format(i),
                                  x = z.coords.x + 0.0, y = z.coords.y + 0.0, z = z.coords.z + 0.0, sec = 'Config_jail/Zones', jailOrg = r.job, zone = i }
                pts[#pts + 1] = { id = 'Config_jail/Zones/' .. i .. '/unjail', cat = 'Jail', label = ('Jail zone %d - release point'):format(i),
                                  x = z.unjail.x + 0.0, y = z.unjail.y + 0.0, z = z.unjail.z + 0.0, sec = 'Config_jail/Zones', jailOrg = r.job, zone = i }
            else
                jailOther[#jailOther + 1] = { zone = i, x = z.coords.x + 0.0, y = z.coords.y + 0.0, z = z.coords.z + 0.0 }
            end
        end
    end
    local kept = {}
    for _, p in ipairs(pts) do
        if p.cat == 'Blip' then
            if not isHidden(r.job, p.x, p.y, p.z) then p.blip = true p.del = nil kept[#kept + 1] = p end
        else
            kept[#kept + 1] = p
        end
    end
    pts = kept
    table.sort(pts, function(a, b) return a.id < b.id end)
    for id, b in pairs(CBlips) do
        if b.job == r.job then
            pts[#pts + 1] = { id = 'cb:' .. id, cid = id, custom = 'blip', cat = 'Blip', label = blipName(b) .. ' (custom)',
                              x = b.x, y = b.y, z = b.z, sprite = b.sprite, color = b.color, scale = b.scale }
        end
    end
    for id, d in pairs(Decor) do
        if d.job == r.job then
            pts[#pts + 1] = { id = 'dc:' .. id, cid = id, custom = 'decor', cat = d.cat or 'Other', label = (d.kind or '?') .. ' | ' .. tostring(d.model),
                              x = d.x, y = d.y, z = d.z, h = d.h, kind = d.kind, model = d.model,
                              r = d.r, g = d.g, b = d.b, sx = d.sx, sy = d.sy, sz = d.sz }
        end
    end
    local secs = {}
    local SECKEYS = { Boss = 'BossActions', Locker = 'Cloakrooms', Armory = 'Armories' }
    local function findSec(node, path, depth)
        if depth > 5 or type(node) ~= 'table' then return end
        for k, v in pairs(node) do
            if type(k) == 'string' and type(v) == 'table' and not skipKey(k) then
                for cat, key in pairs(SECKEYS) do
                    if k == key and not secs[cat] and (next(v) == nil or isArray(v)) then secs[cat] = path .. '/' .. k end
                end
                if not isPoint(v) then findSec(v, path .. '/' .. k, depth + 1) end
            end
        end
    end
    findSec(cfg, r.cfg, 0)
    local style = {}
    for k in pairs(STYLE_KEYS) do style[k] = cfg[k] end
    if type(cfg.MarkerSize) == 'table' then style.sx, style.sy, style.sz = cfg.MarkerSize.x, cfg.MarkerSize.y, cfg.MarkerSize.z end
    if type(cfg.MarkerColor) == 'table' then style.r, style.g, style.b = cfg.MarkerColor.r, cfg.MarkerColor.g, cfg.MarkerColor.b end
    return { job = r.job, label = r.label, points = pts, style = style, secs = secs, jailOther = jailOther }
end

-- untouched copy of every organisation config, taken before the first saved edit is applied
local Baseline = {}
local BaselineDuty
local function snapshotBaselines()
    if BaselineDuty == nil and type(Config_duty) == 'table' and Config_duty.Zones then BaselineDuty = deepCopy(Config_duty.Zones) end
    for _, r in ipairs(REG) do
        if Baseline[r.job] == nil and type(_G[r.cfg]) == 'table' then Baseline[r.job] = deepCopy(_G[r.cfg]) end
    end
end

-- put `src` back into `dst` WITHOUT replacing the table objects other scripts already hold
local function restoreInto(dst, src)
    for k in pairs(dst) do if src[k] == nil then dst[k] = nil end end
    for k, v in pairs(src) do
        local cur = dst[k]
        if type(v) == 'table' and type(cur) == 'table' and not isPoint(v) then
            restoreInto(cur, v)
        else
            dst[k] = deepCopy(v)
        end
    end
end

local OpCount = 0
local OffJobs = {}
local Open = false
local LevelInfo = {}   -- [job] = { level, pending, who }  (Government only)

-- ---- window (html in jobmanager/html, hosted as an iframe by ui.html) ----
local function nuiOpen(payload)
    Open = true
    SetNuiFocus(true, true)
    SendNUIMessage({ _type = 'setUiFocusOwner', owner = 'jobmanager' })
    SendNUIMessage({ type = 'jm_open', data = payload })
end
local function nuiUpdate(payload) if Open then SendNUIMessage({ type = 'jm_update', data = payload }) end end
local function nuiClose()
    if not Open then return end
    Open = false
    SetNuiFocus(false, false)
    SendNUIMessage({ type = 'jm_close' })
    SendNUIMessage({ _type = 'setUiFocusOwner', owner = 'none' })
end
RegisterNUICallback('jm_close', function(_, cb) nuiClose() cb('ok') end)
RegisterNUICallback('jm_action', function(data, cb) TriggerEvent('ujjob:nui', data) cb('ok') end)
AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() and Open then SetNuiFocus(false, false) end
end)

local function buildPayload(toast)
    local orgs = {}
    for _, r in ipairs(REG) do
        local o = snapshotOrg(r)
        if o then
            o.off = OffJobs[r.job] == true
            o.blipName = defaultBlipName(r.job)
            local li = LevelInfo[r.job]
            if li then o.minLevel, o.pendingLevel, o.pendingBy = li.level, li.pending, li.who end
            orgs[#orgs + 1] = o
        end
    end
    local depts = {}
    for _, d in ipairs(Departments or {}) do
        depts[#depts + 1] = { id = d.id, label = d.label, jobs = d.jobs }
    end
    depts[#depts + 1] = { id = 'jail', label = 'Jail', jobs = { 'jail' } }
    return { orgs = orgs, depts = depts, ops = OpCount, who = 'GOVERNMENT', toast = toast }
end

local function refreshUI(toast)
    if Open then nuiUpdate(buildPayload(toast)) end
end

-- ----------------------------------------------------------- server <-> client
function pushJail()
    local list = {}
    for i, z in ipairs((Config_jail and Config_jail.Zones) or {}) do
        list[i] = { coords = z.coords, radius = z.radius, unjail = z.unjail, cutscene = z.cutscene, orgs = z.orgs }
    end
    TriggerEvent('ujjob:jailZones', list)
end

RegisterNetEvent('ujjob:op')
AddEventHandler('ujjob:op', function(op, count)
    applyOp(op)
    if op.op == 'jailorg' or (op.path and op.path:sub(1, 11) == 'Config_jail') or (op.sec and op.sec:sub(1, 11) == 'Config_jail') then pushJail() end
    OpCount = tonumber(count) or OpCount
    refreshUI('Zakhire shod')
end)

RegisterNetEvent('ujjob:rebuild')
AddEventHandler('ujjob:rebuild', function(job, ops, count)
    local r = BYJOB[job]
    clearJobVisuals(job)
    if r and Baseline[job] and type(_G[r.cfg]) == 'table' then
        restoreInto(_G[r.cfg], Baseline[job])
        if BaselineDuty and BaselineDuty[job] and Config_duty.Zones[job] then restoreInto(Config_duty.Zones[job], BaselineDuty[job]) end
        for _, op in ipairs(ops or {}) do applyOp(op) end
        if job == 'jail' then pushJail() end
    end
    OpCount = tonumber(count) or OpCount
    refreshUI('Anjam shod')
end)

AddEventHandler('org_state:changed', function(job, enabled)
    OffJobs[job] = (enabled == false) and true or nil
    refreshUI()
end)

RegisterNetEvent('ujjob:openOk')
AddEventHandler('ujjob:openOk', function(off)
    OffJobs = off or {}
    ESX.TriggerServerCallback('ujrec:levelAll', function(m)
        LevelInfo = m or {}
        nuiOpen(buildPayload())
    end)
end)

-- replay every saved edit on top of the base config (join / resource restart)
CreateThread(function()
    while ESX == nil do Wait(500) end
    Wait(2500)
    pcall(function() Config_jail.Zones = exports['Unique_AdminPanel']:GetJailZones() or {} end)
    snapshotBaselines()
    ESX.TriggerServerCallback('ujjob:getOps', function(ops)
        for _, op in ipairs(ops or {}) do applyOp(op) end
        OpCount = #(ops or {})
        pushJail()
    end)
end)

RegisterCommand('job', function()
    TriggerServerEvent('ujjob:open')
end, false)

-- ------------------------------------------------------------------ NUI actions
-- ops about the jail zones are stored under the 'jail' job (not under the organisation that clicked)
local function saveJob(job, path)
    if type(path) == 'string' and path:sub(1, 11) == 'Config_jail' then return 'jail' end
    return job
end

local function newId() return ('%d_%d'):format(GetGameTimer(), math.random(1000, 9999)) end

local function myPos()
    local ped = PlayerPedId()
    local c = GetEntityCoords(ped)
    return math.floor(c.x * 100) / 100, math.floor(c.y * 100) / 100, math.floor(c.z * 100) / 100, math.floor(GetEntityHeading(ped) * 100) / 100
end

local function validJob(j) return type(j) == 'string' and BYJOB[j] ~= nil end
local function validPath(job, p)
    if type(p) ~= 'string' or #p >= 200 or p:find('[^%w_/%-%. ]') then return false end
    if p:sub(1, #BYJOB[job].cfg) == BYJOB[job].cfg then return true end
    if p:sub(1, 12) == 'Config_jail/' then return true end
    local duty = 'Config_duty/Zones/' .. job .. '/'
    return p:sub(1, #duty) == duty
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
    elseif a == 'gocoord' then
        if tonumber(d.x) and tonumber(d.y) and tonumber(d.z) then
            SetEntityCoords(PlayerPedId(), d.x + 0.0, d.y + 0.0, d.z + 0.0, false, false, false, false)
        end
    elseif a == 'set' then
        if not validPath(d.job, d.id) then return end
        local x, y, z, h = myPos()
        TriggerServerEvent('ujjob:save', saveJob(d.job, d.id), { op = 'set', path = d.id, x = x, y = y, z = z, h = h })
    elseif a == 'add' then
        local x, y, z, h = myPos()
        local v = d.visual
        local targetOnly = type(v) == 'table' and (v.kind == 'ped' or v.kind == 'object')
        -- a ped / object works through ox_target only: no config point is copied, so the
        -- organisation's own marker and E-key never appear there
        if d.sec and validPath(d.job, d.sec) and not targetOnly then
            TriggerServerEvent('ujjob:save', saveJob(d.job, d.sec), { op = 'add', sec = d.sec, tpl = (d.tpl and validPath(d.job, d.tpl)) and d.tpl or nil,
                org = (saveJob(d.job, d.sec) == 'jail') and d.job or nil, sfx = tostring(GetGameTimer()), x = x, y = y, z = z, h = h })
        end
        if type(v) == 'table' and (v.kind == 'ped' or v.kind == 'object') then
            TriggerServerEvent('ujjob:save', d.job, { op = 'decor', id = newId(), cat = tostring(d.cat or 'Other'), sec = (d.sec and validPath(d.job, d.sec)) and d.sec or nil, kind = v.kind, model = v.model,
                x = x, y = y, z = z, h = h, r = tonumber(v.r) or 212, g = tonumber(v.g) or 175, b = tonumber(v.b) or 55,
                sx = tonumber(v.sx) or 1.5, sy = tonumber(v.sy) or 1.5, sz = tonumber(v.sz) or 0.8 })
        end
    elseif a == 'decoredit' then
        local cur = Decor[tostring(d.cid)]
        local v = d.visual
        if cur and type(v) == 'table' and (v.kind == 'ped' or v.kind == 'object') then
            TriggerServerEvent('ujjob:save', d.job, { op = 'decor', id = cur.id, cat = cur.cat, sec = cur.sec, kind = v.kind, model = v.model,
                x = cur.x, y = cur.y, z = cur.z, h = cur.h, r = tonumber(v.r) or cur.r, g = tonumber(v.g) or cur.g, b = tonumber(v.b) or cur.b,
                sx = tonumber(v.sx) or cur.sx, sy = tonumber(v.sy) or cur.sy, sz = tonumber(v.sz) or cur.sz })
        end
    elseif a == 'jailaccess' then
        if militaryJobs()[d.job] and tonumber(d.zone) then
            TriggerServerEvent('ujjob:save', 'jail', { op = 'jailorg', zone = math.floor(tonumber(d.zone)), org = d.job, enabled = d.enabled == true })
        end
    elseif a == 'zonehide' then
        if validPath(d.job, d.id) then TriggerServerEvent('ujjob:save', d.job, { op = 'zonehide', path = d.id }) end
    elseif a == 'undecor' then
        TriggerServerEvent('ujjob:save', d.job, { op = 'undecor', id = tostring(d.cid) })
    elseif a == 'blipadd' then
        local x, y, z = myPos()
        TriggerServerEvent('ujjob:save', d.job, { op = 'blipadd', id = newId(), x = x, y = y, z = z,
            sprite = tonumber(d.sprite) or 60, color = tonumber(d.color) or 3, scale = tonumber(d.scale) or BLIP_SCALE, label = tostring(d.label or '') })
    elseif a == 'bliphide' then
        local v = resolve(d.id)
        if v and isPoint(v) then TriggerServerEvent('ujjob:save', d.job, { op = 'bliphide', x = v.x + 0.0, y = v.y + 0.0, z = v.z + 0.0 }) end
    elseif a == 'blipdel' then
        TriggerServerEvent('ujjob:save', d.job, { op = 'blipdel', id = tostring(d.cid) })
    elseif a == 'blipmove' then
        local b = CBlips[tostring(d.cid)]
        if b then
            local x, y, z = myPos()
            TriggerServerEvent('ujjob:save', d.job, { op = 'blipdel', id = b.id })
            TriggerServerEvent('ujjob:save', d.job, { op = 'blipadd', id = newId(), x = x, y = y, z = z, sprite = b.sprite, color = b.color, scale = b.scale, label = b.label })
        end
    elseif a == 'del' then
        if not validPath(d.job, d.id) then return end
        TriggerServerEvent('ujjob:save', d.job, { op = 'del', path = d.id })
    elseif a == 'options_load' or a == 'options_set' then
        if a == 'options_set' then
            TriggerServerEvent('org_options:set', d.job, tonumber(d.grade), tostring(d.opt), d.enabled and true or false)
        end
        SetTimeout(a == 'options_set' and 600 or 0, function()
            ESX.TriggerServerCallback('OrgOptions:List', function(ranks)
                SendNUIMessage({ type = 'jm_options', job = d.job, ranks = ranks or {} })
            end, d.job)
        end)
    elseif a == 'level_set' or a == 'level_decide' then
        if d.job ~= 'jail' and d.job ~= 'government' then
            if a == 'level_set' then TriggerServerEvent('ujrec:setLevel', d.job, tonumber(d.level) or 0)
            else TriggerServerEvent('ujrec:levelDecide', d.job, d.approve == true) end
            SetTimeout(600, function()
                ESX.TriggerServerCallback('ujrec:levelAll', function(m) LevelInfo = m or {} refreshUI() end)
            end)
        end
    elseif a == 'orgswitch' then
        if d.job ~= 'jail' and d.job ~= 'government' then
            TriggerServerEvent('org_state:toggle', d.job, d.enabled == true)
        end
    elseif a == 'undo' then
        TriggerServerEvent('ujjob:undo', d.job)
    elseif a == 'reset' then
        TriggerServerEvent('ujjob:reset', d.job)
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


-- ============================================================ runtime: blips + decor
-- (1) custom blips, (2) hiding original blips, (3) every organisation blip at BLIP_SCALE
CreateThread(function()
    while ESX == nil do Wait(500) end
    Wait(4000)
    local orgCoords, nextRefresh, scanTick = {}, 0, 0
    while true do
        Wait(2500)
        local myjob = ESX.PlayerData and ESX.PlayerData.job and ESX.PlayerData.job.name
        for id, b in pairs(CBlips) do
            local show = (myjob == b.job or myjob == 'government') and not (OrgState and OrgState[b.job] == false)
            local h = BlipHandles[id]
            if show and not (h and DoesBlipExist(h)) then
                h = AddBlipForCoord(b.x + 0.0, b.y + 0.0, b.z + 0.0)
                SetBlipSprite(h, tonumber(b.sprite) or 60)
                SetBlipColour(h, tonumber(b.color) or 3)
                SetBlipScale(h, tonumber(b.scale) or BLIP_SCALE)
                SetBlipDisplay(h, 4)
                SetBlipAsShortRange(h, true)
                BeginTextCommandSetBlipName('STRING')
                AddTextComponentSubstringPlayerName(blipName(b))
                EndTextCommandSetBlipName(h)
                BlipHandles[id] = h
            elseif not show and h then
                removeCustomBlip(id)
            end
        end

        if GetGameTimer() > nextRefresh then
            orgCoords = {}
            for _, r in ipairs(REG) do
                local cfg = _G[r.cfg]
                if type(cfg) == 'table' then
                    local pts = {}
                    collect(r.cfg, cfg, r.cfg, nil, nil, pts, 0)
                    for _, p in ipairs(pts) do if p.cat == 'Blip' then orgCoords[#orgCoords + 1] = { x = p.x, y = p.y } end end
                end
            end
            nextRefresh = GetGameTimer() + 20000
        end

        scanTick = scanTick + 1
        if (#orgCoords > 0 or #Hidden > 0) and scanTick % 2 == 0 then
            local mine = {}
            for _, h in pairs(BlipHandles) do mine[h] = true end
            -- real blips only: GetFirstBlipInfoId / GetNextBlipInfoId hand out valid handles
            -- (calling DoesBlipExist on made-up numbers crashes the game: native a6db27d19ecbb7da)
            local found = {}
            for sprite = 1, 900 do
                local b = GetFirstBlipInfoId(sprite)
                local guard = 0
                while b and b ~= 0 and guard < 100 and DoesBlipExist(b) do
                    if not mine[b] then found[#found + 1] = b end
                    b = GetNextBlipInfoId(sprite)
                    guard = guard + 1
                end
            end
            for _, b in ipairs(found) do
                if DoesBlipExist(b) then
                    local c = GetBlipCoords(b)
                    local removed = false
                    for _, h in ipairs(Hidden) do
                        if math.abs(c.x - h.x) < 1.0 and math.abs(c.y - h.y) < 1.0 then RemoveBlip(b) removed = true break end
                    end
                    if not removed then
                        for _, o in ipairs(orgCoords) do
                            if math.abs(c.x - o.x) < 1.0 and math.abs(c.y - o.y) < 1.0 then SetBlipScale(b, BLIP_SCALE) break end
                        end
                    end
                end
            end
        end
    end
end)

-- ox_target on a placed ped / object: it opens the SAME menu the organisation's own marker opens
local function firstPoint(t)
    if isPoint(t) then return t end
    if type(t) ~= 'table' then return nil end
    for _, v in pairs(t) do
        if type(v) == 'table' or type(v) == 'vector3' then
            local r = firstPoint(v)
            if r then return r end
        end
    end
    return nil
end

local TARGET = {
    Boss   = { label = 'Boss menu',  icon = 'fa-solid fa-briefcase' },
    Locker = { label = 'Cloakroom',  icon = 'fa-solid fa-shirt' },
    Armory = { label = 'Armory',     icon = 'fa-solid fa-gun' },
    Veh    = { label = 'Garage',     icon = 'fa-solid fa-car' },
}

local function decorTarget(ent, d)
    local t = TARGET[d.cat]
    if not t then return end
    local job = d.job
    pcall(function()
        exports.ox_target:addLocalEntity(ent, { {
            name = 'ujjob_' .. tostring(d.id), label = t.label, icon = t.icon, distance = 2.2,
            canInteract = function()
                local mj = ESX.PlayerData and ESX.PlayerData.job and ESX.PlayerData.job.name
                return (mj == job or mj == 'government') and not (OrgState and OrgState[job] == false)
            end,
            onSelect = function()
                local mj = ESX.PlayerData and ESX.PlayerData.job and ESX.PlayerData.job.name
                if mj == 'government' then   -- Government acts inside this organisation
                    GovActiveOrg = job
                    TriggerServerEvent('gov_admin:setActiveOrg', job)
                end
                local station, partNum
                if d.sec then
                    station = split(d.sec)[3]
                    partNum = 1
                    local list = resolve(d.sec)
                    if type(list) == 'table' then
                        local best = 1e9
                        for i, entry in ipairs(list) do
                            local pt = firstPoint(entry)
                            if pt then
                                local dist = math.abs(pt.x - d.x) + math.abs(pt.y - d.y)
                                if dist < best then best = dist partNum = i end
                            end
                        end
                    end
                end
                if d.cat == 'Boss' then
                    TriggerEvent('esx_society:openBosscarysMenu', job, function(_, menu) menu.close() end, { wash = false })
                elseif d.cat == 'Locker' then
                    local f = _G['OpenCloakroomMenu_' .. job]; if f then f() end
                elseif d.cat == 'Armory' then
                    local f = _G['OpenArmoryMenu_' .. job]; if f then f(station) end
                elseif d.cat == 'Veh' then
                    local f = _G['OpenVehicleSpawnerMenu_' .. job]; if f then f(station, partNum) end
                end
            end,
        } })
    end)
end

-- (4) decor: peds, objects (streamed in/out by distance) and markers
local NearMarkers = {}
CreateThread(function()
    while ESX == nil do Wait(500) end
    while true do
        Wait(500)
        local pc = GetEntityCoords(PlayerPedId())
        local myjob = ESX.PlayerData and ESX.PlayerData.job and ESX.PlayerData.job.name
        local near = {}
        for id, d in pairs(Decor) do
            local dist = #(pc - vector3(d.x + 0.0, d.y + 0.0, d.z + 0.0))
            if d.kind == 'marker' then
                if (myjob == d.job or myjob == 'government') and not (OrgState and OrgState[d.job] == false) and dist < 35.0 then near[#near + 1] = d end
            else
                local e = DecorEnts[id]
                if dist < 90.0 and not (e and DoesEntityExist(e)) and type(d.model) == 'string' then
                    local hash = GetHashKey(d.model)
                    if IsModelInCdimage(hash) then
                        RequestModel(hash)
                        local t = 0
                        while not HasModelLoaded(hash) and t < 40 do Wait(50) t = t + 1 end
                        if HasModelLoaded(hash) then
                            local ent
                            if d.kind == 'ped' then
                                ent = CreatePed(4, hash, d.x + 0.0, d.y + 0.0, d.z - 1.0, (d.h or 0.0) + 0.0, false, false)
                                SetEntityInvincible(ent, true)
                                SetBlockingOfNonTemporaryEvents(ent, true)
                                SetPedCanRagdoll(ent, false)
                            else
                                ent = CreateObject(hash, d.x + 0.0, d.y + 0.0, d.z + 0.0, false, false, false)
                                SetEntityHeading(ent, (d.h or 0.0) + 0.0)
                                PlaceObjectOnGroundProperly(ent)
                            end
                            SetEntityAsMissionEntity(ent, true, true)   -- ambient-ped cleanup scripts leave it alone
                            SetEntityInvincible(ent, true)
                            SetEntityCanBeDamaged(ent, false)
                            FreezeEntityPosition(ent, true)
                            decorTarget(ent, d)
                            DecorEnts[id] = ent
                            SetModelAsNoLongerNeeded(hash)
                        end
                    end
                elseif dist > 140.0 and e then
                    removeDecorEntity(id)
                end
            end
        end
        NearMarkers = near
    end
end)

CreateThread(function()
    while true do
        if #NearMarkers > 0 then
            Wait(0)
            for _, d in ipairs(NearMarkers) do
                DrawMarker(tonumber(d.model) or 1, d.x + 0.0, d.y + 0.0, d.z - 0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    (d.sx or 1.5) + 0.0, (d.sy or 1.5) + 0.0, (d.sz or 0.8) + 0.0, d.r or 212, d.g or 175, d.b or 55, 130,
                    false, false, 2, false, nil, nil, false)
            end
        else
            Wait(300)
        end
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    for id in pairs(BlipHandles) do removeCustomBlip(id) end
    for id in pairs(DecorEnts) do removeDecorEntity(id) end
end)

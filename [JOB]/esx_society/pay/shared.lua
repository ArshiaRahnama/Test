Pay = {}

function Pay.group(n)
    local s, k = tostring(math.floor(tonumber(n) or 0)), nil
    repeat
        s, k = s:gsub('^(-?%d+)(%d%d%d)', '%1,%2')
    until k == 0
    return s
end

function Pay.getDept(id)
    for _, d in ipairs(Config.Pay.Departments) do
        if d.id == id then return d end
    end
end

function Pay.getOrg(dept, job)
    for _, o in ipairs(dept.orgs) do
        if o.job == job then return o end
    end
end

-- az roye esm-e job (mesle 'fbi') department + ordan ro peyda mikone
function Pay.findOrg(job)
    if type(job) ~= 'string' then return nil end
    for _, d in ipairs(Config.Pay.Departments) do
        for _, o in ipairs(d.orgs) do
            if o.job == job then return d, o end
        end
    end
end

function Pay.isBossGrade(gradeName)
    for _, g in ipairs(Config.Pay.BossGrades) do
        if g == gradeName then return true end
    end
    return false
end

function Pay.getPurpose(key)
    for _, p in ipairs(Config.Pay.Purposes) do
        if p.key == key then return p end
    end
end

-- noe-ye pardakht baraye yek department (ba limits-e department roye default)
function Pay.getType(dept, key)
    local allowed = false
    for _, k in ipairs(dept.types) do
        if k == key then allowed = true break end
    end
    local base = allowed and Config.Pay.Types[key]
    if not base then return nil end

    local t = { key = key, label = base.label, min = base.min, max = base.max, quick = base.quick }
    local o = dept.limits and dept.limits[key]
    if o then
        t.min = o.min or t.min
        t.max = o.max or t.max
    end
    return t
end

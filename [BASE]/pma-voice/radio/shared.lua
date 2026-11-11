UniqueRadio = {}

-- "12", 12, 12.0 -> 12 ; anything else (nil, 1.5, "abc", out of range) -> nil
function UniqueRadio.ParseFrequency(value)
    local n = tonumber(value)
    if not n or n ~= math.floor(n) then return nil end
    if n < Config.MinFrequency or n > Config.MaxFrequency then return nil end
    return math.floor(n)
end

-- Access table shape: { [frequency:number] = { [jobOrGangName] = true } }
function UniqueRadio.BuildDefaultAccess()
    local access = {}
    local reserved = Config.ReservedFrequencies
    if reserved then
        for f = reserved.from, reserved.to do access[f] = {} end
    end
    for job, list in pairs(Config.JobFrequencies) do
        for _, f in ipairs(list) do
            access[f] = access[f] or {}
            access[f][job] = true
        end
    end
    return access
end

-- Accepts tables coming from JSON / events (string keys) and returns a clean access table.
function UniqueRadio.NormalizeAccess(raw)
    local out = {}
    if type(raw) ~= 'table' then return out end
    for key, rule in pairs(raw) do
        local f = UniqueRadio.ParseFrequency(key)
        if f then
            local set = {}
            if type(rule) == 'table' then
                for name, allowed in pairs(rule) do
                    if type(name) == 'string' and allowed == true and name:match('^[%w_%-]+$') and #name <= 32 then
                        set[name] = true
                    end
                end
            end
            out[f] = set
        end
    end
    return out
end

function UniqueRadio.IsNoGang(name)
    return name == nil or Config.NoGangNames[name] == true
end

-- basic job / nojob with no gang cannot use the radio at all
function UniqueRadio.IsRestricted(job, gangName)
    if not Config.RestrictBasicJobs then return false end
    if job == nil then return true end
    return Config.BasicJobs[job] == true and UniqueRadio.IsNoGang(gangName)
end

function UniqueRadio.CanAccess(access, freq, job, gangName, gangGrade)
    local rule = access[freq]
    if not rule then return true end
    if job and Config.AllAccessJobs[job] then return true end
    if job and rule[job] then return true end
    if gangName and not UniqueRadio.IsNoGang(gangName) and rule[gangName] and (tonumber(gangGrade) or 0) > Config.GangMinGrade then
        return true
    end
    return false
end

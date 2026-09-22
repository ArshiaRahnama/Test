UE = UE or {}
UE.Resource = GetCurrentResourceName()
UE.IsServer = IsDuplicityVersion()

UE.EventList = { 'capture', 'gungame', 'warzone' }
UE.Label = { capture = 'Capture', gungame = 'GunGame', warzone = 'WarZone' }
UE.ConfigKey = { capture = 'Capture', gungame = 'GunGame', warzone = 'WarZone' }

function UE.IsEnabled(name)
    return Config.Enable[UE.ConfigKey[name]] == true
end

--- plain {x,y,z} from a vector3 / table (safe for JSON, NUI and msgpack)
function UE.Vec(v)
    if not v then return nil end
    return { x = (v.x or v[1] or 0.0) + 0.0, y = (v.y or v[2] or 0.0) + 0.0, z = (v.z or v[3] or 0.0) + 0.0 }
end

function UE.ToVec3(t)
    if not t then return nil end
    return vector3((t.x or t[1] or 0.0) + 0.0, (t.y or t[2] or 0.0) + 0.0, (t.z or t[3] or 0.0) + 0.0)
end

function UE.Dist(a, b)
    local dx, dy, dz = (a.x - b.x), (a.y - b.y), ((a.z or 0.0) - (b.z or 0.0))
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

function UE.Dist2D(a, b)
    local dx, dy = (a.x - b.x), (a.y - b.y)
    return math.sqrt(dx * dx + dy * dy)
end

function UE.Clamp(v, lo, hi)
    if v < lo then return lo end
    if v > hi then return hi end
    return v
end

function UE.Count(t)
    local n = 0
    for _ in pairs(t or {}) do n = n + 1 end
    return n
end

function UE.Contains(list, value)
    for _, v in ipairs(list or {}) do
        if v == value then return true end
    end
    return false
end

function UE.Remove(list, value)
    for i, v in ipairs(list or {}) do
        if v == value then table.remove(list, i) return true end
    end
    return false
end

function UE.Keys(t)
    local out = {}
    for k in pairs(t or {}) do out[#out + 1] = k end
    table.sort(out, function(a, b) return tostring(a) < tostring(b) end)
    return out
end

--- 125 -> "02:05"
function UE.FormatTime(totalSeconds)
    totalSeconds = math.max(0, math.floor(tonumber(totalSeconds) or 0))
    return string.format('%02d:%02d', totalSeconds // 60, totalSeconds % 60)
end

function UE.FirstName(v)
    if type(v) == 'table' then return v[1] end
    return v
end

--- list of command names (string or table) -> table
function UE.Names(v)
    if type(v) == 'table' then return v end
    return { v }
end

function UE.ToNumber(v, default)
    local n = tonumber(v)
    if n == nil then return default end
    return n
end

function UE.Lower(s)
    return string.lower(tostring(s or ''))
end

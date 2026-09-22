-- Unique_AdminPanel | server/rules_common.lua
-- Small helpers shared by server/nlr.lua and server/vdm.lua.

RulesSkipNLR = {}   -- identifier -> os.time() until which a death must NOT start a New Life (VDM victims)

local rateLimit = {}
function RulesLimited(src, key, seconds)
    local k = key .. ':' .. src
    local now = GetGameTimer() / 1000 -- wall-clock seconds since server start (os.clock() is CPU time)
    if rateLimit[k] and now - rateLimit[k] < seconds then return true end
    rateLimit[k] = now
    return false
end
AddEventHandler('playerDropped', function()
    local suffix = ':' .. source
    for k in pairs(rateLimit) do
        if k:sub(-#suffix) == suffix then rateLimit[k] = nil end
    end
end)

function RulesIdentifier(src)
    local x = ESX and ESX.GetPlayerFromId(src)
    return x and x.identifier, x
end

function RulesCoords(src)
    local ped = GetPlayerPed(src)
    if ped and ped ~= 0 then
        local c = GetEntityCoords(ped)
        return { x = c.x, y = c.y, z = c.z }
    end
end

function RulesDist(a, b)
    return math.sqrt((a.x - b.x) ^ 2 + (a.y - b.y) ^ 2 + (a.z - b.z) ^ 2)
end

function RulesIsStaff(src, level)
    if src == 0 then return true end
    local x = ESX.GetPlayerFromId(src)
    return x and (x.permission_level or 0) >= (level or 1) and x.get and x.get('aduty') and true or false
end

-- chat line + optional callback per on-duty admin
function RulesEachAdmin(fn)
    for _, id in ipairs(ESX.GetPlayers()) do
        if RulesIsStaff(id, 1) then fn(id) end
    end
end

-- audit trail: shows up in the player's Case File (no admin involved -> "SYSTEM")
function RulesLog(action, details, targetIdentifier, targetName)
    if not targetIdentifier then return end
    MySQL.Async.execute(
        "INSERT INTO `admin_action_log` (`admin_identifier`, `admin_name`, `target_identifier`, `target_name`, `action`, `details`, `created_at`) VALUES (NULL, 'SYSTEM', @ti, @tn, @a, @d, @c)",
        { ['@ti'] = targetIdentifier, ['@tn'] = targetName, ['@a'] = action, ['@d'] = tostring(details or ''):sub(1, 480), ['@c'] = os.date('%Y-%m-%d %H:%M:%S') }
    )
end

-- automatic flag (never overwrites a flag an admin set by hand)
function RulesFlag(identifier, note)
    pcall(function()
        MySQL.Async.execute(
            "INSERT INTO `admin_player_flags` (`identifier`, `note`, `admin_name`, `created_at`) VALUES (@i, @n, 'SYSTEM', NOW()) " ..
            "ON DUPLICATE KEY UPDATE `note` = IF(`admin_name` = 'SYSTEM', @n, `note`), `created_at` = IF(`admin_name` = 'SYSTEM', NOW(), `created_at`)",
            { ['@i'] = identifier, ['@n'] = note })
    end)
end

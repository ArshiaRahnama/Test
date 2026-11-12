-- Mastery skins: a weapon with its skill at 100% may carry a tint. Choice is stored per
-- (player, weapon); with no choice the configured default tint is used. The server only
-- decides WHICH tint; the client applies it (SetPedWeaponTintIndex).
local Cfg = Config.WeaponSkins
if not Cfg or not Cfg.enabled then return end

local Cache, Loading = {}, {} -- Cache[identifier] = { [WEAPON_X] = tint }

local function isMk2(name) return name:find('_MK2$') ~= nil end
local function maxTint(name) local l = isMk2(name) and Cfg.mk2 or Cfg.standard; return #l end -- l[0] is outside #

local function load(identifier, cb)
    if Cache[identifier] then return cb(Cache[identifier]) end
    if Loading[identifier] then table.insert(Loading[identifier], cb) return end
    Loading[identifier] = { cb }
    MySQL.Async.fetchAll('SELECT weapon, tint FROM weapon_skins WHERE identifier = @i', { ['@i'] = identifier }, function(rows)
        local t = {}
        for _, r in ipairs(rows or {}) do t[r.weapon] = tonumber(r.tint) or 0 end
        Cache[identifier] = t
        local waiting = Loading[identifier]; Loading[identifier] = nil
        for _, f in ipairs(waiting or {}) do f(t) end
    end)
end

-- effective tint for one weapon (nil = leave the weapon alone)
function GetWeaponSkinTint(identifier, weaponName, finished)
    if not finished then return nil end
    local t = Cache[identifier]
    if t and t[weaponName] ~= nil then return t[weaponName] end
    return isMk2(weaponName) and Cfg.defaultTintMk2 or Cfg.defaultTint
end

-- the full {WEAPON_X = tint} map the client should enforce
local function pushMap(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    load(xPlayer.identifier, function()
        local map = {}
        for key, def in pairs(Config.Skills) do
            if def.weapon and def.weaponName then
                local finished = exports[GetCurrentResourceName()]:IsWeaponSkillFinished(src, def.weaponName)
                local tint = GetWeaponSkinTint(xPlayer.identifier, def.weaponName, finished)
                if tint ~= nil then map[def.weaponName] = tint end
            end
        end
        TriggerClientEvent('Unique_LevelQuest:weaponSkins', src, map)
    end)
end

AddEventHandler('esx:playerLoaded', function(src)
    SetTimeout(7000, function() pushMap(src) end) -- skills load first (see skills.lua)
end)
AddEventHandler('Unique_LevelQuest:skillFinished', function(src) pushMap(src) end)
CreateThread(function() -- after a resource restart
    Wait(5000)
    for _, p in ipairs(GetPlayers()) do pushMap(tonumber(p)) end
end)

AddEventHandler('playerDropped', function()
    local x = ESX.GetPlayerFromId(source)
    if x then Cache[x.identifier] = nil end
end)

local lastSet = {}
ESX.RegisterServerCallback('HUD_Menu:SetWeaponSkin', function(source, cb, weapon, tint)
    local now = os.time()
    if lastSet[source] and now - lastSet[source] < 1 then return cb(false) end
    lastSet[source] = now

    local xPlayer = ESX.GetPlayerFromId(source)
    tint = math.tointeger(tonumber(tint) or -1)
    if not xPlayer or type(weapon) ~= 'string' or not weapon:match('^WEAPON_[A-Z0-9_]+$') or not tint then return cb(false) end

    -- must be one of the configured weapon skills AND mastered
    local known = false
    for _, def in pairs(Config.Skills) do if def.weapon and def.weaponName == weapon then known = true end end
    if not known or not exports[GetCurrentResourceName()]:IsWeaponSkillFinished(source, weapon) then return cb(false) end
    if tint < 0 or tint > maxTint(weapon) then return cb(false) end

    load(xPlayer.identifier, function(t)
        t[weapon] = tint
        MySQL.Async.execute([[INSERT INTO weapon_skins (identifier, weapon, tint) VALUES (@i, @w, @t)
            ON DUPLICATE KEY UPDATE tint = @t]], { ['@i'] = xPlayer.identifier, ['@w'] = weapon, ['@t'] = tint }, function()
            pushMap(source)
            cb(true)
        end)
    end)
end)

ESX.RegisterServerCallback('HUD_Menu:GetSkinOptions', function(_, cb)
    cb({ standard = Cfg.standard, mk2 = Cfg.mk2 })
end)

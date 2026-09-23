--[[
    Unique_Event - server core
    Shared services for every module: ESX bootstrap, DB helpers, notifications, Discord logging,
    permissions, command helper, rate limiting, the "one event at a time" registry and routing buckets.
]]

UE.Modules = {}       -- [eventName] = { Status, Stats, Leaderboard, ... } (registered by each module)
UE.Actions = {}       -- [eventName][action] = function(src, data)   (hub buttons)
UE.InEvent = {}       -- [src] = 'capture' | 'gungame' | 'warzone'

-- ============================================================
-- ESX bootstrap (with a retry loop so load order never matters)
-- ============================================================
ESX = nil
local pendingCallbacks = {}

local function fetchESX()
    TriggerEvent(Config.Framework.SharedObject, function(obj) ESX = obj end)
end
fetchESX()

--- Registers an ESX server callback (queued if ESX isn't ready yet)
function UE.Callback(name, fn)
    if ESX then
        ESX.RegisterServerCallback(name, fn)
    else
        pendingCallbacks[#pendingCallbacks + 1] = { name, fn }
    end
end

CreateThread(function()
    local tries = 0
    while not ESX and tries < 600 do
        fetchESX()
        Wait(100)
        tries = tries + 1
    end
    if not ESX then
        print('^1[Unique_Event] ESX was never found (' .. Config.Framework.SharedObject .. ') - the resource cannot work^7')
        return
    end
    for _, cb in ipairs(pendingCallbacks) do
        ESX.RegisterServerCallback(cb[1], cb[2])
    end
    pendingCallbacks = {}
end)

function UE.GetPlayer(src)
    if not ESX or not src or src == 0 then return nil end
    return ESX.GetPlayerFromId(src)
end

function UE.Name(src)
    return GetPlayerName(src) or ('#' .. tostring(src))
end

--- Server-side distance between two connected players' peds. Returns nil if either
--- ped can't be resolved (disconnected, not streamed on the server's entity list yet).
function UE.PlayerDistance(a, b)
    local pedA, pedB = GetPlayerPed(a), GetPlayerPed(b)
    if not pedA or pedA == 0 or not pedB or pedB == 0 then return nil end
    local cA, cB = GetEntityCoords(pedA), GetEntityCoords(pedB)
    return #(cA - cB)
end

--- Sanity-checks a client-reported killer id before trusting it for a kill credit.
--- The client resolves *who* killed it (GetPedSourceOfDeath is client-only, so the
--- server can't determine that on its own) - this only verifies the claim is plausible:
--- the claimed killer is a real connected player, isn't the victim, and isn't absurdly
--- far away (a spoofed/free kill from across the map). maxDist defaults to 120 units,
--- generous enough for any weapon in these game modes.
function UE.PlausibleKiller(victim, killerSrc, maxDist)
    if not killerSrc or killerSrc == 0 or killerSrc == victim then return false end
    if not UE.GetPlayer(killerSrc) then return false end
    local dist = UE.PlayerDistance(victim, killerSrc)
    if not dist then return false end
    return dist <= (maxDist or 120.0)
end

function UE.Gang(src)
    local x = UE.GetPlayer(src)
    return (x and x.gang and x.gang.name) or 'nogang'
end

function UE.Now()
    return os.date('%Y-%m-%d %H:%M:%S')
end

-- ============================================================
-- Database helpers (oxmysql, mysql-async style API)
-- ============================================================
UE.DB = {}

function UE.DB.Exec(query, params, cb)
    MySQL.Async.execute(query, params or {}, cb or function() end)
end

function UE.DB.All(query, params, cb)
    MySQL.Async.fetchAll(query, params or {}, function(rows) cb(rows or {}) end)
end

function UE.DB.One(query, params, cb)
    MySQL.Async.fetchAll(query, params or {}, function(rows) cb(rows and rows[1] or nil) end)
end

--- runs fn once oxmysql is up
function UE.DB.Ready(fn)
    CreateThread(function()
        while GetResourceState('oxmysql') ~= 'started' do Wait(200) end
        Wait(500)
        fn()
    end)
end

--- Runs many async tasks at once. tasks = { key = function(done) ... done(result) end }
--- cb(results) fires when all finished (or after 8s with whatever arrived).
function UE.Parallel(tasks, cb)
    local keys = UE.Keys(tasks)
    local results, left, finished = {}, #keys, false
    local function finish()
        if not finished then finished = true cb(results) end
    end
    if left == 0 then return finish() end
    SetTimeout(8000, finish)
    for _, key in ipairs(keys) do
        local called = false
        local function done(res)
            if called then return end
            called = true
            results[key] = res
            left = left - 1
            if left <= 0 then finish() end
        end
        local ok, err = pcall(tasks[key], done)
        if not ok then
            print('^1[Unique_Event] Parallel task "' .. tostring(key) .. '" failed: ' .. tostring(err) .. '^7')
            done(nil)
        end
    end
end

-- ============================================================
-- Messages
-- ============================================================
function UE.Notify(src, msg, kind, title)
    TriggerClientEvent('ue:notify', src, msg, kind or 'info', title)
end

function UE.Chat(src, tag, msg)
    TriggerClientEvent('chat:addMessage', src, { args = { tag or '^1Unique Event', tostring(msg) } })
end

function UE.Announce(src, text, secs, kind)
    TriggerClientEvent('ue:announce', src, text, secs or 5, kind or 'info')
end

function UE.NotifyMany(list, msg, kind, title)
    for _, src in ipairs(list) do UE.Notify(src, msg, kind, title) end
end

-- ============================================================
-- Discord logging
-- ============================================================
function UE.Log(category, embed)
    if not SvConfig.LogEnabled then return end
    local url = SvConfig.Webhooks[category]
    if not url or url == '' then url = SvConfig.Webhooks.Default end
    if not url or url == '' then return end

    embed.footer = embed.footer or { text = SvConfig.LogUsername .. ' | ' .. category }
    embed.timestamp = embed.timestamp or os.date('!%Y-%m-%dT%H:%M:%SZ')
    local payload = { username = SvConfig.LogUsername, embeds = { embed } }
    if SvConfig.LogAvatarUrl and SvConfig.LogAvatarUrl ~= '' then payload.avatar_url = SvConfig.LogAvatarUrl end

    PerformHttpRequest(url, function(err)
        if err and err ~= 200 and err ~= 204 then
            print('^1[Unique_Event]^7 Discord log failed for category "' .. category .. '" (HTTP ' .. tostring(err) .. ')')
        end
    end, 'POST', json.encode(payload), { ['Content-Type'] = 'application/json' })
end

-- ============================================================
-- Permissions / commands / rate limiting
-- ============================================================
local function permKey(name)
    return UE.ConfigKey[name] or (name:sub(1, 1):upper() .. name:sub(2))
end

function UE.Level(src)
    if src == 0 then return 9999 end
    local x = UE.GetPlayer(src)
    return x and tonumber(x.permission_level) or 0
end

--- true when the player has the admin level of that event ('capture', 'gungame', 'warzone')
function UE.CanAdmin(src, name)
    local need = Config.Perm[permKey(name)]
    if not need then return false end
    return UE.Level(src) >= need
end

--- registers a command under one or several names
function UE.Command(names, fn, restricted)
    for _, n in ipairs(UE.Names(names)) do
        RegisterCommand(n, fn, restricted or false)
    end
end

local rateBuckets = {}
--- true = the caller is going too fast (and should be ignored)
function UE.RateLimit(src, key, seconds)
    local k = tostring(src) .. ':' .. key
    local now = GetGameTimer()
    if rateBuckets[k] and (now - rateBuckets[k]) < (seconds * 1000) then return true end
    rateBuckets[k] = now
    return false
end

-- ============================================================
-- Routing buckets
-- ============================================================
local populationDisabled = {}

function UE.SetBucket(src, bucket)
    SetPlayerRoutingBucket(src, bucket)
    if bucket ~= 0 and not populationDisabled[bucket] and SetRoutingBucketPopulationEnabled then
        populationDisabled[bucket] = true
        SetRoutingBucketPopulationEnabled(bucket, false)   -- no ambient peds/traffic inside event worlds
    end
end

function UE.ResetBucket(src)
    SetPlayerRoutingBucket(src, 0)
end

-- ============================================================
-- One event at a time
-- ============================================================
--- Marks the player as being inside an event. Returns false + the name of the event they're in already.
function UE.Enter(src, name)
    local cur = UE.InEvent[src]
    if cur and cur ~= name then return false, UE.Label[cur] or cur end
    UE.InEvent[src] = name
    return true
end

function UE.Exit(src, name)
    if not name or UE.InEvent[src] == name then UE.InEvent[src] = nil end
end

function UE.PlayersIn(name)
    local out = {}
    for src, ev in pairs(UE.InEvent) do
        if ev == name then out[#out + 1] = src end
    end
    return out
end

--- Generic "may this player join?" check. Returns ok, reason
function UE.CanJoin(src, name)
    if not UE.IsEnabled(name) then return false, UE.Label[name] .. ' is disabled on this server.' end
    local xPlayer = UE.GetPlayer(src)
    if not xPlayer then return false, 'Your character is not loaded yet.' end
    local cur = UE.InEvent[src]
    if cur and cur ~= name then return false, 'You are already in ' .. (UE.Label[cur] or cur) .. '.' end
    if Config.RestrictedFor[name] and xPlayer.job and Config.RestrictedJobs[xPlayer.job.name] then
        return false, 'Go off duty before joining ' .. UE.Label[name] .. '.'
    end
    return true
end

-- ============================================================
-- Disconnects
-- ============================================================
local dropHandlers = {}
function UE.OnDrop(fn) dropHandlers[#dropHandlers + 1] = fn end

AddEventHandler('playerDropped', function()
    local src = source
    for _, fn in ipairs(dropHandlers) do
        local ok, err = pcall(fn, src)
        if not ok then print('^1[Unique_Event] drop handler error: ' .. tostring(err) .. '^7') end
    end
    UE.InEvent[src] = nil
    for k in pairs(rateBuckets) do
        if k:find('^' .. src .. ':') then rateBuckets[k] = nil end
    end
end)

-- ============================================================
-- Exports for other resources
-- ============================================================
exports('GetPlayerEvent', function(src) return UE.InEvent[src] end)
exports('IsPlayerInEvent', function(src) return UE.InEvent[src] ~= nil end)

--- registers an event module (used by the hub)
function UE.RegisterModule(name, mod)
    UE.Modules[name] = mod
    UE.Actions[name] = UE.Actions[name] or {}
end

print('^2[Unique_Event]^7 core loaded')

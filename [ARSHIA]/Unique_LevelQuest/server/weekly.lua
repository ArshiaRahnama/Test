-- Weekly quests. State lives in its own table (quest_weekly) because the
-- daily `quest` row is wiped every midnight. Cached in memory, written
-- behind (30s / leave / stop) like server/skills.lua.
local Cache, Dirty, Loading, IdentOf = {}, {}, {}, {}

local function weekKey() return os.date('%Y%W') end -- Monday-based week number

local function secondsToReset()
    local t = os.date('*t')
    local days = (9 - t.wday) % 7 -- wday: 1 = Sunday ... 2 = Monday
    if days == 0 then days = 7 end
    return os.time({ year = t.year, month = t.month, day = t.day + days, hour = 0, min = 0, sec = 0 }) - os.time()
end

local function load(identifier, cb)
    local cur = Cache[identifier]
    if cur and cur.week == weekKey() then return cb(cur) end
    if Loading[identifier] then table.insert(Loading[identifier], cb) return end
    Loading[identifier] = { cb }
    MySQL.Async.fetchAll('SELECT week, progress FROM quest_weekly WHERE identifier = @i', { ['@i'] = identifier }, function(rows)
        local wk = weekKey()
        local entry = { week = wk, prog = {} }
        if rows and rows[1] and rows[1].week == wk then
            local ok, d = pcall(json.decode, rows[1].progress)
            if ok and type(d) == 'table' then entry.prog = d end
        else
            Dirty[identifier] = true -- stale/missing row: overwrite with the fresh week
        end
        Cache[identifier] = entry
        local waiting = Loading[identifier]; Loading[identifier] = nil
        for _, f in ipairs(waiting or {}) do f(entry) end
    end)
end

local function flush(identifier)
    local e = Cache[identifier]
    if not e or not Dirty[identifier] then return end
    Dirty[identifier] = nil
    MySQL.Async.execute([[INSERT INTO quest_weekly (identifier, week, progress) VALUES (@i, @w, @p)
        ON DUPLICATE KEY UPDATE week = @w, progress = @p]],
        { ['@i'] = identifier, ['@w'] = e.week, ['@p'] = json.encode(e.prog) })
end

CreateThread(function()
    while true do
        Wait(30000)
        for id in pairs(Dirty) do flush(id) end
    end
end)

AddEventHandler('playerDropped', function()
    local id = IdentOf[source]
    IdentOf[source] = nil
    if id then flush(id); Cache[id] = nil end
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    for id in pairs(Dirty) do flush(id) end
end)

local byTrigger = {}
for i, q in ipairs(Config.WeeklyQuests or {}) do
    byTrigger[q.trigger] = byTrigger[q.trigger] or {}
    table.insert(byTrigger[q.trigger], i)
end

local lastAt = {}
for trigger, ids in pairs(byTrigger) do
    AddEventHandler(trigger, function(explicitSource)
        local src = tonumber(explicitSource) or source
        local xPlayer = src and ESX.GetPlayerFromId(src)
        if not xPlayer then return end
        local key = src .. ':' .. trigger
        local now = os.time()
        if lastAt[key] and now - lastAt[key] < 2 then return end -- same flood guard as the daily quests
        lastAt[key] = now

        IdentOf[src] = xPlayer.identifier
        load(xPlayer.identifier, function(e)
            for _, i in ipairs(ids) do
                local q = Config.WeeklyQuests[i]
                local k = tostring(i)
                local cur = tonumber(e.prog[k]) or 0
                if cur < q.requiredTrigger then
                    cur = cur + 1
                    e.prog[k] = cur
                    Dirty[xPlayer.identifier] = true
                    if cur >= q.requiredTrigger then
                        TriggerClientEvent('hud:achievementToast', src, q.name, ('Weekly • +%s XP • +%s Coin'):format(q.XP, q.coin))
                        GrantXP(src, q.XP, nil)
                        if q.coin and q.coin > 0 then GrantCoin(src, q.coin) end
                        TriggerEvent('Unique_LevelQuest:questCompleted', src)
                        flush(xPlayer.identifier)
                    end
                end
            end
        end)
    end)
end

ESX.RegisterServerCallback('HUD_Menu:GetWeekly', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return cb({}, 0) end
    IdentOf[source] = xPlayer.identifier
    load(xPlayer.identifier, function(e)
        local out = {}
        for i, q in ipairs(Config.WeeklyQuests or {}) do
            local cur = math.min(tonumber(e.prog[tostring(i)]) or 0, q.requiredTrigger)
            out[#out + 1] = { name = q.name, description = q.description, progress = cur, required = q.requiredTrigger,
                              XP = q.XP, coin = q.coin, done = cur >= q.requiredTrigger }
        end
        cb(out, secondsToReset())
    end)
end)

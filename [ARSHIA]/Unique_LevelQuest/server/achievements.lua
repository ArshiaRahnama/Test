-- Achievements + public profile (sun-style "menu I" extras).
local function award(src, identifier, key)
    local def = Config.Achievements[key]
    if not def then return end
    MySQL.Async.execute([[INSERT INTO player_achievements (identifier, achievement, progress, completed) VALUES (@i, @a, 1, 1)
        ON DUPLICATE KEY UPDATE progress = IF(completed = 1, progress, 1), completed = 1]],
        { ['@i'] = identifier, ['@a'] = key })
    if def.hidden then return end
    TriggerClientEvent('hud:achievementToast', src, def.label, ('Achievement • +%d pts'):format(def.point or 0))
end

local function isDone(identifier, key, cb)
    MySQL.Async.fetchScalar('SELECT completed FROM player_achievements WHERE identifier = @i AND achievement = @a',
        { ['@i'] = identifier, ['@a'] = key }, function(v) cb(tonumber(v) == 1) end)
end

local function tryAward(src, identifier, key)
    isDone(identifier, key, function(done) if not done then award(src, identifier, key) end end)
end

AddEventHandler('Unique_LevelQuest:levelChanged', function(src, rank)
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    for key, def in pairs(Config.Achievements) do
        if def.kind == 'level' and rank >= def.value then tryAward(src, xPlayer.identifier, key) end
    end
end)

AddEventHandler('Unique_LevelQuest:questCompleted', function(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    local identifier = xPlayer.identifier
    -- one running counter, stored on the lowest 'quests' achievement row key
    MySQL.Async.execute([[INSERT INTO player_achievements (identifier, achievement, progress, completed) VALUES (@i, '_quest_count', 1, 0)
        ON DUPLICATE KEY UPDATE progress = progress + 1]], { ['@i'] = identifier }, function()
        MySQL.Async.fetchScalar("SELECT progress FROM player_achievements WHERE identifier = @i AND achievement = '_quest_count'",
            { ['@i'] = identifier }, function(count)
            count = tonumber(count) or 0
            for key, def in pairs(Config.Achievements) do
                if def.kind == 'quests' and count >= def.value then tryAward(src, identifier, key) end
            end
        end)
    end)
end)

AddEventHandler('Unique_LevelQuest:skillFinished', function(src, skill)
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    local identifier = xPlayer.identifier
    for key, def in pairs(Config.Achievements) do
        if def.kind == 'skill' and def.key == skill then tryAward(src, identifier, key) end
    end
    -- "first on the server": INSERT IGNORE on a PRIMARY KEY is atomic, so exactly one player wins
    MySQL.Async.execute('INSERT IGNORE INTO achievement_firsts (skill, identifier) VALUES (@s, @i)',
        { ['@s'] = skill, ['@i'] = identifier }, function(affected)
        if (tonumber(affected) or 0) > 0 then
            for key, def in pairs(Config.Achievements) do
                if def.kind == 'skillFirst' and def.key == skill then award(src, identifier, key) end
            end
        end
    end)
end)

local function listFor(identifier, cb)
    MySQL.Async.fetchAll('SELECT achievement, progress, completed FROM player_achievements WHERE identifier = @i',
        { ['@i'] = identifier }, function(rows)
        local done, prog = {}, {}
        for _, r in ipairs(rows or {}) do
            done[r.achievement] = tonumber(r.completed) == 1
            prog[r.achievement] = tonumber(r.progress) or 0
        end
        local count = prog['_quest_count'] or 0
        local out, points = {}, 0
        for key, def in pairs(Config.Achievements) do
            local completed = done[key] or false
            if completed then points = points + (def.point or 0) end
            if completed or not def.hidden then
                local p, max = completed and 1 or 0, 1
                if def.kind == 'quests' then p, max = math.min(count, def.value), def.value end
                if completed then p = max end
                out[#out + 1] = { key = key, label = def.label, description = def.description, point = def.point or 0,
                                  completed = completed, progress = p, max = max, hidden = def.hidden or false }
            end
        end
        table.sort(out, function(a, b)
            if a.completed ~= b.completed then return a.completed end
            return a.label < b.label
        end)
        cb(out, points)
    end)
end

ESX.RegisterServerCallback('HUD_Menu:GetAchievements', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return cb({}, 0) end
    listFor(xPlayer.identifier, cb)
end)

-- Public profile of another online player (/profile <id>).
local profileCooldown = {}
ESX.RegisterServerCallback('HUD_Menu:GetProfile', function(source, cb, targetId)
    local now = os.time()
    if profileCooldown[source] and now - profileCooldown[source] < 2 then return cb(nil) end
    profileCooldown[source] = now

    targetId = tonumber(targetId)
    local target = targetId and ESX.GetPlayerFromId(targetId)
    if not target then return cb(nil) end

    GetXPRankCached(targetId, function(xp, rank)
        listFor(target.identifier, function(list, points)
            GetActivitySkillList(targetId, function(skills)
                local top = {}
                for _, s in ipairs(skills) do if s.percent > 0 then top[#top + 1] = s end end
                local doneCount = 0
                for _, a in ipairs(list) do if a.completed then doneCount = doneCount + 1 end end
                cb({
                    name = (target.name or 'Unknown'):gsub('_', ' '),
                    id = targetId,
                    level = rank or 1, xp = xp or 0, xpNeeded = Config.Levels[rank or 1] or 0,
                    job = target.job and target.job.label or 'No Job',
                    points = points, achievements = doneCount, skills = top,
                })
            end)
        end)
    end)
end)

AddEventHandler('playerDropped', function() profileCooldown[source] = nil end)

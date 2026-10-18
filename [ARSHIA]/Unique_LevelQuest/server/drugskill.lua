-- ================================================================= --
-- DRUG SKILLS (used by esx_drugs, now merged into Unique_ALLGangs/drugs)
-- Per-player, per-skill value 0..100 (e.g. "Heroine": 100 halves the
-- processing time). Lives here so every skill on the server is in ONE place.
-- Exports (safe to call from any resource):
--   exports['Unique_LevelQuest']:GetDrugSkills(source)        -> { [skill] = value }
--   exports['Unique_LevelQuest']:AddDrugSkill(source, skill, amount) -> true when accepted
-- ================================================================= --

local DRUG_SKILL_MAX = 100
local DrugSkillCache = {}   -- [identifier] = { [skill] = value }

-- table is created by the migrations at resource start (see server/migrations.lua)
MySQL.ready(function()
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `drug_skill` (
          `identifier` varchar(60) NOT NULL,
          `skill`      varchar(40) NOT NULL,
          `value`      int(11) NOT NULL DEFAULT 0,
          PRIMARY KEY (`identifier`, `skill`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])
end)

local function loadSkills(identifier, cb)
    if DrugSkillCache[identifier] then return cb(DrugSkillCache[identifier]) end
    MySQL.Async.fetchAll('SELECT skill, value FROM drug_skill WHERE identifier = @i', { ['@i'] = identifier }, function(rows)
        local t = {}
        for _, r in ipairs(rows or {}) do t[r.skill] = tonumber(r.value) or 0 end
        DrugSkillCache[identifier] = t
        cb(t)
    end)
end

local function playerIdentifier(source)
    local xPlayer = ESX and ESX.GetPlayerFromId(source)
    return xPlayer and xPlayer.identifier or nil
end

exports('GetDrugSkills', function(source, cb)
    local id = playerIdentifier(source)
    if not id then return {} end
    -- synchronous read from the cache when it is already loaded
    if DrugSkillCache[id] then return DrugSkillCache[id] end
    loadSkills(id, function() end)
    return {}
end)

-- returns true when the XP was accepted. The new value is pushed to the player's client
-- with Drug-Skill:Sync once it is saved (the DB call is async, so it is not returned here).
exports('AddDrugSkill', function(source, skill, amount)
    local id = playerIdentifier(source)
    amount = math.floor(tonumber(amount) or 0)
    if not id or type(skill) ~= 'string' or skill == '' or amount == 0 then return false end
    loadSkills(id, function(t)
        local v = math.min(DRUG_SKILL_MAX, math.max(0, (t[skill] or 0) + amount))
        t[skill] = v
        MySQL.Async.execute('INSERT INTO drug_skill (identifier, skill, value) VALUES (@i, @s, @v) ON DUPLICATE KEY UPDATE value = @v',
            { ['@i'] = id, ['@s'] = skill, ['@v'] = v })
        TriggerClientEvent('Drug-Skill:Sync', source, skill, v)
    end)
    return true
end)

-- the drug skill cache is cleared when a player leaves
AddEventHandler('playerDropped', function()
    local id = playerIdentifier(source)
    if id then DrugSkillCache[id] = nil end
end)

-- client asks for its own skills on join
ESX.RegisterServerCallback('Drug-Skill:GetAll', function(source, cb)
    local id = playerIdentifier(source)
    if not id then return cb({}) end
    loadSkills(id, function(t) cb(t) end)
end)

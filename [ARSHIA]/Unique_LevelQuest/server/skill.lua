-- ================================================================= --
-- Skill tracking (drives the Skill tab)
-- ================================================================= --
-- Same anti-spam pattern already used for quest triggers: a raw
-- RegisterServerEvent with no rate limit would let a client fire it in
-- a tight loop and max out a skill in seconds. Cooldown here matches
-- the real cadence (essentialmode's 15-minute paycheck interval).
--
-- Milestone rewards: paid once per threshold per job, via the same
-- safe GrantCoin function used by the quest system (coin.lua, same
-- resource) — never a network event, so a client can never trigger
-- this directly.
-- ================================================================= --

local SKILL_TICK_MINUTES  = 15
local SKILL_TICK_COOLDOWN = 14 * 60 -- seconds; slightly under 15 min, small slack
local lastSkillTick = {} -- [source] = os.time()

local function checkMilestones(xPlayer, job, minutes, paidCsv)
    local paid = {}
    for entry in (paidCsv or ''):gmatch('[^,]+') do
        paid[tonumber(entry)] = true
    end

    local percent = (minutes / Config.SkillTargetMinutes) * 100
    local newlyPaid = {}

    for _, milestone in ipairs(Config.SkillMilestones) do
        if percent >= milestone.percent and not paid[milestone.percent] then
            paid[milestone.percent] = true
            table.insert(newlyPaid, milestone)
        end
    end

    if #newlyPaid == 0 then return end

    local paidList = {}
    for pct in pairs(paid) do table.insert(paidList, pct) end
    table.sort(paidList)
    local newPaidCsv = table.concat(paidList, ',')

    MySQL.Async.execute('UPDATE job_skill SET milestones_paid = @paid WHERE identifier = @identifier AND job = @job', {
        ['@paid']       = newPaidCsv,
        ['@identifier'] = xPlayer.identifier,
        ['@job']        = job,
    })

    for _, milestone in ipairs(newlyPaid) do
        GrantCoin(xPlayer.source, milestone.coin)
        TriggerClientEvent('esx:showNotification', xPlayer.source,
            ('%s Skill reached %d%%! +%s coin'):format(Config.TrackedJobs[job], milestone.percent, milestone.coin),
            'success', 'Skill Milestone')
        TriggerClientEvent('hud:achievementToast', xPlayer.source,
            ('%s Skill — %d%%'):format(Config.TrackedJobs[job], milestone.percent),
            ('+%s Coin'):format(milestone.coin))
    end
end

RegisterServerEvent('skill-track:tick')
AddEventHandler('skill-track:tick', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer then return end

    local job = xPlayer.job.name
    if not Config.TrackedJobs[job] then return end

    local now = os.time()
    if lastSkillTick[_source] and (now - lastSkillTick[_source]) < SKILL_TICK_COOLDOWN then
        return
    end
    lastSkillTick[_source] = now

    MySQL.Async.execute([[
        INSERT INTO job_skill (identifier, job, minutes) VALUES (@identifier, @job, @minutes)
        ON DUPLICATE KEY UPDATE minutes = LEAST(@target, minutes + @minutes)
    ]], {
        ['@identifier'] = xPlayer.identifier,
        ['@job']        = job,
        ['@minutes']    = SKILL_TICK_MINUTES,
        ['@target']     = Config.SkillTargetMinutes,
    }, function()
        MySQL.Async.fetchAll('SELECT minutes, milestones_paid FROM job_skill WHERE identifier = @identifier AND job = @job', {
            ['@identifier'] = xPlayer.identifier,
            ['@job']        = job,
        }, function(result)
            if result[1] then
                checkMilestones(xPlayer, job, result[1].minutes, result[1].milestones_paid)
            end
        end)
    end)
end)

ESX.RegisterServerCallback('HUD_Menu:GetSkills', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return cb({}) end

    MySQL.Async.fetchAll('SELECT job, minutes FROM job_skill WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        local minutesByJob = {}
        for i = 1, #result do
            minutesByJob[result[i].job] = result[i].minutes
        end

        local skills = {}
        for jobName, label in pairs(Config.TrackedJobs) do
            table.insert(skills, {
                label     = label,
                jobName   = jobName,
                minutes   = minutesByJob[jobName] or 0,
                target    = Config.SkillTargetMinutes,
                isCurrent = (xPlayer.job.name == jobName),
            })
        end
        cb(skills)
    end)
end)

AddEventHandler('playerDropped', function()
    lastSkillTick[source] = nil
end)

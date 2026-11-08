if not ESX then TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) end
-- Government admin: change a player's job/rank, and rename a rank of any job.
-- Only Government chief/management (grade 2+) can do it.

local function canAdmin(xPlayer)
    return xPlayer and xPlayer.job and xPlayer.job.name == 'government' and (tonumber(xPlayer.job.grade) or 0) >= 2
end

local function knownJob(job)
    if job == 'unemployed' or job == 'government' then return true end
    for _, d in ipairs(Departments or {}) do
        for _, j in ipairs(d.jobs) do if j == job then return true end end
    end
    return false
end

RegisterNetEvent('gov_admin:setJob')
AddEventHandler('gov_admin:setJob', function(targetId, job, grade)
UJLog('SERVER', ('gov_admin:setJob src=%s targetId=%s job=%s grade=%s'):format(tostring(source), tostring(targetId), tostring(job), tostring(grade)))
    local src = source
    local x = ESX.GetPlayerFromId(src)
    if not canAdmin(x) then return TriggerClientEvent('esx:showNotification', src, 'Faghat chief/management-e Government.') end
    local t = ESX.GetPlayerFromId(tonumber(targetId))
    if not t then return TriggerClientEvent('esx:showNotification', src, 'Player peyda nashod.') end
    if not knownJob(job) then return TriggerClientEvent('esx:showNotification', src, 'Job na-motabar.') end
    if OrgIsEnabled and OrgIsEnabled(job) == false then
        return TriggerClientEvent('esx:showNotification', src, '~r~In ergan khamoosh ast. Aval roshanesh konid.')
    end
    grade = math.floor(tonumber(grade) or 0)
    local jd = ESX.Jobs and ESX.Jobs[job]
    if jd and jd.grades and not (jd.grades[tostring(grade)] or jd.grades[grade]) then
        return TriggerClientEvent('esx:showNotification', src, 'In rank baraye in job vojud nadarad.')
    end
    t.setJob(job, grade)
    TriggerClientEvent('esx:showNotification', t.source, ('Job-e shoma be %s (grade %d) taghir kard.'):format(job, grade))
    TriggerClientEvent('esx:showNotification', src, ('Job-e %s be %s taghir kard.'):format(GetPlayerName(t.source), job))
end)

RegisterNetEvent('gov_admin:renameGrade')
AddEventHandler('gov_admin:renameGrade', function(job, grade, label)
UJLog('SERVER', ('gov_admin:renameGrade src=%s job=%s grade=%s label=%s'):format(tostring(source), tostring(job), tostring(grade), tostring(label)))
    local src = source
    local x = ESX.GetPlayerFromId(src)
    if not canAdmin(x) then return TriggerClientEvent('esx:showNotification', src, 'Faghat chief/management-e Government.') end
    if not knownJob(job) then return TriggerClientEvent('esx:showNotification', src, 'Job na-motabar.') end
    label = tostring(label or ''):sub(1, 40)
    if label == '' then return end
    MySQL.Async.execute('UPDATE job_grades SET label = @l WHERE job_name = @j AND grade = @g',
        { ['@l'] = label, ['@j'] = job, ['@g'] = math.floor(tonumber(grade) or 0) }, function(n)
        if not (n and n > 0) then return TriggerClientEvent('esx:showNotification', src, 'Rank peyda nashod.') end
        local g = math.floor(tonumber(grade) or 0)
        pcall(function()
            local jd = ESX.Jobs and ESX.Jobs[job]
            local gd = jd and jd.grades and (jd.grades[tostring(g)] or jd.grades[g])
            if gd then gd.label = label end
        end)
        for _, pid in ipairs(ESX.GetPlayers()) do   -- refresh the label of players who hold this rank now
            local px = ESX.GetPlayerFromId(pid)
            if px and px.job and px.job.name == job and tonumber(px.job.grade) == g then px.setJob(job, g) end
        end
        TriggerClientEvent('esx:showNotification', src, 'Esm rank avaz shod.')
    end)
end)

-- the organisation a Government member opened from F6 -> its armory / storage / vehicles
local GovActive = {}
local function validOrg(job)
    for _, d in ipairs(Departments or {}) do
        if d.id ~= 'gov' then for _, j in ipairs(d.jobs) do if j == job then return true end end end
    end
    return false
end
RegisterNetEvent('gov_admin:setActiveOrg')
AddEventHandler('gov_admin:setActiveOrg', function(org)
    local src = source
    local x = ESX.GetPlayerFromId(src)
    if not x or not x.job or x.job.name ~= 'government' then return end
    GovActive[src] = validOrg(org) and org or nil
end)
AddEventHandler('playerDropped', function() GovActive[source] = nil end)
-- Government acts with the TOP rank of the organisation it opened (used by Unique_inventory)
exports('GovEffectiveJob', function(src)
    local org = GovActive[src]
    if not org then return nil end
    local g = 0
    local jd = ESX.Jobs and ESX.Jobs[org]
    if jd and jd.grades then
        for k in pairs(jd.grades) do g = math.max(g, tonumber(k) or 0) end
    end
    return org, g
end)

local function isGovAdmin(src)
    return canAdmin(ESX.GetPlayerFromId(src))
end

RegisterNetEvent('gov_admin:broadcast')
AddEventHandler('gov_admin:broadcast', function(text)
UJLog('SERVER', ('gov_admin:broadcast src=%s text=%s'):format(tostring(source), tostring(text)))
    local src = source
    if not isGovAdmin(src) then return end
    text = tostring(text or ''):sub(1, 200)
    if text == '' then return end
    local line = '^3^*[GOVERNMENT ^7| ^3PAYAM-E RASMI] ^r^7' .. text
    for _, pid in ipairs(ESX.GetPlayers()) do
        local x = ESX.GetPlayerFromId(pid)
        if x and x.job and x.job.name ~= 'unemployed' then
            TriggerClientEvent('chatMessage', x.source, '', {255, 215, 0}, line)
        end
    end
end)

ESX.RegisterServerCallback('GovAdmin:OnlineCounts', function(source, cb)
UJLog('SERVER', ('GovAdmin:OnlineCounts source=%s'):format(tostring(source)))
    if not isGovAdmin(source) then return cb({}) end
    local counts = {}
    for _, pid in ipairs(ESX.GetPlayers()) do
        local x = ESX.GetPlayerFromId(pid)
        if x and x.job then counts[x.job.name] = (counts[x.job.name] or 0) + 1 end
    end
    cb(counts)
end)


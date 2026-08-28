-- ============================================================
-- Unique_Hud / server / scoreboard.lua
-- ============================================================

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- ✅ بازطراحی شد: شغل‌ها به ۳ ارگان گروه‌بندی شدن (طبق خواسته‌ی شما)، و بخش
-- وضعیت دزدی‌ها کلاً حذف شد. اسم‌های شغل زیر دقیقاً از esx_society/config.lua
-- خودتون تأیید شده (police, sheriff, mt, cid, cia, marshal, fbi, judge, doa,
-- taxi, mechanic, ambulance, weazel).
local Organizations = {
    {
        key = 'doj',
        label = 'Department Of Justice',
        jobs = { 'cid', 'cia', 'marshal', 'fbi', 'judge', 'doa' },
    },
    {
        key = 'law',
        label = 'Law Enforcement',
        jobs = { 'police', 'sheriff', 'mt' },
    },
    {
        key = 'organ',
        label = 'Organ Services',
        jobs = { 'taxi', 'mechanic', 'ambulance', 'weazel' },
    },
}

local function GetOnlinePlayers()
    local list = {}
    for _, playerId in ipairs(GetPlayers()) do
        local xPlayer = ESX.GetPlayerFromId(tonumber(playerId))
        if xPlayer then
            table.insert(list, xPlayer)
        end
    end
    return list
end

ESX.RegisterServerCallback('Unique_Hud:scoreboard:getCounts', function(source, cb)
    local players = GetOnlinePlayers()

    local jobCounts = {}
    for _, org in ipairs(Organizations) do
        for _, jobName in ipairs(org.jobs) do
            jobCounts[jobName] = 0
        end
    end

    local gangCounts = {}
    local admins = {}

    for _, xPlayer in ipairs(players) do
        if xPlayer.job and jobCounts[xPlayer.job.name] ~= nil then
            jobCounts[xPlayer.job.name] = jobCounts[xPlayer.job.name] + 1
        end

        if xPlayer.gang and xPlayer.gang.name and xPlayer.gang.name ~= 'nogang' then
            local gLabel = xPlayer.gang.label or xPlayer.gang.name
            gangCounts[gLabel] = (gangCounts[gLabel] or 0) + 1
        end

        -- permission_level >= 1 یعنی حداقل ادمینه (همون معیاری که خودِ
        -- essentialmode برای دستورهای ادمین استفاده می‌کنه).
        if xPlayer.permission_level and xPlayer.permission_level >= 1 then
            table.insert(admins, { name = xPlayer.name, level = xPlayer.permission_level })
        end
    end

    local gangList = {}
    for label, count in pairs(gangCounts) do
        table.insert(gangList, { label = label, count = count })
    end

    cb({
        total = #players,
        jobs = jobCounts,
        gangs = gangList,
        admins = admins,
        maxPlayers = GetConvarInt('sv_maxclients', 48),
    })
end)

-- ============================================================
-- Unique_Hud / server / scoreboard.lua
-- ============================================================
-- توضیح مهم: مرجعی که فرستادید ۹ تا دسته‌ی دزدی مخصوص خودِ Sunset داشت
-- (Bank/SheriffBank/Cargo/Bimeh/Feleca/Minibank/JewelerySheriff/mythic...)
-- که هیچ‌کدوم با سیستم دزدی واقعی شما (Unique_AllRobs) مطابقت نداشت. به‌جای
-- ساختن یه پنل قلابی با دیتای الکی، اینجا به دسته‌های واقعی خودتون
-- (Shop, Jewerlly, Minibank, Palateo_Bank, Life_Invader) وصل شده - یه export
-- کوچیک و فقط-خواندنی هم به Unique_AllRobs/server.lua اضافه شد که این
-- دیتا رو بده (هیچ رفتار موجودی رو عوض نکرد).

ESX = nil
CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(0)
    end
end)

local TrackedJobs = { 'police', 'fbi', 'mt', 'ambulance', 'weazel', 'mechanic', 'taxi' }

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
    for _, jobName in ipairs(TrackedJobs) do
        jobCounts[jobName] = 0
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

    local robStatus = {}
    local ok, result = pcall(function()
        return exports['Unique_AllRobs']:GetRobStatusSummary()
    end)
    if ok and result then
        robStatus = result
    end

    cb({
        total = #players,
        jobs = jobCounts,
        gangs = gangList,
        admins = admins,
        robs = robStatus,
        maxPlayers = GetConvarInt('sv_maxclients', 48),
    })
end)
